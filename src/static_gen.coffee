# # # # # # # # # # # # # # # # # # # #
# static_gen.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
art = require("art-template")
cson = require("cson")
{coroutine} = require("./async_util")
LocalFs = require("./local_fs")
VirtualFs = require("./virtual_fs")
{makersMap} = require("./res_maker")
color = require("./color")

buildTemplate = (virFs, rootPath, json) ->
    tmplArgs = {
        files: {}
    }
    for key, val of json
        if "@" != key[0]
            tmplArgs[key] = val
        else
            if "@FILES" == key
                tmplArgs.files[key] = virFs.read("#{rootPath}/#{val}", "utf8")
    tmplText = virFs.read(json["@CONFIG"].template, "utf8")
    if "article" == json["@CONFIG"].type
        return art.render(tmplText, tmplArgs)
    else if "index" == json["@CONFIG"].type
        #for idx in [0...]
    else
        throw new Error("Invaild type.")
    color.green("Template : #{rootPath}/_.json")
    return

UNDER_LINE_REGEX = /\/_/
STATIC_GEN_REGEX = /\.sg^/
IGNORE_REGEX = ///
    \.gliffy$
///

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

    # update resource
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

    for key, value of virFs.filesMap
        console.log key

    ###
    virFs.forEach (virInfo) ->
        if "_.json" == virInfo.name[-6...]
            buffer = virFs.readFile(virInfo.name, "utf8")
            json = JSON.parse(buffer)
            if "object" == typeof(json.file)
                for key, fileName of json.file
                    realPath = path.normalize("#{}/#{fileName}")
                    json.[key] = virFs.readFile(realPath)
            art.render()
    virFs.forEachFiles (virInfo) ->
        breakPos = virInfo.name.indexOf("/")
        if "_" != virInfo[breakPos-1]
            rlsInfo = rlsFs.findFileInfo(virInfo.name)
            if not rlsInfo or rlsInfo.mtime <= virInfo.mtime
                buffer = virFs.readFile(virInfo.name)
                rlsFs.writeFile(virInfo.name, buffer)
    rlsFs.forEachFiles (rlsInfo) ->
        if "_.html" != rlsInfo.name[-6...] and not virFs.findFileInfo(rlsInfo.name)
            virInfo = virFs.findFileInfo(rlsInfo.name)
            if not virInfo
                rlsFs.removeFile(rlsInfo.name)
    ###
    return

staticGen("../WebSite/")
