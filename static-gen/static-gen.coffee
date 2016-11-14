# # # # # # # # # # # # # # # # # # # #
# static-gen.coffee
# # # # # # # # # # # # # # # # # # # #

art = require("art-template")
{MappingFileSystem, VirtualFileSystem} = require("./file-system")
{ResMakersMap, innerMakers} = require("./res-maker")

syncSrcToTmp = (rootPath) ->
    srcFileSystem = FileSystem.createFromDisk("#{rootPath}/src/")
    tmpFileSystem = FileSystem.createFromDisk("#{rootPath}/tmp/")
    # update resource
    infosArray = srcFileSystem.mapFileInfos (srcInfo) ->
        # need compile ?
        maker = innerMakers.findBySrcExt(srcInfo.extName)
        if not maker
            return srcInfo
        # need update ?
        tmpName = "#{srcInfo.baseName}#{maker.extName}"
        tmpInfo = tmpFileSystem.findFileInfo(tmpName)
        if tmpInfo and srcInfo.mtime < tmpInfo.mtime
            return tmpInfo
        # compile resource
        srcBuffer = srcFileSystem.readFile(srcInfo.name)
        tmpBuffer = maker.compile(srcBuffer)
        tmpFileSystem.writeFile(tmpInfo, tmpBuffer)
        return tmpInfo
    # delete resource
    virFileSystem = FileSystem.createFromArray(infosArray)
    tmpFileSystem.forEachFileInfos (tmpInfo) ->
        virInfo = virFileSystem.findFileInfo(tmpInfo.name)
        if virInfo != tmpInfo
            tmpFileSystem.removeFile(tmpInfo.name)
    return virFileSystem

genStaticPage = (virFileSystem) ->
    rlsFileSystem = FileSystem.createFromDisk("#{rootPath}/rls/")
    virFileSystem.forEachFiles (virInfo) ->
        if "_.json" == virInfo.shortName
            # ...
        else if
            if "_" != virInfo.shortName[0]
                rlsInfo = rlsFileSystem.findFileInfo(virInfo.name)
                if not rlsInfo or rlsInfo.mtime <= virInfo.mtime
                    buffer = virFileSystem.readFile(virInfo.name)
                    rlsFileSystem.writeFile(virInfo.name, buffer)
    rlsFileSystem.forEachFiles (rlsInfo) ->
        if "_.json" != rlsInfo.name
            virInfo = virFileSystem.findFileInfo(rlsInfo.name)
            if not virInfo
                rlsFileSystem.removeFile(rlsInfo.name)
    return
