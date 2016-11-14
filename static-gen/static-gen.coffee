# # # # # # # # # # # # # # # # # # # #
# static-gen.coffee
# # # # # # # # # # # # # # # # # # # #

path = require("name").posix
art = require("art-template")
{MappingFileSystem, VirtualFileSystem} = require("./file-system")
{ResMakersMap, innerMakers} = require("./res-maker")

syncSrcToTmp = (rootPath) ->
    srcMfs = MappingFileSystem.create("#{rootPath}/src/")
    tmpMfs = MappingFileSystem.create("#{rootPath}/tmp/")
    # update resource
    infosArray = srcMfs.mapFileInfos (srcInfo) ->
        # need compile ?
        maker = innerMakers.findBySrcExt(srcInfo.extName)
        if not maker
            return srcInfo
        # need update ?
        tmpName = "#{srcInfo.baseName}#{maker.extName}"
        tmpInfo = tmpMfs.findFileInfo(tmpName)
        if tmpInfo and srcInfo.mtime < tmpInfo.mtime
            return tmpInfo
        # compile resource
        srcBuffer = srcMfs.readFile(srcInfo.name)
        tmpBuffer = maker.compile(srcBuffer)
        tmpMfs.writeFile(tmpInfo, tmpBuffer)
        return tmpInfo
    # delete resource
    resVfs = VirtualFileSystem.create(infosArray)
    tmpMfs.forEachFileInfos (tmpInfo) ->
        virInfo = resVfs.findFileInfo(tmpInfo.name)
        if virInfo != tmpInfo
            tmpMfs.removeFile(tmpInfo.name)
    return resVfs

genStaticPage = (resVfs) ->
    rlsMfs = MappingFileSystem.create("#{rootPath}/rls/")
    resVfs.forEachFiles (virInfo) ->
        if "_.json" == virInfo.name[-6...]
            buffer = resVfs.readFile(virInfo.name, "utf8")
            json = JSON.parse(buffer)
            if "object" == typeof(json.file)
                for key, fileName of json.file
                    realPath = path.normalize("#{}/#{fileName}")
                    json.[key] = resVfs.readFile(realPath)
            art.render()
    resVfs.forEachFiles (virInfo) ->
        breakPos = virInfo.name.indexOf("/")
        if "_" != virInfo[breakPos-1]
            rlsInfo = rlsMfs.findFileInfo(virInfo.name)
            if not rlsInfo or rlsInfo.mtime <= virInfo.mtime
                buffer = resVfs.readFile(virInfo.name)
                rlsMfs.writeFile(virInfo.name, buffer)
    rlsMfs.forEachFiles (rlsInfo) ->
        if "_.html" != rlsInfo.name[-6...] and not resVfs.findFileInfo(rlsInfo.name)
            virInfo = resVfs.findFileInfo(rlsInfo.name)
            if not virInfo
                rlsMfs.removeFile(rlsInfo.name)
    return
