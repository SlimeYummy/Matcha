coffee = require("coffeescript")
stylus = require("stylus")
markdown = require("markodwn-it")

class ResMaker
    constructor: (srcExt, dstExt, compile) ->
        @srcExt = srcExt
        @dstExt = dstExt
        @compile = compile
        return

class ResMakersMgr
    constructor: () ->
        @_makersMap = Object.create(null)
        @_makersLen = 0
        return

    insertMaker: (srcExt, dstExt, compile) ->
        if @_makersMap[srcExt]
            throw new Error()
        maker = new ResMaker(srcExt, dstExt, compile)
        @_makersMap[srcExt] = maker
        @_makersLen = @_makersLen + 1
        return

    removeMaker: (dstExt) ->
        if @_makersMap[dstExt]
            delete @_makersMap[dstExt]
            @_makersLen = @_makersLen - 1
        return

    findMakerBySrc: (srcExt) ->
        return @_makersMap[srcExt] or null

    findMakersByDst: (dstExt) ->
        makeraArray = []
        for _, maker of @_makersMap
            if dstExt == maker.dstExt
                makeraArray.push(maker)
        return makeraArray

    convertExtName: (srcExt) ->
        maker = @_makersMap[srcExt]
        if not maker
            return srcExt
        return maker.dstExt

    convertFileName: (srcName) ->
        dotPos = srcName.lastIndexOf(".")
        if -1 == dotPos
            return srcName
        extName = srcName[dotPos+1...]
        baseName = srcName[...dotPos]
        maker = makersMap[extName]
        if not maker
            return srcName
        else
            return "#{baseName}#{maker.dstExt}"

exports.resMakersMgr = resMakersMgr = new resMakersMgr()

resMakersMgr.insertMaker "coffee", "js", () ->
    return

resMakersMgr.insertMaker "styl", "css", () ->
    return

resMakersMgr.insertMaker "md", "txt", () ->
    return

resMakersMgr.insertMaker "cson", "json", () ->
    return
