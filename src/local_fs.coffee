# # # # # # # # # # # # # # # # # # # #
# local_fs.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
fs = require("fs")
fileUtil = require("./file_util.coffee")


class LocalFs
    constructor: () ->
        @rootPath = ""
        @filesMap = null
        @dirsMap = null
        return

    read: (path, encoding) ->
        fileInfo = @filesMap[path]
        if not fileInfo
            throw new Error("File not found: #{path}")
        return fs.readFileSync(fileInfo.diskPath, encoding)

    write: (path, buffer) ->
        fileInfo = @filesMap[path]
        if fileInfo
            fileInfo.mtime = new Date()
            return fs.writeFileSync(fileInfo.diskPath, buffer)
        # create folder
        prevDirInfo = @dirsMap[""]
        for idx in [0...path.length] by 1
            if "/" == path[idx]
                dirPath = path[...idx]
                dirInfo = @dirsMap[dirPath]
                if not dirInfo
                    prevDirInfo.children = prevDirInfo.children + 1
                    dirInfo = new fileUtil.DirInfo(dirPath, "#{@rootPath}/#{dirPath}")
                    @dirsMap[dirPath] = dirInfo
                    fs.mkdirSync("#{@rootPath}/#{dirPath}")
                prevDirInfo = dirInfo
        # create file
        prevDirInfo.children = prevDirInfo.children + 1
        fileInfo = new fileUtil.FileInfo(path, "#{@rootPath}/#{path}")
        @filesMap[path] = fileInfo
        # write file
        fileInfo.mtime = new Date()
        return fs.writeFileSync(fileInfo.diskPath, buffer)

    delete: (path) ->
        fileInfo = @filesMap[path]
        if not fileInfo
            throw new Error("File not found: #{path}")
        fs.unlinkSync(fileInfo.diskPath)
        delete @filesMap[path]
        for idx in [path.length-1..0] by -1
            if "/" == path[idx]
                dirPath = path[...idx]
                dirInfo = @dirsMap[dirPath]
                if dirInfo.children <= 1
                    fs.rmdirSync(dirInfo.diskPath)
                    delete @dirsMap[dirPath]
                else
                    dirInfo.children = dirInfo.children - 1
                    break
        return

LocalFs.create = (rootPath) ->
    # travel root
    rootPath = fileUtil.normalize("#{rootPath}/")[...-1]
    filesMap = Object.create(null)
    dirsMap = Object.create(null)
    travelFunc = (parent, diskParent) ->
        filesArray = fs.readdirSync(diskParent)
        dirsMap[parent] = new fileUtil.DirInfo(parent, diskParent, filesArray.length)
        for file in filesArray
            diskChild = fileUtil.normalize("#{rootPath}/#{parent}/#{file}")
            child = diskChild[rootPath.length...]
            stat = fs.statSync(diskChild)
            if stat.isFile()
                filesMap[child] = new fileUtil.FileInfo(child, diskChild, stat.mtime)
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
