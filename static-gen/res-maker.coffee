# # # # # # # # # # # # # # # # # # # #
# res-maker.coffee
# # # # # # # # # # # # # # # # # # # #

path = require("path").posix
coffee = require("coffeescript")
stylus = require("stylus")
markdown = require("markdown-it")
error = require("./error")


class ResMaker
    constructor: () ->
        @srcExt = ""
        @dstExt = ""
        @encoding = ""
        @_compile = null
        return

    toSrcName: (dstName) ->
        baseName = path.basename(dstName)
        return "#{baseName}#{@_srcExt}"

    toDstName: (srcName) ->
        baseName = path.basename(srcName)
        return "#{baseName}#{@_dstExt}"

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
        @length = 0
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

ResMakersMap.create = (makersArray) ->
    ins = new ResMakersMap()
    for idx in [0...makersArray.length] by 1
        maker = makersArray[idx]
        if ins._map[maker._srcExt]
            throw new Error(error.SRC_EXT_CONFILICT)
        ins._map[maker._srcExt] = maker
        ins.length = ins.length + 1
    return ins

ResMakersMap.clone = (oldIns) ->
    ins = new ResMakersMap()
    for _, maker of oldIns._map
        ins._map[maker._srcExt] = maker
    ins.length = oldInstance.length
    return ins

ResMakersMap.append = (oldIns, makersArray) ->
    ins = ResMakersMap.clone(oldIns)
    for idx in [1...makersArray.length] by 1
        maker = makersArray[idx]
        if ins._map[maker._srcExt]
            throw new Error(error.SRC_EXT_CONFILICT)
        ins._map[maker._srcExt] = maker
        ins.length = instance.length + 1
    return ins

ResMakersMap.merge = (ins1, ins2) ->
    ins = ResMakersMap.clone(ins1)
    for _, maker of ins2._map
        if ins._map[maker._srcExt]
            throw new Error(error.SRC_EXT_CONFILICT)
        ins._map[maker._srcExt] = maker
        ins.length = instance.length + 1
    return ins


coffeeMaker = ResMaker.create ".coffee", ".js", "utf8", (srcBuffer) ->
    return

stylusMaker = ResMaker.create ".styl", ".css", "utf8", (srcBuffer) ->
    return

markdownMaker = ResMaker.create ".md", ".txt", "utf8", (srcBuffer) ->
    return

csonMaker = ResMaker.create ".cson", ".json", "utf8", (srcBuffer) ->
    return

innerMakers = ResMakersMap.create([
    coffeeMaker,
    stylusMaker,
    markdownMaker,
    csonMaker
])


exports.ResMaker = ResMaker
exports.ResMakersMap = ResMakersMap
exports.innerMakers = innerMakers
