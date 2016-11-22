# # # # # # # # # # # # # # # # # # # #
# fs_virtual_fs.coffee
# # # # # # # # # # # # # # # # # # # #

class VirtualFileSystem
    constructor: () ->
        @_filesMap = null
        return

    find: (name) ->
        return @_filesMap[name]

    forEach: (func) ->
        for _, fileInfo of @_filesMap
            func(fileInfo)
        return

    readFile: (name, encoding) ->
        fileInfo = @_filesMap[name]
        if not fileInfo
            throw new Error("File not found: #{name}")
        return fs.readFileSync(fileInfo.diskName, encoding)

    writeFile: (name, buffer) ->
        fileInfo = @_filesMap[name]
        if fileInfo
            throw new Error("File not found: #{name}")
        return fs.writeFileSync(fileInfo.diskName, buffer)

VirtualFileSystem.create = (infosArray) ->
    ins = new MappingFileSystem()
    ins._filesMap = Object.create(null)
    for info in infosArray
        if not ins._filesMap[info.name]
            throw new Error("File name confilict: #{info.name}")
        ins._filesMap[info.name] = info
    return ins
