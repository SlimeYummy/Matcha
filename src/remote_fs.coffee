# # # # # # # # # # # # # # # # # # # #
# remote_fs.coffee
# # # # # # # # # # # # # # # # # # # #

path = require("path").posix
ssh = require("ssh2")
{coroutine} = require("./async_util.coffee")
{FileInfo, FileDir} = require("./fs_info.coffee")

class RemoteFs
    constructor: () ->
        @rootPath = ""
        @_sshClient = null
        @_sftpClient = null
        @dirsMap = Object.create(null)
        @filesMap = Object.create(null)
        return

    downland: (remotePath, localDiskPath) ->
        info = @filesMap[remotePath]
        if not info
            return Promise.reject(new Error("File not found : #{remotePath}"))
        return sftpDownland(@_sftpClient, info.diskName, localDiskPath)

    upland: (remotePath, localDiskPath) ->
        fileInfo = @filesMap[remotePath]
        if fileInfo
            return sftpUpland(@_sftpClient, fileInfo.diskName, localDiskPath)
        return coroutine () ->
            # create folder
            prevDirInfo = @dirsMap[""]
            for idx in [0...remotePath.length] by 1
                if "/" == remotePath[idx]
                    subPath = remotePath[...idx]
                    dirInfo = @dirsMap[subPath]
                    if not dirInfo
                        prevDirInfo.children = prevDirInfo.children + 1
                        dirInfo = new DirInfo(dirPath, "#{@rootPath}/#{dirPath}")
                        @dirsMap[dirPath] = dirInfo
                        yield sftpMkdir(@_sftpClient, subPath)
                    prevDirInfo = dirInfo
            # upland file
            prevDirInfo.children = prevDirInfo.children + 1
            fileInfo = new FileInfo(remotePath, "#{@rootPath}/#{remotePath}")
            @filesMap[remotePath] = fileInfo
            yield sftpUpland(@_sftpClient, remotePath, localDiskPath)
            return

    delete: (remotePath) ->
        fileInfo = @filesMap[remotePath]
        if not @filesMap[remotePath]
            return Promise.reject(new Error("File not found : #{remotePath}"))
        return coroutine () ->
            # remove file
            delete @filesMap[remotePath]
            yield sftpUnlink(@_sftpClient, remotePath)
            # remove folder
            for idx in [remotePath.length-1..0] by -1
                if "/" == remotePath[idx]
                    subPath = remotePath[...idx]
                    dirInfo = @dirsMap[subPath]
                    dirInfo.children = dirInfo.children - 1
                    if 0 == @dirsMap[subPath]
                        delete @dirsMap[subPath]
                        yield sftpRmdir(@_sftpClient, subPath)
                    else
                        break
            return

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
            infosArray = yield sftpReaddir(sftpClient, remoteParent)
            ins.dirsMap[parent] = new DirInfo(parent, remoteParent, infosArray.length)
            for info in infosArray
                remoteChild = path.normalize("#{ins.rootPath}/#{parent}/#{info.filename}")
                child = remoteChild[ins.rootPath.length...]
                if "d" == info.longname[0]
                    parentStack.push(child, remoteChild)
                else
                    ins.filesMap[child] = new FileInfo(child, remoteChild, info.attrs.mtime)
        return

RemoteFs.destory = (remoteFs) ->
    if remoteFs
        remoteFs.@_sshClient.end()
    return

RemoteFs.create({
    host: 'fenqi.io'
    port: 22,
    username: 'nanuno',
    password: "jbcnmb8888"
}, "/home/nanuno")

exports.RemoteFs = RemoteFs
