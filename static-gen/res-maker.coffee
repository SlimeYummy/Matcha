path = require("path").posix
coffee = require("coffeescript")
stylus = require("stylus")
markdown = require("markdown-it")

class ResMaker
    constructor: (srcExt, dstExt, encoding, compile) ->
        @srcExt = srcExt
        @dstExt = dstExt
        @encoding = encoding
        @compile = compile
        return

class ResMakesMgr
    constructor: () ->
        @_makersMap = Object.create(null)
        @_makersLen = 0
        return

    insertMaker: (srcExt, dstExt, compile) ->
        if @_makersMap[srcExt]
            throw new Error()
        resMaker = new ResMaker(srcExt, dstExt, compile)
        @_makersMap[srcExt] = resMaker
        @_makersLen = @_makersLen + 1
        return

    removeMaker: (srcExt) ->
        if @_makersMap[srcExt]
            delete @_makersMap[srcExt]
            @_makersLen = @_makersLen - 1
        return

    findMaker: (srcExt) ->
        return @_makersMap[srcExt] or null

    convertExtName: (srcExt) ->
        resMaker = @_makersMap[srcExt]
        if not resMaker
            return srcExt
        return resMaker.dstExt

    convertFileName: (srcName) ->
        extName = path.extname(srcName)
        resMaker = makersMap[extName]
        if not resMaker
            return srcName
        baseName = path.basename(srcName)
        return "#{baseName}#{resMaker.dstExt}"

resMakersMgr = new ResMakesMgr()

resMakersMgr.insertMaker ".coffee", ".js", "utf8", () ->
    return

resMakersMgr.insertMaker ".styl", ".css", "utf8", () ->
    return

resMakersMgr.insertMaker ".md", ".txt", "utf8", () ->
    return

resMakersMgr.insertMaker ".cson", ".json", "utf8", () ->
    return

exports.resMakersMgr = resMakersMgr
