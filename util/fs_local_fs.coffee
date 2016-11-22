# # # # # # # # # # # # # # # # # # # #
# fs_local_fs.coffee
# # # # # # # # # # # # # # # # # # # #

fs = require("fs")
path = require("path").posix

class LocalFileSystem
    constructor: () ->
        @rootPath = ""
        @_filesMap = null
        @_dirsMap = null
        return

    find: (name) ->
        return @_filesMap[name]

    forEach: (func) ->
        for _, fileInfo of @_filesMap
            func(fileInfo)
        return

    read: (name, encoding) ->
        fileInfo = @_filesMap[name]
        if not fileInfo
            throw new Error("File not found: #{name}")
        return fs.readFileSync(fileInfo.diskName, encoding)

    write: (name, buffer) ->
        fileInfo = @_filesMap[name]
        if not fileInfo
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
            @_filesMap[name] = new FileInfo(name, "#{@rootPath}/#{name}")
        return fs.writeFileSync(fileInfo.diskName)

    unlink: (name) ->
        fileInfo = @_filesMap[name]
        if not fileInfo
            throw new Error("File not found: #{name}")
        fs.unlinkSync(fileInfo.diskName)
        delete @_filesMap[name]
        for idx in [name.length-1..0] by -1
            if "/" == name[idx]
                dirPath = name[...idx]
                dirInfo = @_dirsMap[dirPath]
                if dirInfo.children <= 1
                    fs.rmdirSync(info.diskName)
                    delete @_dirsMap[dirPath]
                else
                    dirInfo.children = dirInfo.children - 1
                    break
        return

LocalFileSystem.create = (rootPath) ->
    ins = new MappingFileSystem()
    ins.rootPath = name.normalize("#{rootPath}/")[...-1]
    ins._filesMap = Object.create(null)
    ins._dirsMap = Object.create(null)
    travelFunc = (parent, diskParent) ->
        filesArray = fs.readdirSync(diskParent)
        ins._dirsMap[parent] = new DirInfo(parent, diskParent, filesArray.length)
        for file in filesArray
            child = "#{parent}/#{file}"
            diskChild = "#{ins.rootPath}/#{parent}/#{file}"
            stat = fs.statSync(diskChild)
            if stat.isFile()
                ins._filesMap[child] = new FileInfo(child, diskChild, stat.mtime)
            else if stat.isDirectory()
                travelFunc(child, diskChild)
        return
    travelFunc("", rootPath)
    return ins
