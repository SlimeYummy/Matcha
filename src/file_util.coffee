# # # # # # # # # # # # # # # # # # # #
# fs_info.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
path = require("path").posix

class FileInfo
    constructor: (name, diskName, mtime) ->
        @name = name
        @diskName = diskName
        @url = path.parse(name)
        @mtime = mtime or new Date()
        @using = false
        return

class DirInfo
    constructor: (name, diskName, children) ->
        @name = name
        @diskName = diskName
        @children = children or 0
        return

normalizeWith = (basePath, inputPath) ->
    if "/" == inputPath[0]
        return inputPath
    else
        return path.normalize("#{basePath}/#{inputPath}")

renameUnderline = (fileName, extName, index) ->
    start = 0
    while start < fileName
        if "_" != fileName[start]
            break
        start = start + 1
    end = fileName.length - 1
    while end > 0
        end = end - 1
        if "." == fileName[end]
            break
    fragName = fileName[start...end]
    if "number" != typeof(index) or 1 == index
        return "#{fragName}#{extName}"
    else
        return "#{fragName}_#{index}#{extName}"

exports.FileInfo = FileInfo
exports.DirInfo = DirInfo
exports.normalizeWith = normalizeWith
exports.renameUnderline = renameUnderline
