# # # # # # # # # # # # # # # # # # # #
# ssh.coffee
# # # # # # # # # # # # # # # # # # # #

ssh = require("ssh2")

class SftpFileSystem
    constructor: () ->
        @_sshClient = null
        @_sftpClient = null
        @_dirsMap = Object.create(null)
        @_filesMap = Object.create(null)
        return

    _sftpRead_ = (localPath, remotePath, callback) ->
        return (error) ->
            if error
                callback(error)
            else
                @_sftp.fastGet(remotePath, localPath, callback)

    _sftpWrite_ = (localPath, remotePath, callback) ->
        return (error) ->
            if error
                callback(error)
            else
                @_sftp.fastPut(remotePath, localPath, callback)

    _sftpUnlink_ = (remotePath, callback) ->
        return (error) ->
            if error
                callback(error)
            else
                @_sftp.unlink(remotePath, callback)

    _sftpMkdir_ = (remotePath, callback) ->
        return (error) ->
            if error
                callback(error)
            else
                @_sftp.mkdir(remotePath, callback)

    _sftpRmdir_ = (sftpClient, remotePath, callback) ->
        return (error) ->
            if error
                callback(error)
            else
                @_sftp.rmdir(remotePath, callback)

    readFile: (remotePath, localPath, callback) ->
        if not @_filesMap[remotePath]
            process.nextTick(callback, new Error(""))
        else
            readFunc = @_sftpRead_(remotePath, localPath, callback)
            readFunc(null)
        return

    writeFile: (remotePath, localPath, callback) ->
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
            process.nextTick(callback, new Error(""))
        else
            entryFunc = @_sftpUnlink_(remotePath, callback)
            for idx in [remotePath.length-1..0] by -1
                if "/" == remotePath[idx]
                    subPath = remotePath[...idx]
                    @_dirsMap[subPath] = @_dirsMap[subPath] - 1
                    if 0 == @_dirsMap[subPath]
                        delete @_dirsMap[subPath]
                        entryFunc = @_sftpRmdir_(subPath, entryFunc)
                    else
                        @_dirsMap[subPath] = @_dirsMap[subPath] + 1
                        break
            entryFunc(null)
        return

    destory: () ->
        @_sshClient.end()

scanSftpFolder = (sftpClient, rootPath) ->
    return new Promise (resolve, reject) ->
        rootPath = path.normalize("#{rootPath}/")[...-1]
        filesMap = Object.create(null)
        dirsMap = Object.create(null)
        scanStack = new Array()
        scanStack.push("")
        travel = () ->
            parent = scanStack.pop()
            sftpParent = "#{rootPath}/#{parent}"
            sftpClient.readdir sftpParent, (error, infosArray) ->
                if error
                    reject(error)
                else
                    dirsMap[parent] = new SftpDirInfo(parent, sftpParent, infosArray.length)
                    for info in infosArray
                        child = "#{parent}/#{info.filename}"
                        if "d" == info.longname[0]
                            scanStack.push(child)
                        else
                            sftpChild = "#{rootPath}/#{parent}/#{info.filename}"
                            dirsMap[child] = new SftpFileInfo(child, sftpChild, info.attrs.mtime)
                if scanStack.length > 0
                    travel()
                else
                    resolve { filesMap, dirsMap }


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

class RemoteFileSystem
    constructor: () ->
        @_rootPath = ""
        @_sshClient = null
        @_sftpClient = null
        @_dirsMap = Object.create(null)
        @_filesMap = Object.create(null)
        return

create = (options, rootPath) ->
    ins = new RemoteFileSystem()
    ins._rootPath = rootPath
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
        parentStack = [".", ins._rootPath]
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
                    remoteChild = "#{ins._rootPath}/#{parent}/#{info.filename}"
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

create({
    host: 'fenqi.io'
    port: 22,
    username: 'nanuno',
    password: "jbcnmb8888"
}, ".")
