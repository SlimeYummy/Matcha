# # # # # # # # # # # # # # # # # # # #
# color_print.coffee
# # # # # # # # # # # # # # # # # # # #

exports.red = (text) ->
    console.log("\x1B[31m#{text}\x1B[39m")

exports.green = (text) ->
    console.log("\x1B[32m#{text}\x1B[39m")

exports.yellow = (text) ->
    console.log("\x1B[33m#{text}\x1B[39m")

exports.white = (text) ->
    console.log(text)
