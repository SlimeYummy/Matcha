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

exports.FileInfo = FileInfo
exports.DirInfo = DirInfo
