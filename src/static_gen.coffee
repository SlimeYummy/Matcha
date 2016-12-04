# # # # # # # # # # # # # # # # # # # #
# static_gen.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
rmDirpSync = require("rimraf").sync
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
            if IGNORE_REGEX.test(srcInfo.path)
                continue
            # need compile ?
            maker = makersMap.findBySrcExt(srcInfo.url.ext)
            if not maker
                infosArray.push(srcInfo)
                continue
            # need update ?
            tmpName = maker.toDstName(srcInfo.path)
            tmpInfo = tmpFs.filesMap[tmpName]
            if tmpInfo and srcInfo.mtime < tmpInfo.mtime
                infosArray.push(tmpInfo)
                continue
            # compile resource
            srcBuffer = srcFs.read(srcInfo.path, maker.encoding)
            tmpBuffer = maker.compile(srcBuffer)
            tmpFs.write(tmpName, tmpBuffer)
            tmpInfo = tmpFs.filesMap[tmpName]
            infosArray.push(tmpInfo)
            color.green("Compile OK : #{srcInfo.path}")
        catch error
            color.yellow("Compile ERR : #{srcInfo.path}")
            color.yellow(error.stack)

    virFs = VirtualFs.create(infosArray)

    # copy resource
    color.white("\nCopy reource to #{rootPath}/rls/")
    for _, virInfo of virFs.filesMap
        try
            if UNDER_LINE_REGEX.test(virInfo.path)
                continue
            rlsInfo = rlsFs.filesMap[virInfo.path]
            if rlsInfo and virInfo.mtime < rlsInfo.mtime
                continue
            copyBuffer = virFs.read(virInfo.path)
            rlsFs.write(virInfo.path, copyBuffer)
            color.green("Copy OK : #{virInfo.path}")
        catch error
            color.yellow("Copy ERR : #{virInfo.path}")
            color.yellow(error.stack)

    # build template
    color.white("\nBuild template to #{rootPath}/rls/")
    sgInfosArray = []
    xsgInfosArray = []
    tmplsMap = Object.create(null)
    for _, virInfo of virFs.filesMap
        if STATIC_GEN_REGEX.test(virInfo.path)
            sgInfosArray.push(virInfo)
        else if X_STATIC_GEN_REGEX.test(virInfo.path)
            xsgInfosArray.push(virInfo)
    templateGen = TemplateGen.create(virFs, rlsFs)
    for sgInfo in sgInfosArray
        try
            templateGen.sgGen(sgInfo.path)
            color.green("Build OK : #{sgInfo.path}")
        catch error
            color.yellow("Build ERR : #{sgInfo.path}")
            color.yellow(error.stack)
    for xsgInfo in xsgInfosArray
        try
            templateGen.xsgGen(xsgInfo.path)
            color.green("Build OK : #{xsgInfo.path}")
        catch error
            color.yellow("Build ERR : #{xsgInfo.path}")
            color.yellow(error.stack)

    # done
    color.white("Done ! \n\n")
    return

staticClear = (rootPath) ->
    try
        rmDirpSync("#{rootPath}/tmp/*")
        rmDirpSync("#{rootPath}/rls/*")
        color.white("Clear OK.")
    catch error
        color.red("Clear ERR.")
        color.red(error.stack)
    color.white("Done ! \n\n")
    return

staticGen("D:/dev/FenQi.IO")
#staticClear("D:/dev/FenQi.IO")
