# # # # # # # # # # # # # # # # # # # #
# virtual_fs.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
fs = require("fs")

class VirtualFs
    @create: (infosArray) ->
        filesMap = Object.create(null)
        for info in infosArray
            if filesMap[info.path]
                throw new Error("File path confilict: #{info.path}")
            filesMap[info.path] = info
        ins = new VirtualFs()
        ins.filesMap = filesMap
        return ins

    read: (path, encoding) ->
        fileInfo = @filesMap[path]
        if not fileInfo
            throw new Error("File not found: #{path}")
        return fs.readFileSync(fileInfo.diskPath, encoding)

    write: (path, buffer) ->
        fileInfo = @filesMap[path]
        if fileInfo
            throw new Error("File not found: #{path}")
        return fs.writeFileSync(fileInfo.diskPath, buffer)

module.exports = VirtualFs
