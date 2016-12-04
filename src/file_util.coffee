# # # # # # # # # # # # # # # # # # # #
# fs_info.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
pathUtil = require("path").posix

class exports.FileInfo
    constructor: (path, diskPath, mtime) ->
        @path = path
        @diskPath = diskPath
        @url = pathUtil.parse(path)
        @mtime = mtime or new Date()
        return

class exports.DirInfo
    constructor: (path, diskPath, children) ->
        @path = path
        @diskPath = diskPath
        @children = children or 0
        return

exports.normalize = pathUtil.normalize

exports.normalizeWith = (basePath, inputPath) ->
    if "/" == inputPath[0]
        return inputPath
    else
        return pathUtil.normalize("#{basePath}/#{inputPath}")

exports.renameUnderline = (baseName, extName, index) ->
    offset = 0
    while offset < baseName.length
        if "_" != baseName[offset]
            break
        offset = offset + 1
    clearName = baseName[offset...]
    if "number" != typeof(index) or 1 == index
        return "#{clearName}#{extName}"
    else
        return "#{clearName}_#{index}#{extName}"
