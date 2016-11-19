# # # # # # # # # # # # # # # # # # # #
# client.coffee
# # # # # # # # # # # # # # # # # # # #

stream = require("stream")
ssh = require("ssh2")
{MappingFileSystem} = require("../util/file-system")
{def} = require("./define")

class RemoteFileSystem
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

RemoteFileSystem.create(rootPath, callback) ->
    ins = new RemoteFileSystem()
    ins._rootPath = path.normalize("#{rootPath}/")[...-1]
    ins._filesMap = Object.create(null)
    ins._dirsMap = Object.create(null)
    scanStack = new Array()
    scanStack.push(rootPath)
    travel = () ->
        parent = scanStack.pop()
        sftpClient.readdir realPath, (err, infosArray) ->
            for info in infosArray
                if "d" == info.longname[0]
                    @_dirsMap["#{parent}/#{info.filename}"] = new DirInfo()
                    scanStack.push("#{parent}/#{info.filename}")
                else
                    @_filesMap["#{parent}/#{info.filename}"] = new FileInfo()
            if scanStack.length > 0
                travel()
            return
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

sshClient.connext {
    host: '192.168.100.100'
    port: 22
    username: 'frylock'
    password: 'nodejsrules'
}


clientHelloWorld = () ->
    request = http.get("http://#{def.NET_HOST}:#{def.NET_PORT}#{def.PATH_HELLO_WORLD}")
    request.setTimeout CLIENT_TIMEOUT, () ->
        printTimeOut(PATH_HELLO_WORLD)
    request.on "response", (response) ->
        readStreamText response, (err, text) ->
            if err
                printERR(PATH_HELLO_WORLD, err)
            else
                console.log(text)
    return

clientSyncStart = (fileSystem) ->
    filesMap = Object.create(null)
    fileSystem.forEach (info) ->
        filesMap[info.name] = info.mtime
    filesJson = JSON.stringify filesMap
    options = {
        host: NET_HOST
        port: NET_PORT
        method: "POST"
        path: PATH_SYNC_START
    }
    callback = (error, json) ->
        if err
            printERR(PATH_SYNC_START, err)
        else if "OK" != json.status
            printERR(PATH_SYNC_START, json)
        else
            info = ""
            for file in json.deleteArray
                info += "#{Delete} - #{file}\n"
            console.log(info)
    httpJson options, filesJson, callback
    return

clientSyncData = (fileSystem, fileNamesArray) ->
    startCount = 0
    finishCount = 0
    transferFunc = () ->
        fileName = fileNamesArray[startCount]
        startCount = startCount + 1
        fileStream = fileStream.readStream(fileName)
        options = {
            host: NET_HOST
            port: NET_PORT
            method: "POST"
            path: PATH_SYNC_DATA
        }
        callback = (error, json) ->
            if error
                printERR(PATH_SYNC_DATA, error)
            else if "OK" != json.status
                printERR(PATH_SYNC_DATA, json)
            else
                console.log("#{Update} - #{file}\n")
            if startCount < fileNamesArray.length
                transferFunc()
            finishCount = finishCount + 1
            if finishCount >= fileNamesArray.length
                # next
    return

clientSyncFinish = () ->
    options = {
        method: "GET"
        host: NET_HOST
        port: NET_PORT
        path: PATH_SYNC_DATA
    }
    callback = (error, json) ->
        if error
            print()
        else if "OK" != json.status
            print()
        else
            print(json.info)
    httpJson(options, null, callback)
    return
