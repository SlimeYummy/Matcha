# # # # # # # # # # # # # # # # # # # #
# fs-info.coffee
# # # # # # # # # # # # # # # # # # # #

class exports.FileInfo
    constructor: (name, diskName, mtime) ->
        @name = name
        @diskName = diskName
        @baseName = path.basename(name)
        @extName = path.extname(name)
        @mtime = mtime or new Data()
        return

class exports.DirInfo
    constructor: (name, diskName, children) ->
        @name = name
        @diskName = diskName
        @children = children or 0
        return
