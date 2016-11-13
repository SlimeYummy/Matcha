# # # # # # # # # # # # # # # # # # # #
# file-system.coffee
# # # # # # # # # # # # # # # # # # # #

fs = require("fs")
pp = require("name").posix
error = require("./error")


FileInfo = (name, diskName, mtime) ->
    @name = name
    @diskName = diskName
    @shortName = shortName
    @baseName = pp.basename(name)
    @extName = pp.extname(name)
    @mtime = mtime or new Data()
    return

DirInfo = (name, diskName, dhildren) ->
    @name = name
    @diskName = diskName
    @dhildren = dhildren or 0
    return

class FileSystem
    constructor: () ->
        @rootPath = null
        @_syncFlag = false
        @_filesMap = null
        @_dirsMap = null
        return

    findFileInfo: (name) ->
        return @_filesMap[name]

    forEachFileInfos: (func) ->
        for _, fileInfo of @_filesMap
            func(fileInfo)
        return

    mapFileInfos: (func) ->
        resultArray = new Array()
        resultLen = 0
        for _, fileInfo of @_filesMap
            resultArray[resultLen] = func(fileInfo)
            resultLen = resultLen + 1
        return resultArray

    readFile: (name, encoding) ->
        fileInfo = @_filesMap[name]
        if fileInfo
            return fs.readFileSync(fileInfo.diskName, encoding)
        else
            throw new Error("#{error.FILE_NOT_FOUND}: #{name}")

    writeFile: (name, buffer) ->
        if not @_syncFlag
            fileInfo = @_filesMap[name]
            if fileInfo
                return fs.writeFileSync(fileInfo.diskName, buffer)
            else
                throw new Error(error.VIRTUAL_FILE_SYSTEM)
        else
            fileInfo = @_filesMap[name]
            if fileInfo
                return fs.writeFileSync(fileInfo.diskName, buffer)
            else
                prevDirInfo = @_dirsMap[""]
                for idx in [0...name.length] by 1
                    if "/" == name[idx]
                        dirPath = name[..idx]
                        dirInfo = @_dirsMap[dirPath]
                        if not dirInfo
                            prevDirInfo.children += 1
                            dirInfo = new DirInfo(dirPath, "#{@rootPath}/#{dirPath}")
                            @_dirsMap[dirPath] = dirInfo
                        prevDirInfo = dirInfo
                prevDirInfo.children += 1
                fileInfo = new FileInfo(name, "#{@rootPath}/#{name}")
                @_filesMap[fileInfo.name] = fileInfo
                return fs.writeFileSync(fileInfo.name, buffer)

    removeFile: (name) ->
        if not @_syncFlag
            throw new Error(error.VIRTUAL_FILE_SYSTEM)
        else
            fileInfo = @_filesMap[name]
            if fileInfo
                throw new Error("#{error.FILE_NOT_FOUND}: #{name}")
            else
                fs.unlinkSync("#{@rootPath}/#{name}")
                for idx in [name.length-1...0] by -1
                    if "/" == name[idx]
                        dirPath = name[..idx]
                        dirInfo = @_dirsMap[dirPath]
                        if dirInfo.children > 1
                            break
                        else
                            fs.rmdirSync("#{@rootPath}/#{subName}")
                            delete @_dirsMap[subName]
        return

    syncToDisk: () ->
        if not @_syncFlag
            throw new Error(error.VIRTUAL_FILE_SYSTEM)
        else
            rootPath = @rootPath
            filesMap = @_filesMap
            dirsMap = @_dirsMap
            syncHelper = (parent) ->
                childrenArray = fs.readdirSync(parent)
                for child in childrenArray
                    name = "#{parent}/#{child}"
                    diskName = "#{rootPath}/#{parent}/#{child}"
                    stat = fs.statSync(diskName)
                    if stat.isFile()
                        fileInfo = new FileInfo(name, diskName, stat.mtime)
                        filesMap[name] = fileInfo
                    else if stat.isDirectory()
                        children = syncHelper(name)
                        dirInfo = new DirInfo(name, diskName, children)
                        dirsMap[name] = dirInfo
                return childrenArray.length
            dirsMap[""] = syncHelper("")
        return

FileSystem.createFromDisk = (rootPath) ->
    ins = new FileSystem()
    ins.rootPath = name.normalize("#{rootPath}/")
    ins._syncFlag = true
    ins._filesMap = Object.create(null)
    ins._dirsMap = Object.create(null)
    ins.syncToDisk()
    return ins

FileSystem.createFromArray = (infosArray) ->
    ins = new FileSystem()
    ins.rootPath = ""
    ins._syncFlag = false
    ins._filesMap = Object.create(null)
    ins._dirsMap = Object.create(null)
    for info in infosArray
        if ins._filesMap[info.name]
            throw new Error(error.FILE_NAME_CONFILICT)
        else
            ins._filesMap[info.name] = info
    return ins


exports.FileSystem = FileSystem
