# # # # # # # # # # # # # # # # # # # #
# remote_fs_test.coffee
# # # # # # # # # # # # # # # # # # # #

assert= require("assert")
fs = require("fs")
cp = require("child_process")
mocha = require("mocha")
util = require("./test_util.coffee")
{coroutine} = require("../src/async_util.coffee")
sshUtil = require("../src/ssh_util.coffee")
RemoteFs = require("../src/remote_fs.coffee")

sshClient = null

before () ->
    this.timeout(5000)
    return coroutine () ->
        sshClient = yield sshUtil.createSshLink({
            host: 'fenqi.io'
            port: 22,
            username: 'nanuno',
            password: "jbcnmb8888"
        }, ".")
        sftpClient = yield sshUtil.createSftpLink(sshClient)
        yield sshUtil.sftpUpland(sftpClient, "./ssh_test.tar.bz2", "./test/ssh_test.tar.bz2")
        result = yield sshUtil.sshExec(sshClient, "tar -jxvf ssh_test.tar.bz2")
        if 0 != result.code
            throw new Error(result)

after () ->
    this.timeout(5000)
    return coroutine () ->
        result = yield sshUtil.sshExec(sshClient, "rm -r ssh_test")
        if 0 != result.code
            throw new Error(result)
        result = yield sshUtil.sshExec(sshClient, "rm ssh_test.tar.bz2")
        if 0 != result.code
            throw new Error(result)
        sshUtil.destorySshLink(sshClient)

describe "RemoteFs.create()", () ->
    this.timeout(5000)
    it "RemoteFs.create()", () ->
        return coroutine () ->
            remoteFs = yield RemoteFs.create({
                host: 'fenqi.io'
                port: 22,
                username: 'nanuno',
                password: "jbcnmb8888"
            }, "ssh_test/create/")
            assert(remoteFs)

            dirsArray = util.mapToArray(remoteFs.dirsMap)
            assert(3 == dirsArray.length)

            assert("" == dirsArray[0].name)
            assert("ssh_test/create/" == dirsArray[0].diskName)
            assert(3 == dirsArray[0].children)

            assert("folder-1" == dirsArray[1].name)
            assert("ssh_test/create/folder-1" == dirsArray[1].diskName)
            assert(2 == dirsArray[1].children)

            assert("folder-2" == dirsArray[2].name)
            assert("ssh_test/create/folder-2" == dirsArray[2].diskName)
            assert(0 == dirsArray[2].children)

            filesArray = util.mapToArray(remoteFs.filesMap)
            assert(3 == filesArray.length)

            assert("file-1" == filesArray[0].name)
            assert("ssh_test/create/file-1" == filesArray[0].diskName)

            assert("folder-1/file-a" == filesArray[1].name)
            assert("ssh_test/create/folder-1/file-a" == filesArray[1].diskName)

            assert("folder-1/file-b" == filesArray[2].name)
            assert("ssh_test/create/folder-1/file-b" == filesArray[2].diskName)

describe "RemoteFs.upland()", () ->
    this.timeout(5000)
    it "RemoteFs.upland()", () ->
        return coroutine () ->
            remoteFs = yield RemoteFs.create({
                host: 'fenqi.io'
                port: 22,
                username: 'nanuno',
                password: "jbcnmb8888"
            }, "ssh_test/upland/")
            assert(remoteFs)

            yield remoteFs.upland("file-1", "./test/ssh_test.txt")
            yield remoteFs.upland("folder-1/file-2", "./test/ssh_test.txt")
            yield remoteFs.upland("folder-1/folder-2/file-3", "./test/ssh_test.txt")

            dirsArray = util.mapToArray(remoteFs.dirsMap)
            assert(3 == dirsArray.length)

            assert("" == dirsArray[0].name)
            assert("ssh_test/upland/" == dirsArray[0].diskName)
            assert(2 == dirsArray[0].children)

            assert("folder-1" == dirsArray[1].name)
            assert("ssh_test/upland/folder-1" == dirsArray[1].diskName)
            assert(2 == dirsArray[1].children)

            assert("folder-1/folder-2" == dirsArray[2].name)
            assert("ssh_test/upland/folder-1/folder-2" == dirsArray[2].diskName)
            assert(1 == dirsArray[2].children)

            filesArray = util.mapToArray(remoteFs.filesMap)
            assert(3 == filesArray.length)

            assert("file-1" == filesArray[0].name)
            assert("ssh_test/upland/file-1" == filesArray[0].diskName)

            assert("folder-1/file-2" == filesArray[1].name)
            assert("ssh_test/upland/folder-1/file-2" == filesArray[1].diskName)

            assert("folder-1/folder-2/file-3" == filesArray[2].name)
            assert("ssh_test/upland/folder-1/folder-2/file-3" == filesArray[2].diskName)

describe "RemoteFs.downland()", () ->
    this.timeout(5000)
    it "RemoteFs.downland()", () ->
        return coroutine () ->
            remoteFs = yield RemoteFs.create({
                host: 'fenqi.io'
                port: 22,
                username: 'nanuno',
                password: "jbcnmb8888"
            }, "ssh_test/downland/")
            assert(remoteFs)

            yield remoteFs.downland("file", "./test/ssh_dowland")

            dirsArray = util.mapToArray(remoteFs.dirsMap)
            assert(1 == dirsArray.length)

            assert("" == dirsArray[0].name)
            assert("ssh_test/downland/" == dirsArray[0].diskName)
            assert(1 == dirsArray[0].children)

            filesArray = util.mapToArray(remoteFs.filesMap)
            assert(1 == filesArray.length)

            assert("file" == filesArray[0].name)
            assert("ssh_test/downland/file" == filesArray[0].diskName)

            try
                yield remoteFs.read("folder/file", "./test/ssh_dowland")
                util.shouldThrowError()
            catch error
                # ok do nothing

describe "RemoteFs.delete()", () ->
    this.timeout(5000)
    it "RemoteFs.delete()", () ->
        return coroutine () ->
            remoteFs = yield RemoteFs.create({
                host: 'fenqi.io'
                port: 22,
                username: 'nanuno',
                password: "jbcnmb8888"
            }, "ssh_test/delete/")
            assert(remoteFs)

            yield remoteFs.delete("folder-1/folder-2/file-2")

            dirsArray = util.mapToArray(remoteFs.dirsMap)
            assert(2 == dirsArray.length)

            assert("" == dirsArray[0].name)
            assert("ssh_test/delete/" == dirsArray[0].diskName)
            assert(1 == dirsArray[0].children)

            assert("folder-1" == dirsArray[1].name)
            assert("ssh_test/delete/folder-1" == dirsArray[1].diskName)
            assert(1 == dirsArray[1].children)

            filesArray = util.mapToArray(remoteFs.filesMap)
            assert(1 == filesArray.length)

            assert("folder-1/file-1" == filesArray[0].name)
            assert("ssh_test/delete/folder-1/file-1" == filesArray[0].diskName)

            try
                yield remoteFs.delete("folder/file")
                util.shouldThrowError()
            catch error
                # ok do nothing
