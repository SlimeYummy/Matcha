# # # # # # # # # # # # # # # # # # # #
# static_gen.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
path = require("path").posix
art = require("art-template")
cson = require("cson")
{coroutine} = require("./async_util")
LocalFs = require("./local_fs")
VirtualFs = require("./virtual_fs")
{makersMap} = require("./res_maker")
color = require("./color")

DEFAULT_ITEM = 10
DEFAULT_MULTI = false

UNDER_LINE_REGEX = /\/_/
STATIC_GEN_REGEX = /\.sg^/
X_STATIC_GEN_REGEX = /\.xsg^/
TEMPLATE_REGEX = /\.tmpl^/
IGNORE_REGEX = ///
    \.gliffy$
///

readTmplConfig = (virFs, info) ->
    text = virFs.read(info.name, "utf8")
    config = cson.parse(text)
    travel = (object) ->
        if "object" == typeof object
            if Array.isArray(object)
                for value, index in object
                    object[index] = replaceFile(value)
            else
                for key, value of object
                    object[key] = replaceFile(value)
        else if "string" == typeof object
            if "@" == object[0] and "@" == object[1]
                realPath = path.normalize("#{sgPath}/#{object}")
                fileText = virFs.read(realPath, "utf8")
                return fileText
        return object
    return travel(config)

buildTmplSg = (tmplMap, config) ->
    # read template
    tmplText = tmplMap[config.TEMPLATE]
    if not tmplText
        throw new Error("Template not found : #{config.TMPL}")
    # compile template
    return template.render(tmplText, config)

buildTmplXsg = (tmplMap, metasArray, config) ->
    # read template
    tmplText = tmplMap[config.TEMPLATE]
    if not tmplText
        throw new Error("Template not found : #{config.TMPL}")
    # filter metas
    metasArray = metasArray.filter (meta) ->
        if not meta.type
            return true
        return type == config.CATALOG.type
    # compile template
    item = config.CATALOG.item or DEFAULT_ITEM
    multi = config.CATALOG.multi or DEFAULT_MULTI
    config.ITEM = {}
    if not multi
        config.ITEM.pageIndex = 1
        config.ITEM.metasArray = metasArray[0...item]
        return template.render(tmplText, config)
    else
        for idx in [0...metasArray.length] by item
            config.ITEM.pageIndex = idx + 1
            config.ITEM.metasArray = metasArray[idx...item]
            htmlText = template.render(tmplText, config)
            tmplsArray.push(htmlText)
        return tmplsArray

staticGen = (rootPath) ->
    try
        srcFs = LocalFs.create("#{rootPath}/src/")
    catch error
        color.red(error.stack)
        return

    try
        tmpFs = LocalFs.create("#{rootPath}/tmp/")
    catch error
        color.red(error.stack)
        return

    try
        rlsFs = LocalFs.create("#{rootPath}/rls/")
    catch error
        color.red(error.stack)
        return

    # compile resource
    color.white("\nCompile reource in #{rootPath}/src/")
    infosArray = []
    for _, srcInfo of srcFs.filesMap
        try
            # ignore ?
            if IGNORE_REGEX.test(srcInfo.name)
                continue
            # need compile ?
            maker = makersMap.findBySrcExt(srcInfo.url.ext)
            if not maker
                infosArray.push(srcInfo)
                continue
            # need update ?
            tmpName = "#{srcInfo.url.dir}/#{srcInfo.url.name}#{maker.dstExt}"
            tmpInfo = tmpFs.filesMap[tmpName]
            if tmpInfo and srcInfo.mtime < tmpInfo.mtime
                infosArray.push(tmpInfo)
                continue
            # compile resource
            srcBuffer = srcFs.read(srcInfo.name, maker.encoding)
            tmpBuffer = maker.compile(srcBuffer)
            tmpFs.write(tmpName, tmpBuffer)
            tmpInfo = tmpFs.filesMap[tmpName]
            infosArray.push(tmpInfo)
            # print info
            color.green("Compile OK : #{srcInfo.name}")
        catch error
            color.yellow("Compile ERR : #{srcInfo.name}")
            color.yellow(error.stack)

    virFs = VirtualFs.create(infosArray)

    # delete resource
    color.white("\nClear reource in #{rootPath}/tmp/")
    for _, tmpInfo of tmpFs.filesMap
        try
            if IGNORE_REGEX.test(tmpInfo.name)
                tmpFs.delete(tmpInfo.name)
                color.green("Delete OK : #{tmpInfo.name}")
            else if tmpInfo != virFs.filesMap[tmpInfo.name]
                tmpFs.delete(tmpInfo.name)
                color.green("Delete OK : #{tmpInfo.name}")
        catch error
            color.yellow("Delete ERR : #{tmpInfo.name}")
            color.yellow(error.stack)

    # copy resource
    color.white("\nCopy reource to #{rootPath}/rls/")
    for _, virInfo of virFs.filesMap
        try
            if UNDER_LINE_REGEX.test(virInfo.name)
                continue
            else
                copyBuffer = virFs.read(virInfo.name)
                rlsFs.write(virInfo.name, copyBuffer)
                color.green("Copy OK : #{virInfo.name}")
        catch error
            color.yellow("Copy ERR : #{virInfo.name}")
            color.yellow(error.stack)

    # build template
    color.white("\nBuild template to #{rootPath}/rls/")
    sgInfosArray = []
    xsgInfosArray = []
    tmplsMap = Object.create(null)
    for _, virInfo of virFs.filesMap
        try
            if STATIC_GEN_REGEX.test(virInfo.name)
                sgInfosArray.push(virInfo)
            else if X_STATIC_GEN_REGEX.text(virInfo.name)
                xsgInfosArray.push(virInfo)
            else if TEMPLATE_REGEX.test(virInfo.name)
                tmplText = virFs.read(virInfo.name, "utf8")
                tmplsMap[virInfo.name] = tmplText
        catch error
            color.yellow("Build ERR : #{virInfo.name}")
            color.yellow(error.stack)
    # build .sg file
    sgConfigArray = []
    for sgInfo in sgInfosArray
        try
            sgConfig = readTmplConfig(virFs, sgInfo)
            sgConfigArray.push(sgConfig)
            tmplBuffer = buildTmplSg(tmplsMap, sgConfig)
            rls.write(virInfo.name, tmplBuffer)
        catch error
            color.yellow("Build ERR : #{virInfo.name}")
            color.yellow(error.stack)
    # build .xsg file
    for xsgInfo in xsgInfosArray
        try
            xsgConfig = readTmplConfig(virFs, sgInfo)
            result = buildTmplXsg(tmplsMap, xsgConfig)
            if "string" == typeof result
                tmplBuffer = result
                rls.write(virInfo.name, tmplBuffer)
            else
                for tmplBuffer, idx in result
                    name = "#{virInfo.name}_#{idx+1}"
                    rls.write(name, tmplBuffer)
        catch error
            color.yellow("Build ERR : #{virInfo.name}")
            color.yellow(error.stack)

    # done
    color.white("Done ! \n\n")
    return

staticGen("../WebSite")
