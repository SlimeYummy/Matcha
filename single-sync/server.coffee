# # # # # # # # # # # # # # # # # # # #
# server.coffee
# # # # # # # # # # # # # # # # # # # #

const = require("const")
file = require("file_util")
net = require("net_util")

$rootPath = ""

serverHelloWorld = (request, response) ->
    response.write("Hello world !")
    response.end()
    return

serverSyncStart = (request, response) ->
    allArray = scanPath($rootPath)
    deleteArray = listDeletePath($rootPath, allArray)
    for deletePath in deleteArray
        deleteFile(deletePath)
    updateArray = listUpdatePath($rootPath, updateArray)
    response.write({
        status: "OK"
        updateArray: updateArray
    })
    response.end()
    return

serverSyncData = (request, response) ->
    subPath = request.getHeader("matcha_path")
    if not subPath
        response.setHeader("motcha_status", "ERR")
        response.setHeader("motcha_message", "Miss field path")
        response.end()
        return
    writeStream = writeFile($rootPath, subPath)
    request.pipe(writeStream)
    writeStream.on "end", () ->
        response.setHeader("motcha_status", "OK")
    return

serverEntry = (request, response) ->
    path = url.parse(request.url, true)
    switch path.pathname
        when "/start"
            httpStart(request, response)
        when "/data"
            fileSyncData(request, response)
        when "/end"
            fileSyncEnd(request, response)
        when "/cancel"
            fileSyncCancel(request, response)
    return

server = new http.Server()
server.on("request", serverEntry)
server.listen(NET_PORT)