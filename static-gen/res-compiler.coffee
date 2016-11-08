coffee = require("coffeescript")
stylus = require("stylus")
markdown = require("markodwn-it")

compilersMap = {
    ".coffee": {
        sourceExt: ".coffee"
        targetExt: ".js"
        compile: (sourceBuffer) ->
            return
    }
    ".styl": {
        sourceExt: ".styl"
        targetExt: ".css"
        compile: (sourceBuffer) ->
            return
    }
    ".md": {
        sourceExt: ".md"
        targetExt: ".txt"
        compile: (sourceBuffer) ->
            return
    }
    "cson": {
        sourceExt: ".cson"
        targetExt: ".json"
        compile: (sourceBuffer) ->
            return
    }
}
