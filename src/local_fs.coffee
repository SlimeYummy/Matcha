# # # # # # # # # # # # # # # # # # # #
# local_fs.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
fs = require("fs")
path = require("path").posix
{FileInfo, DirInfo} = require("./fs_info.coffee")


class LocalFs
    constructor: () ->
        @rootPath = ""
        @filesMap = null
        @dirsMap = null
        return

    read: (name, encoding) ->
        fileInfo = @filesMap[name]
        if not fileInfo
            throw new Error("File not found: #{name}")
        return fs.readFileSync(fileInfo.diskName, encoding)

    write: (name, buffer) ->
        fileInfo = @filesMap[name]
        if fileInfo
            fileInfo.using = true
            return fs.writeFileSync(fileInfo.diskName, buffer)
        # create folder
        prevDirInfo = @dirsMap[""]
        for idx in [0...name.length] by 1
            if "/" == name[idx]
                dirPath = name[...idx]
                dirInfo = @dirsMap[dirPath]
                if not dirInfo
                    prevDirInfo.children = prevDirInfo.children + 1
                    dirInfo = new DirInfo(dirPath, "#{@rootPath}/#{dirPath}")
                    @dirsMap[dirPath] = dirInfo
                    fs.mkdirSync("#{@rootPath}/#{dirPath}")
                prevDirInfo = dirInfo
        # create file
        prevDirInfo.children = prevDirInfo.children + 1
        fileInfo = new FileInfo(name, "#{@rootPath}/#{name}")
        fileInfo.using = true
        @filesMap[name] = fileInfo
        # write file
        return fs.writeFileSync(fileInfo.diskName, buffer)

    delete: (name) ->
        fileInfo = @filesMap[name]
        if not fileInfo
            throw new Error("File not found: #{name}")
        fs.unlinkSync(fileInfo.diskName)
        delete @filesMap[name]
        for idx in [name.length-1..0] by -1
            if "/" == name[idx]
                dirPath = name[...idx]
                dirInfo = @dirsMap[dirPath]
                if dirInfo.children <= 1
                    fs.rmdirSync(dirInfo.diskName)
                    delete @dirsMap[dirPath]
                else
                    dirInfo.children = dirInfo.children - 1
                    break
        return

    touch: (name) ->
        fileInfo = @filesMap[name]
        if not fileInfo
            throw new Error("File not found: #{name}")
        fileInfo.using = true
        return

LocalFs.create = (rootPath) ->
    # travel root
    rootPath = path.normalize("#{rootPath}/")[...-1]
    filesMap = Object.create(null)
    dirsMap = Object.create(null)
    travelFunc = (parent, diskParent) ->
        filesArray = fs.readdirSync(diskParent)
        dirsMap[parent] = new DirInfo(parent, diskParent, filesArray.length)
        for file in filesArray
            diskChild = path.normalize("#{rootPath}/#{parent}/#{file}")
            child = diskChild[rootPath.length+1...]
            stat = fs.statSync(diskChild)
            if stat.isFile()
                filesMap[child] = new FileInfo(child, diskChild, stat.mtime)
            else if stat.isDirectory()
                travelFunc(child, diskChild)
        return
    travelFunc("", rootPath)
    # create instance
    ins = new LocalFs()
    ins.rootPath = rootPath
    ins.filesMap = filesMap
    ins.dirsMap = dirsMap
    return ins

module.exports = LocalFs
