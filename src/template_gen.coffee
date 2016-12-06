# # # # # # # # # # # # # # # # # # # #
# template_gen.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
art = require("art-template")
cson = require("cson")
fileUtil = require("./file_util.coffee")

DEFAULT_PAGE_ITEMS = 10
DEFAULT_MULTI_PAGE = true

class TemplateGen
    @create: (srcFs, dstFs) ->
        ins = new TemplateGen()
        ins._srcFs = srcFs
        ins._dstFs = dstFs
        ins._tmplFuncsMap = Object.create(null)
        ins._configsArray = new Array()
        return ins

    _loadConfig: (configFi) ->
        configText = @_srcFs.read(configFi.path, "utf8")
        config = cson.parse(configText)
        travel = (object) =>
            if "string" == typeof object
                if "@@" == object[0..1]
                    realPath = fileUtil.normalizeWith(configFi.url.dir, object[2...])
                    fileText = @_srcFs.read(realPath, "utf8")
                    return fileText
            else if "object" == typeof object
                if Array.isArray(object)
                    for value, index in object
                        object[index] = travel(value)
                else
                    for key, value of object
                        object[key] = travel(value)
            return object
        return travel(config)

    _findTmpl: (config) ->
        tempPath = config.gen.template
        if @_tmplFuncsMap[tempPath]
            tmplFunc = @_tmplFuncsMap[tempPath]
        else
            tmplText = @_srcFs.read(tempPath, "utf8")
            tmplFunc = art.compile(tmplText)
            @_tmplFuncsMap[tempPath] = tmplFunc
        return tmplFunc

    _sgMakeUrl: (configFi) ->
        htmlName = fileUtil.renameUnderline(configFi.url.name, ".html")
        dirPath = configFi.url.dir
        htmlPath = fileUtil.normalize("#{dirPath}/#{htmlName}")
        return {htmlPath, dirPath}

    sgGen: (configPath) ->
        configFi = @_srcFs.filesMap[configPath]
        if not configFi
            throw new Error("File not found : #{configPath}")
        # load config
        config = @_loadConfig(configFi)
        config.url = @_sgMakeUrl(configFi)
        {gen, meta, url} = config
        @_configsArray.push({gen, meta, url})
        # build template
        tmplFunc = @_findTmpl(config)
        htmlBuffer = tmplFunc(config)
        @_dstFs.write(config.url.htmlPath, htmlBuffer)
        return

    _xsgFilter: (config) ->
        typesSet = config.gen.typesSet
        configsArray = @_configsArray.filter (sgConfig) ->
            return -1 != typesSet.indexOf(sgConfig.meta.type)
        configsArray.sort (a, b) ->
            return a.meta.date < b.meta.date
        return configsArray

    _xsgMakeUrls: (config, configsArray, configFi) ->
        pageItems = config.gen.pageItems or DEFAULT_PAGE_ITEMS
        multiPage = config.gen.multiPage or DEFAULT_MULTI_PAGE
        finishCount = if multiPage then configsArray.length else pageItems
        urlsArray = for idx in [0...finishCount] by pageItems
            htmlName = fileUtil.renameUnderline(configFi.url.name, ".html")
            dirPath = configFi.url.dir
            htmlPath = fileUtil.normalize("#{dirPath}/#{htmlName}")
            {htmlPath, dirPath}
        return urlsArray

    _xsgSplitPage: (config, configsArray, urlsArray) ->
        pageItems = config.gen.pageItems or DEFAULT_PAGE_ITEMS
        multiPage = config.gen.multiPage or DEFAULT_MULTI_PAGE
        finishCount = if multiPage then configsArray.length else pageItems
        pageCount = Math.ceil(finishCount / pageItems)
        pagesArray = for index in [0...finishCount] by pageItems
            itemsArray = configsArray[index...index+pageItems]
            pageIndex = index
            {itemsArray, pageIndex, pageCount}
        return pagesArray

    xsgGen: (configPath) ->
        configFi = @_srcFs.filesMap[configPath]
        if not configFi
            throw new Error("File not found : #{configPath}")
        # load config
        config = @_loadConfig(configFi)
        configsArray = @_xsgFilter(config)
        urlsArray = @_xsgMakeUrls(config, configsArray, configFi)
        pagesArray = @_xsgSplitPage(config, configsArray, urlsArray)
        # build template
        tmplFunc = @_findTmpl(config)
        for index in [0...pagesArray.length] by 1
            config.page = pagesArray[index]
            config.url = urlsArray[index]
            config.urlsArray = urlsArray
            htmlBuffer = tmplFunc(config)
            @_dstFs.write(config.url.htmlPath, htmlBuffer)
        return

module.exports = TemplateGen
