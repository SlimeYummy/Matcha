# # # # # # # # # # # # # # # # # # # #
# local_fs.coffee
# # # # # # # # # # # # # # # # # # # #

fs = require("fs")
path = require("path").posix

class FileInfo
    constructor: (name, diskName, mtime) ->
        @name = name
        @diskName = diskName
        @baseName = path.basename(name)
        @extName = path.extname(name)
        @mtime = mtime or new Date()
        return

class DirInfo
    constructor: (name, diskName, children) ->
        @name = name
        @diskName = diskName
        @children = children or 0
        return


class LocalFs
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
                        dirInfo = new DirInfo(dirPath, "#{@rootPath}/#{dirPath}")
                        @_dirsMap[dirPath] = dirInfo
                        fs.mkdirSync("#{@rootPath}/#{dirPath}")
                    prevDirInfo = dirInfo
            prevDirInfo.children = prevDirInfo.children + 1
            fileInfo = new FileInfo(name, "#{@rootPath}/#{name}")
            @_filesMap[name] = fileInfo
        return fs.writeFileSync(fileInfo.diskName, buffer)

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
                    fs.rmdirSync(dirInfo.diskName)
                    delete @_dirsMap[dirPath]
                else
                    dirInfo.children = dirInfo.children - 1
                    break
        return

LocalFs.create = (rootPath) ->
    ins = new LocalFs()
    ins.rootPath = path.normalize("#{rootPath}/")
    ins._filesMap = Object.create(null)
    ins._dirsMap = Object.create(null)
    travelFunc = (parent, diskParent) ->
        filesArray = fs.readdirSync(diskParent)
        ins._dirsMap[parent] = new DirInfo(parent, diskParent, filesArray.length)
        for file in filesArray
            diskChild = path.normalize("#{ins.rootPath}/#{parent}/#{file}")
            child = diskChild[ins.rootPath.length...]
            stat = fs.statSync(diskChild)
            if stat.isFile()
                ins._filesMap[child] = new FileInfo(child, diskChild, stat.mtime)
            else if stat.isDirectory()
                travelFunc(child, diskChild)
        return
    travelFunc("", rootPath)
    return ins

exports.LocalFs = LocalFs

#localFs = LocalFs.create("./root")
#console.log localFs

#text = "This is file new."
#localFs.write("folder_new/file_new", text)
#console.log localFs.read("folder_new/file_new", "utf8")
#localFs.unlink("folder_new/file_new11")
