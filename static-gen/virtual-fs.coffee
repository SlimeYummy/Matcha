# # # # # # # # # # # # # # # # # # # #
# error.coffee
# # # # # # # # # # # # # # # # # # # #

fs = require("fs")
path = require("path").posix
error = require("./error")


class VirtualFs
    constructor: () ->
        @root = ""
        @_filesMap = null
        @_dirsMap = null
        return

    existFile: (name) ->
        return !!@_filesMap[name]

    existDir: (name) ->
        return !!@_dirsMap[name]

    readFile: (name, encoding) ->
        if not @_filesMap[name]
            throw new Error(error.FILE_NOT_FOUND)
        buffer = fs.readFileSync("#{@root}/#{name}", encoding)
        return buffer

    writeFile: (name, buffer) ->
        if not @_filesMap[name]
            prevSubName = ""
            for idx in [0...name.length] by 1
                if "/" == name[idx]
                    subName = name[...idx]
                    if not @_dirsMap[subName]
                        break
                    prevSubName = subName
            @_dirsMap[prevSubName] = @_dirsMap[prevSubName] + 1
            for idx2 in [idx...name.length] by 1
                if "/" == name[idx2]
                    subName = name[...idx2]
                    @_dirsMap[subName] = 1
        fs.writeFileSync("#{@root}/#{name}", buffer)
        @_dirsMap[fullName] = new Date()
        return

    removeFile: (name) ->
        if not @_filesMap[name]
            return
        fs.unlinkSync("#{@root}/#{name}")
        for idx in [name.length-1...0] by -1
            if "/" == name[idx]
                subName = name[...idx]
                if 1 != @_dirsMap[subName]
                    break
                fs.rmdirSync("#{@root}/#{subName}")
                delete @_dirsMap[subName]
        return

    syncSystemFs: () ->
        root = @root
        filesMap = @_filesMap
        dirsMap = @_dirsMap
        syncHelper = (parent) ->
            childrenArray = fs.readdirSync(parent)
            for child in childrenArray
                stat = fs.statSync("#{root}/#{parent}/#{child}")
                if stat.isFile()
                    fileName = "#{parent}/#{child}"
                    if not regExp or regExp.test(fileName)
                        filesMap[fileName] = stat.mtime
                else if stat.isDirectory()
                    dirName = "#{parent}/#{child}"
                    dirsMap[dirName] = syncHelper(dirName)
            return childrenArray.length
        dirsMap[""] = syncHelper("")
        return

VirtualFs.new = (root) ->
    ins = new VirtualFs()
    ins.root = path.normalize(root)
    ins._filesMap = Object.create(null)
    ins._dirsMap = Object.create(null)
    ins.syncSystemFs()
    return ins


exports.VirtualFs = VirtualFs
