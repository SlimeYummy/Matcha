# # # # # # # # # # # # # # # # # # # #
# file-system.coffee
# # # # # # # # # # # # # # # # # # # #

fs = require("fs")
path = require("path").posix
error = require("./error")


FileInfo = (name, time) ->
    @name = name
    @baseName = path.basename(name)
    @extName = path.extname(name)
    @time = time or new Data()
    return

DirInfo = (name, dhildren) ->
    @name = name
    @dhildren = dhildren or 1
    return

class FileSystem
    constructor: () ->
        @root = ""
        @_filesMap = null
        @_dirsMap = null
        return

    getFileInfo: (name) ->
        return @_filesMap[name]

    getDirInfo: (name) ->
        return @_dirsMap[name]

    forEachFiles: (func) ->
        for _, fileInfo of @_filesMap
            func(fileInfo)
        return

    foreachDirs: (func) ->
        for _, dirInfo of @_dirsMap
            func(dirInfo)
        return

    readFile: (name, encoding) ->
        if not @_filesMap[name]
            throw new Error("#{error.FILE_NOT_FOUND}: #{name}")
        buffer = fs.readFileSync("#{@root}#{name}", encoding)
        return buffer

    writeFile: (name, buffer) ->
        if not @_filesMap[name]
            lastDirInfo = @_dirsMap["/"]
            for idx in [0...name.length] by 1
                if "/" == name[idx]
                    subName = name[..idx]
                    if not @_dirsMap[subName]
                        break
                    lastDirInfo = @_dirsMap[subName]
            lastDirInfo.children = lastDirInfo.children + 1
            for idx2 in [idx...name.length] by 1
                if "/" == name[idx2]
                    subName = name[..idx2]
                    @_dirsMap[subName] = new DirInfo(name)
        fs.writeFileSync("#{@root}#{name}", buffer)
        @_dirsMap[fullName] = new FileInfo(name)
        return

    removeFile: (name) ->
        if not @_filesMap[name]
            return
        fs.unlinkSync("#{@root}#{name}")
        for idx in [name.length-1...0] by -1
            if "/" == name[idx]
                subName = name[..idx]
                if @_dirsMap[subName].children > 1
                    break
                fs.rmdirSync("#{@root}#{subName}")
                delete @_dirsMap[subName]
        return

    removeDir: (name) ->
        if not @_dirsMap[name]
            return
        for idx in [name.length-1...0] by -1
            if "/" == name[idx]
                subName = name[..idx]
                if @_dirsMap[subName].children > 1
                    break
                fs.rmdirSync("#{@root}#{subName}")
                delete @_dirsMap[subName]
        return

    syncSystemFs: () ->
        root = @root
        filesMap = @_filesMap
        dirsMap = @_dirsMap
        syncHelper = (parent) ->
            childrenArray = fs.readdirSync(parent)
            for child in childrenArray
                stat = fs.statSync("#{root}#{parent}#{child}")
                if stat.isFile()
                    fileName = "#{parent}#{child}"
                    if not regExp or regExp.test(fileName)
                        filesMap[fileName] = new FileInfo(fileName, stat.mtime)
                else if stat.isDirectory()
                    dirName = "#{parent}#{child}/"
                    children = syncHelper(dirName)
                    dirsMap[dirName] = new DirInfo(dirName, children)
            return childrenArray.length
        dirsMap[""] = syncHelper("")
        return

FileSystem.create = (root) ->
    ins = new FileSystem()
    ins.root = path.normalize("#{root}/")
    ins._filesMap = Object.create(null)
    ins._dirsMap = Object.create(null)
    ins.syncSystemFs()
    return ins


exports.FileSystem = FileSystem
