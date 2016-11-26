# # # # # # # # # # # # # # # # # # # #
# fs_info.coffee
# # # # # # # # # # # # # # # # # # # #

"use strict"
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

exports.FileInfo = FileInfo
exports.DirInfo = DirInfo
