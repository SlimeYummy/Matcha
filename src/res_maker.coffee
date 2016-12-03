# # # # # # # # # # # # # # # # # # # #
# res_maker.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
path = require("path").posix
markdown = require("markdown-it")()
less = require("less")
coffee = require("coffee-script")
cson = require("cson")

class ResMaker
    constructor: () ->
        @srcExt = ""
        @dstExt = ""
        @encoding = ""
        @_compile = null
        return

    toSrcName: (dstName) ->
        nameFrag = dstName[...-@dstExt.length]
        return "#{nameFrag}#{@srcExt}"

    toDstName: (srcName) ->
        nameFrag = srcName[...-@srcExt.length]
        return "#{nameFrag}#{@dstExt}"

    compile: (srcBuffer) ->
        compile = @_compile
        if not compile
            return srcBuffer
        return compile(srcBuffer)

ResMaker.create = (srcExt, dstExt, encoding, compile) ->
    ins = new ResMaker()
    ins.srcExt = srcExt
    ins.dstExt = dstExt
    ins.encoding = encoding
    ins._compile = compile
    return ins

ResMaker.clone = (oldIns) ->
    ins = new ResMaker()
    ins.srcExt = oldIns.srcExt
    ins.dstExt = oldIns.dstExt
    ins.encoding = oldIns.encoding
    ins._compile = oldIns._compile
    return ins

class ResMakersMap
    constructor: () ->
        @_map = Object.create(null)
        return

    findBySrcExt: (srcExt) ->
        return @_map[srcExt] or null

    findByDstExt: (dstExt) ->
        resultArray = []
        resultLen = 0
        for _, maker of @_map
            if dstExt == maker._dstExt
                resultArray[resultLen] = dstExt
                resultLen = resultLen + 1
        return resultArray

    forEach: (func) ->
        for _, maker of @_makersMap
            func(maker)
        return

    addMaker: (maker) ->
        if @_map[maker.srcExt]
            throw new Error("Maker ext confilict : #{maker.srcExt}")
        @_map[maker.srcExt] = maker
        return

    removeMaker: (srxExt) ->
        if @_map[srxExt]
            delete @_map[srxExt]
        return

makersMap = new ResMakersMap()

markdownMaker = ResMaker.create ".md", ".txt", "utf8", (srcBuffer) ->
    dstBuffer = markdown.render(srcBuffer)
    return dstBuffer
makersMap.addMaker(markdownMaker)

lessMaker = ResMaker.create ".less", ".css", "utf8", (srcBuffer) ->
    less.render srcBuffer, (error, output) ->
        throw error if error
        dstBuffer = output
    return dstBuffer
makersMap.addMaker(lessMaker)

coffeeMaker = ResMaker.create ".coffee", ".js", "utf8", (srcBuffer) ->
    dstBuffer = coffee.compile(srcBuffer)
    return dstBuffer
makersMap.addMaker(coffeeMaker)

csonMaker = ResMaker.create ".cson", ".json", "utf8", (srcBuffer) ->
    csonObj = cson.parse(srcBuffer)
    if csonObj instanceof Error
        throw error
    dstBuffer = JSON.stringify(csonObj)
    return dstBuffer
makersMap.addMaker(csonMaker)


exports.ResMaker = ResMaker
exports.makersMap = makersMap
