# # # # # # # # # # # # # # # # # # # #
# template_gen.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
art = require("art-template")
cson = require("cson")
{normalizeWith, renameUnderline} = require("./file_util.coffee")

class TemplateGen
    @create: (virFs) ->
        ins = new TemplateGen()
        ins._virFs = virFs
        ins._tmplFuncsMap = Object.create(null)
        ins._configsArray = new Array()
        return

    _readConfig = (configFi) ->
        configText = @_virFs.read(configFi.name, "utf8")
        config = cson.parse(configText)
        travel = (object) =>
            if "string" == typeof object
                if "@@" == object[0..1]
                    realPath = normalizeWith(configFi.url.dir, object[2...])
                    fileText = @_virFs.read(realPath, "utf8")
                    return fileText
            else if "object" == typeof object
                if Array.isArray(object)
                    for value, index in object
                        object[index] = travel(value, basePath)
                else
                    for key, value of object
                        object[key] = travel(value, basePath)
        return travel(config)

    _findTmpl: (config) ->
        tempPath = config.staticGen.template
        if _tmplFuncsMap[tempPath]
            tmplFunc = _tmplFuncsMap[tempPath]
        else
            tmplText = @_virFs.read(tempPath, "utf8")
            tmplFunc = art.compile(tmplText)
            _tmplFuncsMap[tempPath] = tmplFunc
        return tmplFunc

    genSGFile: (configPath) ->
        # load resource
        configFi = @_virFs.filesMap[configPath]
        if not configFi
            throw new Error("File not found : #{configPath}")
        config = @_readConfig(configPath)
        tmplFunc = @_findTmpl(config)
        # build template
        url = renameUnderline(configFi.name, ".html")
        config.url = url
        html = tmplFunc(config)
        # save config
        @_configsArray.push {
            staticGen: config.staticGen
            meta: config.meta
        }
        return {url, html}

    _splitPage: (config, configFi) ->
        typeSet = config.staticGen.typeSet
        configsArray = @_configsArray.filter (sgConfig) ->
            return -1 != typeSet.indexOf(sgConfig.staticGen.type)
        pageCapacity = config.staticGen or 10
        multiPage = config.staticGen or true
        finishCount = if multiPage then configsArray.length else pageCapacity
        pagesArray = new Array()
        urlsArray = new Array()
        for idx in [0...finishCount] by pageCapacity
            url = renameUnderline(configFi.name, ".html", index + 1)
            urlsArray.push(url)
            pagesArray.push {
                pageIndex: idx + 1
                pageItemCount: pageCapacity
                pageItemStart: idx * pageCapacity + 1
                pageItemFinish: (idx + 1) * pageCapacity + 1
                url: url
                urlsArray: urlsArray
            }
        return pagesArray

    genXSGFile: (configPath) ->
        # load resource
        configFi = @_virFs.filesMap[configPath]
        if not configFi
            throw new Error("File not found : #{configPath}")
        config = @_readConfig(configPath)
        tmplFunc = @_findTmpl(config)
        # build template
        pagesArray = @_splitPage(config, configFi)
        htmlsArray = new Array()
        for page in pagesArray
            config.page = page
            html = tmplFunc(config)
            htmlsArray.push {page.url, html}
        return htmlsArray

exports.TemplateGen = TemplateGen
