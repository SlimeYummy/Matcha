# # # # # # # # # # # # # # # # # # # #
# static_gen.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
path = require("path").posix
{coroutine} = require("./async_util")
LocalFs = require("./local_fs")
VirtualFs = require("./virtual_fs")
{makersMap} = require("./res_maker")
color = require("./color")
TemplateGen = require("./template_gen.coffee")

DEFAULT_ITEM = 10
DEFAULT_MULTI = false

UNDER_LINE_REGEX = /(^_)|(\/_)/
STATIC_GEN_REGEX = /\.sg$/
X_STATIC_GEN_REGEX = /\.xsg$/
TEMPLATE_REGEX = /\.tmpl$/
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
            tmpName = maker.toDstName(srcInfo.name)
            tmpInfo = tmpFs.filesMap[tmpName]
            if tmpInfo and srcInfo.mtime < tmpInfo.mtime
                tmpFs.touch(tmpName)
                infosArray.push(tmpInfo)
                continue
            # compile resource
            srcBuffer = srcFs.read(srcInfo.name, maker.encoding)
            tmpBuffer = maker.compile(srcBuffer)
            tmpFs.write(tmpName, tmpBuffer)
            tmpInfo = tmpFs.filesMap[tmpName]
            infosArray.push(tmpInfo)
            color.green("Compile OK : #{srcInfo.name}")
        catch error
            color.yellow("Compile ERR : #{srcInfo.name}")
            color.yellow(error.stack)

    virFs = VirtualFs.create(infosArray)

    # delete resource
    color.white("\nClear reource in #{rootPath}/tmp/")
    tmpDeleteArray = []
    for _, tmpInfo of tmpFs.filesMap
        if not tmpInfo.using
            tmpDeleteArray.push(tmpInfo.name)
    for tmpName in tmpDeleteArray
        try
            tmpFs.delete(tmpName)
            color.green("Delete OK : #{tmpName}")
        catch error
            color.yellow("Delete ERR : #{tmpName}")
            color.yellow(error.stack)

    # copy resource
    color.white("\nCopy reource to #{rootPath}/rls/")
    for _, virInfo of virFs.filesMap
        try
            if UNDER_LINE_REGEX.test(virInfo.name)
                continue
            rlsInfo = rlsFs.filesMap[virInfo.name]
            if rlsInfo and virInfo.mtime < rlsInfo.mtime
                rlsFs.touch(rlsInfo.name)
                continue
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
        if STATIC_GEN_REGEX.test(virInfo.name)
            sgInfosArray.push(virInfo)
        else if X_STATIC_GEN_REGEX.test(virInfo.name)
            xsgInfosArray.push(virInfo)
    templateGen = TemplateGen.create(virFs)
    for sgInfo in sgInfosArray
        try
            templateGen.genSGFile(sgInfo.name)
        catch error
            color.yellow("Build ERR : #{sgInfo.name}")
            color.yellow(error.stack)
    for xsgInfo in xsgInfosArray
        try
            templateGen.genXSGFile(xsgInfo.name)
        catch error
            color.yellow("Build ERR : #{xsgInfo.name}")
            color.yellow(error.stack)

    # delete resource
    color.white("\nClear reource in #{rootPath}/rls/")
    rlsDeleteArray = []
    for _, rlsInfo of rlsFs.filesMap
        if not rlsInfo.using
            rlsDeleteArray.push(rlsInfo.name)
    for rlsName in rlsDeleteArray
        try
            rlsFs.delete(rlsName)
            color.green("Delete OK : #{rlsInfo.name}")
        catch error
            color.yellow("Delete ERR : #{rlsInfo.name}")
            color.yellow(error.stack)

    # done
    color.white("Done ! \n\n")
    return

staticGen("D:/dev/FenQi.IO")
