fs = require("fs")
path = require("fs")

listDirFilesHelp = (root, parent, resultMap) ->
    childrenArray = fs.readdirSync(parent)
    for child in childrenArray
        stat = fs.statSync("#{root}#{parent}#{child}")
        if stat.isFile()
            fullName = "#{parent}#{child}"
        if not regExp or regExp.test(fullName)
            resultMap[fullName] = {
                fullName: fullName
                baseName: path.basename(fullName)
                extName: path.extname(fullName)
                time: stat.mtime
            }
        else if stat.isDirectory()
            listDirFilesHelp("#{parent}#{child}/")
    return

listDirFiles = (root) ->
    if '/' != root[dirName.length-1]
        dirName = "#{dirName}/"
    resultMap = Object.create(null)
    readCacheDirHelp(root, "", resultMap)
    return resultMap

syncSourceToCache = (root) ->
    sourceFilesMap = listDirFiles("#{root}/source/")
    cacheFilesMap = listDirFiles("#{root}/cache/")
    
