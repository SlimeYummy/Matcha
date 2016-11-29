# # # # # # # # # # # # # # # # # # # #
# remote_fs_test.coffee
# # # # # # # # # # # # # # # # # # # #

assert= require("assert")
fs = require("fs")
cp = require("child_process")
mocha = require("mocha")
RemoteFs = require("../src/remote_fs.coffee")

mapToArray = (map) ->
    array = []
    for key, value of map
        array.push(value)
    array.sort (a, b) ->
        return a.name > b.name
    return array

shouldThrowError = () ->
    return new Error("Should throw error.")

describe "LocalFs.create()", (done) ->
    return coroutine () ->
        remote = yield RemoteFs.create({
            host: 'fenqi.io'
            port: 22,
            username: 'nanuno',
            password: "jbcnmb8888"
        }, "ssh_test/create/")
        assert(null != remoteFs)

        dirsArray = mapToArray(remoteFs.dirsMap)
        assert(3 == dirsArray.length)

        assert("" == dirsArray[0].name)
        assert("ssh_test/create/" == dirsArray[0].diskName)
        assert(3 == dirsArray[0]children)

        assert("folder-1" == dirsArray[1].name)
        assert("ssh_test/create/folder-1" == dirsArray[1].diskName)
        assert(2 == dirsArray[1]children)

        assert("folder-2" == dirsArray[2].name)
        assert("ssh_test/create/folder-2" == dirsArray[2].diskName)
        assert(0 == dirsArray[2]children)

        filesArray = mapToArray(remoteFs.filesMap)
        assert(3 == filesArray.length)

        assert("file-1" == filesArray[0].name)
        assert("ssh_test/create/file-1" == filesArray[0].diskName)

        assert("folder-1/file-a" == filesArray[1].name)
        assert("ssh_test/create/folder-1/file-a" == filesArray[1].diskName)

        assert("folder-1/file-b" == filesArray[2].name)
        assert("ssh_test/create/folder-1/file-b" == filesArray[2].diskName)

        done()

describe "LocalFs.upland()", (done) ->
    return coroutine () ->
        remoteFs = yield RemoteFs.create({
            host: 'fenqi.io'
            port: 22,
            username: 'nanuno',
            password: "jbcnmb8888"
        }, "ssh_test/upland/")
        assert(null != remoteFs)

        yield remoteFs.upland("file-1", )
        yield remoteFs.upland("folder-1/file-2", )
        yield remoteFs.upland("folder-1/folder-2/file-3", )

        dirsArray = mapToArray(remoteFs.dirsMap)
        assert(3 == dirsArray.length)

        assert("" == dirsArray[0].name)
        assert("ssh_test/upland/" == dirsArray[0].diskName)
        assert(1 == dirsArray[0]children)

        assert("folder-1" == dirsArray[1].name)
        assert("ssh_test/upland/folder-1" == dirsArray[1].diskName)
        assert(2 == dirsArray[1]children)

        assert("folder-1/folder-2" == dirsArray[2].name)
        assert("ssh_test/upland/folder-1/folder-2" == dirsArray[2].diskName)
        assert(1 == dirsArray[2]children)

        filesArray = mapToArray(remoteFs.filesMap)
        assert(3 == filesArray.length)

        assert("file-1" == filesArray[0].name)
        assert("ssh_test/upland/file-1" == filesArray[0].diskName)

        assert("folder-1/file-1" == filesArray[1].name)
        assert("ssh_test/upland/folder-1/file-1" == filesArray[1].diskName)

        assert("folder-1/folder-2/file-2" == filesArray[2].name)
        assert("ssh_test/upland/folder-1/folder-2/file-2" == filesArray[2].diskName)

        return

describe "LocalFs.downland()", (done) ->
    return coroutine () ->
        remoteFs = yield RemoteFs.create({
            host: 'fenqi.io'
            port: 22,
            username: 'nanuno',
            password: "jbcnmb8888"
        }, "ssh_test/downland/")
        assert(null != remoteFs)

        yield remoteFs.read("file")

        try
            yield remoteFs.read("folder/file")
            shouldThrowError()
        catch error
            # ok do nothing

        return

describe "LocalFs.delete()", (done) ->
    return coroutine () ->
        remoteFs = yield RemoteFs.create({
            host: 'fenqi.io'
            port: 22,
            username: 'nanuno',
            password: "jbcnmb8888"
        }, "ssh_test/delete/")
        assert(null != remoteFs)

        yield remoteFs.read("file")

        try
            yield remoteFs.read("folder/file")
            shouldThrowError()
        catch error
            # ok do nothing

        return
