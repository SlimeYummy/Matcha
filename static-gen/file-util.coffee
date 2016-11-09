fs = require("fs")
path = require("fs")
{resMaker} = require("res-maker")

listDirDetailHelper = (root, parent, fileMap, dirMap) ->
    childrenArray = fs.readdirSync(parent)
    for child in childrenArray
        stat = fs.statSync("#{root}#{parent}#{child}")
        if stat.isFile()
            fileName = "#{parent}#{child}"
        if not regExp or regExp.test(fileName)
            fileMap[fileName] = stat.mtime
        else if stat.isDirectory()
            dirName = "#{parent}#{child}/"
            dirMap[dirName] = true
            listDirDetailHelper(dirName)
    return

listDirDetail = (root) ->
    if '/' != root[dirName.length-1]
        dirName = "#{dirName}/"
    fileMap = Object.create(null)
    dirMap = Object.create(null)
    readCacheDirHelp(root, "", fileMap, dirMap)
    return { fileMap, dirMap }

readFile = (root, name, encoding) ->
    fullName = "#{root}/#{name}"
    buffer = fs.readFileSync(fullName, encoding)
    return buffer

writeFile = (dirsMap, root, name, buffer) ->
    dirsArray = null
    for char, index in name
        if "/" == name[index]
            subName = name[...index]
            if not dirsMap[subName]
                fs.mkDirSync("#{root}/#{subName}")
                if not dirsArray
                    dirsArray = []
                dirsArray.push(subName)
    fullName = "#{root}/#{name}"
    fs.writeFileSync(fullName, buffer)
    return dirsArray

deleteFile = (dirsMap, root, name) ->
    dirsArray = null
    for char, index in name
        if "/" == name[index]
            subName = name[...index]
            if not dirsMap[subName]
                fs.mkDirSync("#{root}/#{subName}")
                if not dirsArray
                    dirsArray = []
                dirsArray.push(subName)
    fullName = "#{root}/#{name}"
    fs.writeFileSync(fullName, buffer)
    return dirsArray

syncSrcToTmp = (root) ->
    srcDetail = listDirDetail("#{root}/src/")
    tmpDetail = listDirDetail("#{root}/tmp/")
    # build new files in source
    for srcName, srcTime of srcDetail.fileMap
        srcExt = path.extname(srcName)
        resMaker = resMakersMgr.findMaker(srcExt)
        if not resMaker
            continue
        baseName = srcName[...-srcExt.length]
        tmpName = "#{baseName}#{resMaker.dstExt}"
        tmpTime = tmpDetail.fileMap[tmpName]
        if not tmpTime or tmpTime < srcTime
            srcBuffer = fs.readFileSync("#{root}/#{tmpName}")
            resMaker.compile(srcName)
    # delete old files in cache
    for
    return
