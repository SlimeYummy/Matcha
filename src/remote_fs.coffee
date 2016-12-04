# # # # # # # # # # # # # # # # # # # #
# remote_fs.coffee
# # # # # # # # # # # # # # # # # # # #

{coroutine} = require("./async_util.coffee")
fileUtil = require("./file_util.coffee")
sshUtil = require("./ssh_util.coffee")

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
        return sshUtil.sftpDownland(@_sftpClient, info.diskPath, localDiskPath)

    upland: (remotePath, localDiskPath) ->
        fileInfo = @filesMap[remotePath]
        if fileInfo
            return sshUtil.sftpUpland(@_sftpClient, fileInfo.diskPath, localDiskPath)
        return coroutine () =>
            # create folder
            prevDirInfo = @dirsMap[""]
            for idx in [0...remotePath.length] by 1
                if "/" == remotePath[idx]
                    subPath = remotePath[...idx]
                    dirInfo = @dirsMap[subPath]
                    if not dirInfo
                        prevDirInfo.children = prevDirInfo.children + 1
                        subDiskPath = fileUtil.normalize("#{@rootPath}/#{subPath}")
                        dirInfo = new fileUtil.DirInfo(subPath, subDiskPath)
                        @dirsMap[subPath] = dirInfo
                        yield sshUtil.sftpMkdir(@_sftpClient, dirInfo.diskPath)
                    prevDirInfo = dirInfo
            # upland file
            prevDirInfo.children = prevDirInfo.children + 1
            remoteDiskPath = fileUtil.normalize("#{@rootPath}/#{remotePath}")
            fileInfo = new fileUtil.FileInfo(remotePath, remoteDiskPath)
            @filesMap[remotePath] = fileInfo
            yield sshUtil.sftpUpland(@_sftpClient, fileInfo.diskPath, localDiskPath)
            return

    delete: (remotePath) ->
        fileInfo = @filesMap[remotePath]
        if not @filesMap[remotePath]
            return Promise.reject(new Error("File not found : #{remotePath}"))
        return coroutine () =>
            # remove file
            delete @filesMap[remotePath]
            yield sshUtil.sftpUnlink(@_sftpClient, fileInfo.diskPath)
            # remove folder
            for idx in [remotePath.length-1..0] by -1
                if "/" == remotePath[idx]
                    subPath = remotePath[...idx]
                    dirInfo = @dirsMap[subPath]
                    dirInfo.children = dirInfo.children - 1
                    if 0 == dirInfo.children
                        delete @dirsMap[subPath]
                        yield sshUtil.sftpRmdir(@_sftpClient, dirInfo.diskPath)
                    else
                        break
            return

RemoteFs.create = (options, rootPath) ->
    return coroutine () ->
        ins = new RemoteFs()
        ins.rootPath = fileUtil.normalize("#{rootPath}/")
        # create ssh link
        ins._sshClient = yield sshUtil.createSshLink(options)
        # create sftp link
        ins._sftpClient = yield sshUtil.createSftpLink(ins._sshClient)
        # scan root dir
        parentStack = ["", ins.rootPath]
        while parentStack.length > 0
            parent = parentStack.shift()
            remoteParent = parentStack.shift()
            infosArray = yield sshUtil.sftpReaddir(ins._sftpClient, remoteParent)
            ins.dirsMap[parent] = new fileUtil.DirInfo(parent, remoteParent, infosArray.length)
            for info in infosArray
                remoteChild = fileUtil.normalize("#{ins.rootPath}/#{parent}/#{info.filename}")
                child = remoteChild[ins.rootPath.length...]
                if "d" == info.longname[0]
                    parentStack.push(child, remoteChild)
                else
                    ins.filesMap[child] = new fileUtil.FileInfo(child, remoteChild, info.attrs.mtime)
        return ins

RemoteFs.destory = (remoteFs) ->
    if remoteFs
        sshUtil.destorySshLink(remoteFs._sshClient)
    return

RemoteFs.create({
    host: 'fenqi.io'
    port: 22,
    username: 'nanuno',
    password: "jbcnmb8888"
}, "/home/nanuno")

module.exports = RemoteFs
