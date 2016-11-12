# # # # # # # # # # # # # # # # # # # #
# static-gen.coffee
# # # # # # # # # # # # # # # # # # # #

FileSystem = require("file-system")
{ResMakersMap, innerMakers} = require("res-maker")


syncSrcToTmp = (root) ->
    srcFileSystem = FileSystem.create("#{root}/src/")
    tmpFileSystem = FileSystem.create("#{root}/tmp/")
    aliveTmpsMap = Object.create(null)
    # update resource
    srcFileSystem.forEachFiles (srcInfo) ->
        # need compile ?
        maker = innerMakers.findBySrcExt(srcInfo.extName)
        if not maker
            return
        # need update ?
        tmpName = "#{srcInfo.name}#{maker.extName}"
        aliveTmpsMap[tmpName] = true
        tmpInfo = tmpFileSystem.getFileInfo(tmpName)
        if tmpInfo and srcInfo.time < tmpInfo.time
            return
        # compile resource
        srcBuffer = srcFileSystem.readFile(srcInfo.name)
        tmpBuffer = maker.compile(srcBuffer)
        tmpFileSystem.writeFile(tmpInfo, tmpBuffer)
    # delete resource
    tmpFileSystem.forEachFiles (tmpInfo) ->
        if not aliveTmpsMap[tmpInfo.name]
            tmpFileSystem.removeFile(tmpInfo.name)
    tmpFileSystem.foreachDirs (tmpInfo) ->
        if not srcFileSystem.getFileInfo(tmpInfo.name)
            tmpFileSystem.removeDir(tmpInfo.name)
    return
