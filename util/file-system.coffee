# # # # # # # # # # # # # # # # # # # #
# file-system.coffee
# # # # # # # # # # # # # # # # # # # #

fs = require("fs")
path = require("path").posix

FileInfo = (name, diskName, mtime) ->
    @name = name
    @diskName = diskName
    @baseName = path.basename(name)
    @extName = path.extname(name)
    @mtime = mtime or new Data()
    return

DirInfo = (name, diskName, children) ->
    @name = name
    @diskName = diskName
    @children = children or 0
    return

class MappingFileSystem
    constructor: () ->
        @rootPath = ""
        @_filesMap = null
        @_filesLen = 0
        @_dirsMap = null
        return

    findFileInfo: (name) ->
        return @_filesMap[name]

    forEachFileInfos: (func) ->
        for _, fileInfo of @_filesMap
            func(fileInfo)
        return

    mapFileInfos: (func) ->
        resultArray = new Array(@_filesLen)
        resultLen = 0
        for _, fileInfo of @_filesMap
            resultArray[resultLen] = func(fileInfo)
            resultLen = resultLen + 1
        return resultArray

    _read_ = (name) ->
        fileInfo = @_filesMap[name]
        if fileInfo
            return fileInfo
        else
            throw new Error("File not found: #{name}")

    readFile: (name, encoding) ->
        fileInfo = _read_(name)
        return fs.readFileSync(fileInfo.diskName, encoding)

    readStream = (name, encoding) ->
        fileInfo = _read_(name)
        return fs.createReadStream(fileInfo.diskName, encoding)

    _write_: (name) ->
        fileInfo = @_filesMap[name]
        if fileInfo
            return fileInfo
        else
            prevDirInfo = @_dirsMap[""]
            for idx in [0...name.length] by 1
                if "/" == name[idx]
                    dirPath = name[...idx]
                    dirInfo = @_dirsMap[dirPath]
                    if not dirInfo
                        prevDirInfo.children = prevDirInfo.children + 1
                        @_dirsMap[dirPath] = new DirInfo(dirPath, "#{@rootPath}/#{dirPath}")
                        fs.mkdirSync("#{@rootPath}/#{dirPath}")
                    prevDirInfo = dirInfo
            prevDirInfo.children = prevDirInfo.children + 1
            @_filesMap[fileInfo.name] = new FileInfo(name, "#{@rootPath}/#{name}")
            @_filesLen = @_filesLen + 1
            return fileInfo

    writeFile: (name, buffer) ->
        fileInfo = _write_(name)
        return fs.writeFile(fileInfo.diskName, buffer)

    writeStream: (name, buffer) ->
        fileInfo = _write_(name)
        return fs.writeFile(fileInfo.diskName, buffer)

    removeFile: (name) ->
        fileInfo = @_filesMap[name]
        if not fileInfo
            throw new Error("File not found: #{name}")
        else
            fs.unlinkSync(fileInfo.diskName)
            delete @_filesMap[name]
            @_filesLen = @_filesLen - 1
            for idx in [name.length-1...0] by -1
                if "/" == name[idx]
                    dirPath = name[...idx]
                    dirInfo = @_dirsMap[dirPath]
                    if dirInfo.children <= 1
                        fs.rmdirSync(info.diskName)
                        delete @_dirsMap[dirPath]
                    else
                        dirInfo.children = dirInfo.children - 1
                        return
        return

    _syncToDisk_: (parent, diskParent) ->
        filesArray = fs.readdirSync(diskParent)
        @_dirsMap[parent] = new DirInfo(parent, diskParent, filesArray.length)
        for file in filesArray
            child = "#{parent}/#{file}"
            diskChild = "#{@rootPath}/#{parent}/#{file}"
            stat = fs.statSync(diskChild)
            if stat.isFile()
                @_filesMap[child] = new FileInfo(child, diskChild, stat.mtime)
                @_filesLen = @_filesLen + 1
            else if stat.isDirectory()
                return _syncToDisk_(child, diskChild)
        return

    syncToDisk: () ->
        @_filesMap = Object.create(null)
        @_filesLen = 0
        @_dirsMap = Object.create(null)
        @_syncToDisk_("", @rootPath)
        return

MappingFileSystem.create = (rootPath) ->
    ins = new MappingFileSystem()
    rootPath = name.normalize("#{rootPath}/")
    ins.rootPath = rootPath[...-1]
    ins.syncToDisk()
    return ins

class VirtualFileSystem
    constructor: () ->
        @_filesMap = null
        @_filesLen = 0
        return

    findFileInfo: (name) ->
        return @_filesMap[name]

    forEachFileInfos: (func) ->
        for _, fileInfo of @_filesMap
            func(fileInfo)
        return

    mapFileInfos: (func) ->
        resultArray = new Array(@_filesLen)
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
            throw new Error("File not found: #{name}")

    writeFile: (name, buffer) ->
        fileInfo = @_filesMap[name]
        if fileInfo
            return fs.writeFileSync(fileInfo.diskName, buffer)
        else
            throw new Error("File not found: #{name}")

VirtualFileSystem.create = (infosArray) ->
    ins = new MappingFileSystem()
    ins._filesMap = Object.create(null)
    ins._filesLen = infosArray.length
    for info in infosArray
        if not ins._filesMap[info.name]
            ins._filesMap[info.name] = info
        else
            throw new Error("File name confilict: #{info.name}")
    return ins

exports.MappingFileSystem = MappingFileSystem
exports.VirtualFileSystem = VirtualFileSystem