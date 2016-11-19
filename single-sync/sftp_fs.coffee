# # # # # # # # # # # # # # # # # # # #
# sftp_fs.coffee
# # # # # # # # # # # # # # # # # # # #

ssh = require("ssh2")

class SftpFileInfo
    constructor: (name, sftpName, mtime) ->
        @name = name
        @sftpName = sftpName
        @mtime = mtime
        return

class SftpDirInfo
    constructor: (name, sftpName, children) ->
        @name = name
        @sftpName = sftpName
        @children = children
        return

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

    _sftpWrite_ = (localPath, remotePath, callback)) ->
        return (error) ->
            if error
                callback(error)
            else
                @_sftp.fastPut(remotePath, localPath, callback)

    _sftpUnlink_ = (remotePath, callback)) ->
        return (error) ->
            if error
                callback(error)
            else
                @_sftp.unlink(remotePath, callback)

    _sftpMkdir_ = (remotePath, callback)) ->
        return (error) ->
            if error
                callback(error)
            else
                @_sftp.mkdir(remotePath, callback)

    _sftpRmdir_ = (sftpClient, remotePath, callback)) ->
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

createSshAndSftp = (options) ->
    return new Promise (resolve, reject) ->
        sshClient = new ssh.Client()
        sshClient.on "error", (error) ->
            reject(error)
        sshClient.on "ready", () ->
            sshClient.sftp (error, sftpClient) ->
                if error
                    sshClient.end()
                    reject(error)
                else
                    resolve { sshClient, sftpClient }
        sshClient.context(options)

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

SftpFileSystem.create(options, rootPath, callback) ->
    ins = new SftpFileSystem()
    createSshAndSftp options
    .then (args) ->
        ins._sshClient = args.sshClient
        ins._sftpClient = args.sftpClient
    .then(scanSftpFolder(ins._sftpClient, rootPath))
    .then (args) ->
        ins._filesMap = filesMap
        ins._dirsMap = dirsMap
    .catch (error) ->
        # ...
    return

sshClient = new ssh.Client()
sshClient.on "ready", () ->
    console.log('Client :: ready');
    sshClient.sftp(function(err, sftpClient) {
    if (err) throw err;
    sftpClient.readdir('foo', function(err, list) {
        if (err) throw err;
        console.dir(list);
        conn.end();
    });

SftpFs.destory = () ->
    return
