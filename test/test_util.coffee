# # # # # # # # # # # # # # # # # # # #
# test_util.coffee
# # # # # # # # # # # # # # # # # # # #

exports.mapToArray = (map) ->
    array = []
    for key, value of map
        array.push(value)
    array.sort (a, b) ->
        return a.name > b.name
    return array

exports.shouldThrowError = () ->
    return new Error("Should throw error.")

exports.clearRoot = (callback) ->
    if not fs.existsSync("root")
        setImmediate callback
    else
        cp.exec "rd/S/Q .\\root", (error, stdout, stderr) ->
            throw error if error
            setImmediate callback
    return
