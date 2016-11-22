# # # # # # # # # # # # # # # # # # # #
# ssh.coffee
# # # # # # # # # # # # # # # # # # # #

path = require("path").posix
ssh = require("ssh2")

class FileInfo
    constructor: (name, sftpName, mtime) ->
        @name = name
        @remoteName = sftpName
        @mtime = mtime
        return

class DirInfo
    constructor: (name, sftpName, children) ->
        @name = name
        @remoteName = sftpName
        @children = children
        return

class RemoteFs
    constructor: () ->
        @rootPath = ""
        @_sshClient = null
        @_sftpClient = null
        @_dirsMap = Object.create(null)
        @_filesMap = Object.create(null)
        return

    _get_ = (localPath, remotePath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.fastGet remotePath, localPath, (error) ->
                if error
                    return reject(error)
                return resolve()

    _put_ = (localPath, remotePath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.fastPut remotePath, localPath, (error) ->
                if error
                    return reject(error)
                return resolve()

    _unlink_ = (remotePath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.unlink remotePath, (error) ->
                if error
                    return reject(error)
                return resolve()

    _mkdir_ = (remotePath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.mkdir remotePath, (error) ->
                if error
                    return reject(error)
                return resolve()

    _rmdir_ = (remotePath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.rmdir remotePath, (error) ->
                if error
                    return reject(error)
                return resolve()

    getFile: (localPath, remotePath) ->
        if not @_filesMap[remotePath]
            return Promise.reject(new Error("File not found : #{remotePath}"))
        return @_get_(localPath, remotePath)

    putFile: (remotePath, localPath) ->
        entryFunc = @_sftpWrite_(remotePath, localPath, callback)
        for idx in [remotePath.length-1..0] by -1
            if "/" == remotePath[idx]
                subPath = remotePath[...idx]
                if not @_dirsMap[subPath]
                    @_dirsMap[subPath] = 1
                    entryFunc = @_sftpMkdir_(subPath, entryFunc)
                else
                    @_dirsMap[subPath] = @_dirsMap[subPath] + 1
                    break
        entryFunc(null)
        return

    removeFile: (remotePath, callback) ->
        if not @_filesMap[remotePath]
            return Promise.reject(new Error("File not found : #{remotePath}"))
        promise = @_unlink_(remotePath)
        for idx in [remotePath.length-1..0] by -1
            if "/" == remotePath[idx]
                subPath = remotePath[...idx]
                @_dirsMap[subPath] = @_dirsMap[subPath] - 1
                if 0 == @_dirsMap[subPath]
                    delete @_dirsMap[subPath]
                    promise = promise.then () ->
                        return @_rmdir_(subPath)
                else
                    @_dirsMap[subPath] = @_dirsMap[subPath] + 1
                    break
        return promise

RemoteFs.create = (options, rootPath) ->
    ins = new RemoteFs()
    ins.rootPath = path.normalize("#{rootPath}/")[...-1]
    initSSH = (resolve, reject) ->
        ins._sshClient = new ssh.Client()
        ins._sshClient.connect(options)
        ins._sshClient.on "error", (error) ->
            return reject(error)
        ins._sshClient.on "ready", () ->
            return resolve()
    return new Promise(initSSH)
    .then () ->
        initSFTP = (resolve, reject) ->
            ins._sshClient.sftp (error, sftpClient) ->
                if error
                    return reject(error)
                ins._sftpClient = sftpClient
                return resolve()
        return new Promise(initSFTP)
    .then () ->
        parentStack = ["", ins.rootPath]
        travelDir = (resolve, reject) ->
            parent = parentStack.shift()
            remoteParent = parentStack.shift()
            console.log("L:#{parent}\nR:#{remoteParent}\n")
            ins._sftpClient.readdir remoteParent, (error, infosArray) ->
                if error
                    return reject(error)
                ins._dirsMap[parent] = new DirInfo(parent, remoteParent, infosArray.length)
                for info in infosArray
                    child = "#{parent}/#{info.filename}"
                    remoteChild = "#{ins.rootPath}/#{parent}/#{info.filename}"
                    if "d" == info.longname[0]
                        parentStack.push(child, remoteChild)
                    else
                        ins._filesMap[child] = new FileInfo(child, remoteChild, info.attrs.mtime)
                if 0 != parentStack.length
                    return resolve(new Promise(travelDir))
                else
                    return resolve()
        return new Promise(travelDir)
    .then () ->
        console.log ins._filesMap
        console.log ins._dirsMap
    .catch (error) ->
        if ins._sshClient
            ins._sshClient.end()
        console.log(error)

RemoteFs.create({
    host: 'fenqi.io'
    port: 22,
    username: 'nanuno',
    password: "jbcnmb8888"
}, "/home/nanuno")
