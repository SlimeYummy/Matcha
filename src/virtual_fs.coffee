# # # # # # # # # # # # # # # # # # # #
# virtual_fs.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
fs = require("fs")
{FileInfo, DirInfo} = require("./fs_info.coffee")


class VirtualFs
    constructor: () ->
        @filesMap = null
        return

    read: (name, encoding) ->
        fileInfo = @filesMap[name]
        if not fileInfo
            throw new Error("File not found: #{name}")
        return fs.readFileSync(fileInfo.diskName, encoding)

    write: (name, buffer) ->
        fileInfo = @filesMap[name]
        if fileInfo
            throw new Error("File not found: #{name}")
        return fs.writeFileSync(fileInfo.diskName, buffer)

VirtualFs.create = (infosArray) ->
    filesMap = Object.create(null)
    for info in infosArray
        if filesMap[info.name]
            throw new Error("File name confilict: #{info.name}")
        filesMap[info.name] = info
    ins = new VirtualFs()
    ins.filesMap = filesMap
    return ins

module.exports = VirtualFs
