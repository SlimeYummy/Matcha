# # # # # # # # # # # # # # # # # # # #
# client.coffee
# # # # # # # # # # # # # # # # # # # #

stream = require("stream")
ssh = require("ssh2")
{MappingFileSystem} = require("../util/file-system")
{def} = require("./define")


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
