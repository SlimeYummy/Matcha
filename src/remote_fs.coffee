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

createSshLink = (options) ->
    return new Promise (resolve, reject) ->
        sshClient = new ssh.Client()
        sshClient.connect(options)
        sshClient.on "error", (error) ->
            return reject(error)
        sshClient.on "ready", () ->
            return resolve(sshClient)

createSftpLink = (sshClient, options) ->
    return new Promise (resolve, reject) ->
        sshClient.sftp (error, sftpClient) ->
            if error
                return reject(error)
            return resolve(sftpClient)

sftpUpland = (sftpClient, remotePath, localPath) ->
    return new Promise (resolve, reject) ->
        sftpClient.fastGet remotePath, localPath, (error) ->
            if error
                return reject(error)
            return resolve()

sftpDownland = (sftpClient, remotePath, localPath) ->
    return new Promise (resolve, reject) ->
        sftpClient.fastPut remotePath, localPath, (error) ->
            if error
                return reject(error)
            return resolve()

sftpUnlink = (sftpClient, remotePath) ->
    return new Promise (resolve, reject) ->
        sftpClient.unlink remotePath, (error) ->
            if error
                return reject(error)
            return resolve()

sftpReaddir = (sftpClient, remotePath) ->
    return new Promise (resolve, reject) ->
        sftpClient.readdir remotePath, (error) ->
            if error
                return reject(error)
            return resolve(infosArray)

sftpMkdir = (sftpClient, remotePath) ->
    return new Promise (resolve, reject) ->
        sftpClient.mkdir remotePath, (error) ->
            if error
                return reject(error)
            return resolve()

sftpRmdir = (sftpClient, remotePath) ->
    return new Promise (resolve, reject) ->
        sftpClient.rmdir remotePath, (error) ->
            if error
                return reject(error)
            return resolve()

RemoteFs.create = (options, rootPath) ->
    return coroutine () ->
        ins = new RemoteFs()
        ins.rootPath = path.normalize("#{rootPath}/")
        # create ssh link
        ins._sshClient = yield createSshLink(options)
        # create sftp link
        ins._sftpClient = yield createSftpLink(ins._sshClient)
        # scan root dir
        parentStack = ["", ins.rootPath]
        while parentStack.lenght > 0
            parent = parentStack.shift()
            remoteParent = parentStack.shift()
            console.log("L:#{parent}\nR:#{remoteParent}\n")
            infosArray = yield sftpReaddir sftpClient, remoteParent
            ins._dirsMap[parent] = new DirInfo(parent, remoteParent, infosArray.length)
            for info in infosArray
                remoteChild = path.normalize("#{ins.rootPath}/#{parent}/#{info.filename}")
                child = remoteChild[ins.rootPath.length...]
                if "d" == info.longname[0]
                    parentStack.push(child, remoteChild)
                else
                    ins._filesMap[child] = new FileInfo(child, remoteChild, info.attrs.mtime)
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
