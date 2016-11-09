VirtualFs = require("virtual-fs")
resMakersMgr = require("res-maker")

syncSrcToTmp = (root) ->
    srcDetail = listDirDetail("#{root}/src/")
    tmpDetail = listDirDetail("#{root}/tmp/")
    # build new files in source
    for srcName, srcTime of srcDetail.filesMap
        srcExt = path.extname(srcName)
        resMaker = resMakersMgr.findMaker(srcExt)
        if not resMaker
            continue
        baseName = srcName[...-srcExt.length]
        tmpName = "#{baseName}#{resMaker.dstExt}"
        tmpTime = tmpDetail.filesMap[tmpName]
        if not tmpTime or tmpTime < srcTime
            srcBuffer = fs.readFileSync("#{root}/#{tmpName}")
            resMaker.compile(srcName)
    # delete old files in cache
    for
    return
