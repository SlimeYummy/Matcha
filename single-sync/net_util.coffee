# # # # # # # # # # # # # # # # # # # #
# net_util.coffee
# # # # # # # # # # # # # # # # # # # #

http = require("http")

httpStream = (httpArgs, callback) ->
    request = http.request(httpArgs)
    request.setTimeout CLIENT_TIMEOUT, () ->
        callback()
    request.on "error", (error) ->
        callback(error)
    request.on "response", (stream) ->
        callback(null, stream)
    return

httpText = (httpArgs, callback) ->
    httpRequest httpArgs, (error, stream) ->
        if error
            callback(error, null)
        else
            stream.on 'data', (chunk) ->
                chunkArray.push(chunk)
            chunkArray = []
            stream.on 'error', (error) ->
                callback(error, null)
            stream.on 'end', () ->
                text = chunkArray.join()
                callback(null, text)
    return

httpJson = (httpArgs, callback) ->
    httpRequest httpArgs, (error, stream) ->
        if error
            callback(error, null)
        else
            stream.on 'error', (error) ->
                callback(error, null)
            chunkArray = []
            stream.on 'data', (chunk) ->
                chunkArray.push(chunk)
            stream.on 'end', () ->
                try
                    text = chunkArray.join()
                    json = JSON.parse(text)
                    callback(null, json)
                catch error
                    callback(error, null)
    return
