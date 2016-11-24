# # # # # # # # # # # # # # # # # # # #
# remote_fs.coffee
# # # # # # # # # # # # # # # # # # # #

path = require("path").posix
ssh = require("ssh2")
{coroutine} = require("./async_util.coffee")

class FileInfo
    constructor: (name, diskName, mtime) ->
        @name = name
        @diskName = diskName
        @mtime = mtime or new Date()
        return

class DirInfo
    constructor: (name, diskName, children) ->
        @name = name
        @diskName = diskName
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

    find: (name) ->
        return @_filesMap[name]

    forEach: (func) ->
        for _, fileInfo of @_filesMap
            func(fileInfo)
        return

    _get_ = (remoteDiskPath, localDiskPath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.fastGet remoteDiskPath, localDiskPath, (error) ->
                if error
                    return reject(error)
                return resolve()

    _put_ = (remoteDiskPath, localDiskPath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.fastPut remoteDiskPath, localDiskPath, (error) ->
                if error
                    return reject(error)
                return resolve()

    _unlink_ = (remoteDiskPath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.unlink remoteDiskPath, (error) ->
                if error
                    return reject(error)
                return resolve()

    _mkdir_ = (remoteDiskPath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.mkdir remoteDiskPath, (error) ->
                if error
                    return reject(error)
                return resolve()

    _rmdir_ = (remoteDiskPath) ->
        sftpClient = @_sftpClient
        return new Promise (resolve, reject) ->
            sftpClient.rmdir remoteDiskPath, (error) ->
                if error
                    return reject(error)
                return resolve()

    downland: (remotePath, localDiskPath) ->
        info = @_filesMap[remotePath]
        if not info
            return Promise.reject(new Error("File not found : #{remotePath}"))
        return @_get_(info.diskName, localDiskPath)

    upland: (remotePath, localDiskPath) ->
        fileInfo = @_filesMap[remotePath]
        if fileInfo
            return @_sftpWrite_(fileInfo.diskName, localDiskPath)
        return coroutine () ->
            # create folder
            prevDirInfo = @_dirsMap[""]
            for idx in [0...remotePath.length] by 1
                if "/" == remotePath[idx]
                    subPath = remotePath[...idx]
                    dirInfo = @_dirsMap[subPath]
                    if not dirInfo
                        prevDirInfo.children = prevDirInfo.children + 1
                        dirInfo = new DirInfo(dirPath, "#{@rootPath}/#{dirPath}")
                        @_dirsMap[dirPath] = dirInfo
                        yield @_sftpMkdir_(subPath)
                    prevDirInfo = dirInfo
            # create file
            prevDirInfo.children = prevDirInfo.children + 1
            fileInfo = new FileInfo(remotePath, "#{@rootPath}/#{remotePath}")
            @_filesMap[remotePath] = fileInfo
            # write file
            yield @_sftpWrite_(remotePath, localDiskPath)
            return

    remove: (remotePath) ->
        fileInfo = @_filesMap[remotePath]
        if not @_filesMap[remotePath]
            return Promise.reject(new Error("File not found : #{remotePath}"))
        return coroutine () ->
            # remove file
            delete @_filesMap[remotePath]
            yield @_unlink_(remotePath)
            # remove folder
            for idx in [remotePath.length-1..0] by -1
                if "/" == remotePath[idx]
                    subPath = remotePath[...idx]
                    dirInfo = @_dirsMap[subPath]
                    dirInfo.children = dirInfo.children - 1
                    if 0 == @_dirsMap[subPath]
                        delete @_dirsMap[subPath]
                        yield @_rmdir_(subPath)
                    else
                        break
            return

RemoteFs.create = (options, rootPath) ->
    ins = new RemoteFs()
    ins.rootPath = path.normalize("#{rootPath}/")
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
                    remoteChild = path.normalize("#{ins.rootPath}/#{parent}/#{info.filename}")
                    child = remoteChild[ins.rootPath.length...]
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
        return ins
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

exports.RemoteFs = RemoteFs
