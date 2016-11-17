# # # # # # # # # # # # # # # # # # # #
# net_util.coffee
# # # # # # # # # # # # # # # # # # # #

http = require("http")

httpStream = (options, reqData, callback) ->
    request = http.request(options)
    request.setTimeout CLIENT_TIMEOUT, () ->
        callback()
    request.on "error", (error) ->
        callback(error)
    request.on "response", (resData) ->
        callback(null, resData)
    if request
        if "function" == request.pipe # stream
            request.pipe(reqData)
        else
            request.write(reqBody)
            request.end()
    return

httpText = (options, reqData, callback) ->
    httpRequest options, reqData, (error, outStream) ->
        if error
            callback(error, null)
        else
            outStream.on 'data', (chunk) ->
                chunkArray.push(chunk)
            chunkArray = []
            outStream.on 'error', (error) ->
                callback(error, null)
            outStream.on 'end', () ->
                text = chunkArray.join()
                callback(null, text)
    return

httpJson = (options, reqData, callback) ->
    httpRequest options, reqData, (error, outStream) ->
        if error
            callback(error, null)
        else
            outStream.on 'error', (error) ->
                callback(error, null)
            chunkArray = []
            outStream.on 'data', (chunk) ->
                chunkArray.push(chunk)
            outStream.on 'end', () ->
                try
                    text = chunkArray.join()
                    json = JSON.parse(text)
                    callback(null, json)
                catch error
                    callback(error, null)
    return
