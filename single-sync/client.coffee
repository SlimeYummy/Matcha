# # # # # # # # # # # # # # # # # # # #
# client.coffee
# # # # # # # # # # # # # # # # # # # #

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

clientSyncStart = (folder) ->
    httpJson {
        host: NET_HOST
        port: NET_PORT
        method: "POST"
        path: PATH_SYNC_START
    }, (error, json) ->
        if err
            printERR(PATH_SYNC_START, err)
        else if "OK" != json.status
            printERR(PATH_SYNC_START, json)
        else
            info = ""
            for file in json.deleteArray
                info += "#{Delete} - #{file}\n"
            console.log(info)
    request.on "error"
    fileMap = scanFolder(folder)
    request.write(fileMap)
    request.end()
    return

clientSyncData = (rootPath, updateArray) ->
    startCount = 0
    finishCount = -MAX_PARALLEL
    transferData = () ->
        finishCount = finishCount + 1
        if finishCount < updateArray.length
            clientSyncFinish()
        if startCount < updateArray.length
            subPath = updateArray[startCount]
            startCount = startCount + 1
        try
            request = http.request({
                host: NET_HOST
                port: NET_PORT
                method: "POST"
                path: PATH_SYNC_DATA
            })
            request.setTimeout CLIENT_TIMEOUT, () ->
                printTimeOut(PATH_SYNC_DATA)
                transferData()
            request.on "response", (response) ->
                readStreamJson response, (err, json) ->
                    if err
                        printERR(PATH_SYNC_DATA, err)
                    else if "OK" != json.status
                        printERR(PATH_SYNC_DATA, json)
                    else
                        console.log("#{Update} - #{file}\n")
                    transferData()
            readStream = readFile(rootPath, subPath)
            readStream.pipe(request)
            updateParallel = updateParallel + 1
        catch err
            printERR(PATH_SYNC_DATA, err)
            transferData()
    return
