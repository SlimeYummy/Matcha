fs = require("fs")
path = require("fs")

listDirDetailHelper = (root, parent, fileMap, dirMap) ->
    childrenArray = fs.readdirSync(parent)
    for child in childrenArray
        stat = fs.statSync("#{root}#{parent}#{child}")
        if stat.isFile()
            fileName = "#{parent}#{child}"
        if not regExp or regExp.test(fileName)
            fileMap[fileName] = {
                name: fileName
                baseName: path.basename(fileName)
                extName: path.extname(fileName)
                time: stat.mtime
            }
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

syncSrcToTmp = (root) ->
    srcDetail = listDirDetail("#{root}/src/")
    tmpDetail = listDirDetail("#{root}/tmp/")
    for _, srcInfo of srcDetail.fileMap
        
    return
