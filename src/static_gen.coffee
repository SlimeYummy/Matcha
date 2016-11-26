# # # # # # # # # # # # # # # # # # # #
# static_gen.coffee
# # # # # # # # # # # # # # # # # # # #

path = require("name").posix
art = require("art-template")
{MappingFileSystem, VirtualFileSystem} = require("./file-system")
{ResMakersMap, innerMakers} = require("./res-maker")
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

func = () ->
    srcFs = LocalFileSystem.create("#{rootPath}/src/")
    tmpFs = LocalFileSystem.create("#{rootPath}/tmp/")
    rlsFs = LocalFileSystem.create("#{rootPath}/rls/")

    # update resource
    infosArray = []
    srcFs.forEach (srcInfo) ->
        # need compile ?
        maker = innerMakers.findBySrcExt(srcInfo.extName)
        if not maker
            return srcInfo
        # need update ?
        tmpName = "#{srcInfo.baseName}#{maker.extName}"
        tmpInfo = tmpFs.find(tmpName)
        if tmpInfo and srcInfo.mtime < tmpInfo.mtime
            return tmpInfo
        # compile resource
        srcBuffer = srcFs.read(srcInfo.name)
        tmpBuffer = maker.compile(srcBuffer)
        tmpFs.write(tmpInfo, tmpBuffer)
        # compile OK
        color.green("Compile : #{srcInfo.name}")
        infosArray.push(tmpInfo)

    # delete resource
    virFs = VirtualFileSystem.create(infosArray)
    tmpFs.forEach (tmpInfo) ->
        virInfo = virFs.find(tmpInfo.name)
        if virInfo != tmpInfo
            tmpFs.remove(tmpInfo.name)
            color.green("Remove : #{srcInfo.name}")

    #
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
    return
