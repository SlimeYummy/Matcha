# # # # # # # # # # # # # # # # # # # #
# local_fs_test.coffee
# # # # # # # # # # # # # # # # # # # #

assert= require("assert")
fs = require("fs")
cp = require("child_process")
mocha = require("mocha")
util = require("./test_util.coffee")
LocalFs = require("../src/local_fs.coffee")

describe "LocalFs.create()", () ->
    before util.clearRoot
    afterEach util.clearRoot

    it "Empty folder", (done) ->
        fs.mkdirSync("root")
        localFs = LocalFs.create("root")
        assert(null != localFs)

        dirsArray = util.mapToArray(localFs.dirsMap)
        assert(1 == dirsArray.length)
        assert("" == dirsArray[0].name && 0 == dirsArray[0].children)

        filesArray = util.mapToArray(localFs.filesMap)
        assert(0 == filesArray.length)

        done()

    it "Folders only", (done) ->
        fs.mkdirSync("root")
        fs.mkdirSync("root/folder-1")
        fs.mkdirSync("root/folder-2")

        localFs = LocalFs.create("root")
        assert(null != localFs)

        dirsArray = util.mapToArray(localFs.dirsMap)
        assert(3 == dirsArray.length)

        assert("" == dirsArray[0].name)
        assert("root" == dirsArray[0].diskName)
        assert(2 == dirsArray[0].children)

        assert("folder-1" == dirsArray[1].name)
        assert("root/folder-1" == dirsArray[1].diskName)
        assert(0 == dirsArray[1].children)

        assert("folder-2" == dirsArray[2].name)
        assert("root/folder-2" == dirsArray[2].diskName)
        assert(0 == dirsArray[2].children)

        filesArray = util.mapToArray(localFs.filesMap)
        assert(0 == filesArray.length)

        done()

    it "Files only", (done) ->
        fs.mkdirSync("root")
        fs.writeFileSync("root/file-1", "")
        fs.writeFileSync("root/file-2", "")

        localFs = LocalFs.create("root")
        assert(null != localFs)

        dirsArray = util.mapToArray(localFs.dirsMap)
        assert(1 == dirsArray.length)
        assert("" == dirsArray[0].name)
        assert("root" == dirsArray[0].diskName)
        assert(2 == dirsArray[0].children)

        filesArray = util.mapToArray(localFs.filesMap)
        assert(2 == filesArray.length)

        assert("file-1" == filesArray[0].name)
        assert("root/file-1" == filesArray[0].diskName)

        assert("file-2" == filesArray[1].name)
        assert("root/file-2" == filesArray[1].diskName)

        done()

    it "Folder and file", (done) ->
        fs.mkdirSync("root")
        fs.mkdirSync("root/folder-1")
        fs.mkdirSync("root/folder-2")
        fs.writeFileSync("root/folder-1/file-1", "")
        fs.writeFileSync("root/file-2", "")

        localFs = LocalFs.create("root")
        assert(null != localFs)

        dirsArray = util.mapToArray(localFs.dirsMap)
        assert(3 == dirsArray.length)

        assert("" == dirsArray[0].name)
        assert("root" == dirsArray[0].diskName)
        assert(3 == dirsArray[0].children)

        assert("folder-1" == dirsArray[1].name)
        assert("root/folder-1" == dirsArray[1].diskName)
        assert(1 == dirsArray[1].children)

        assert("folder-2" == dirsArray[2].name)
        assert("root/folder-2" == dirsArray[2].diskName)
        assert(0 == dirsArray[2].children)

        filesArray = util.mapToArray(localFs.filesMap)
        assert(2 == filesArray.length)

        assert("file-2" == filesArray[0].name)
        assert("root/file-2" == filesArray[0].diskName)

        assert("folder-1/file-1" == filesArray[1].name)
        assert("root/folder-1/file-1" == filesArray[1].diskName)

        done()

describe "LocalFs::read()", () ->
    before util.clearRoot
    afterEach util.clearRoot

    it "Read exist file", (done) ->
        writeContent = "The content in the file."
        fs.mkdirSync("root")
        fs.writeFileSync("root/file", writeContent)

        localFs = LocalFs.create("root")
        assert(null != localFs)

        readContent = localFs.read("file", "utf8")
        assert(writeContent == readContent)
        done()

    it "Nonexist file", (done) ->
        fs.mkdirSync("root")

        localFs = LocalFs.create("root")
        assert(null != localFs)

        try
            readContent =  localFs.read("file-x")
        catch error
            done()
        throw util.shouldThrowError()

describe "LocalFs::write()", () ->
    before util.clearRoot
    afterEach util.clearRoot

    it "Nonexist File", (done) ->
        fs.mkdirSync("root")

        localFs = LocalFs.create("root")
        writeContent = "The content in the file."
        localFs.write("file", writeContent)

        dirsArray = util.mapToArray(localFs.dirsMap)
        assert(1 == dirsArray.length)
        assert(1 == dirsArray[0].children)

        filesArray = util.mapToArray(localFs.filesMap)
        assert(1 == filesArray.length)
        assert("file" == filesArray[0].name)
        assert("root/file" == filesArray[0].diskName)

        readContent = fs.readFileSync("root/file", "utf8")
        assert(writeContent == readContent)
        fs.unlinkSync("root/file")
        done()

    it "Exist file", (done) ->
        fs.mkdirSync("root")
        fs.writeFileSync("root/file", "Empty")

        localFs = LocalFs.create("root")
        writeContent = "The content in the file."
        localFs.write("file", writeContent)

        dirsArray = util.mapToArray(localFs.dirsMap)
        assert(1 == dirsArray.length)
        assert(1 == dirsArray[0].children)

        filesArray = util.mapToArray(localFs.filesMap)
        assert(1 == filesArray.length)
        assert("file" == filesArray[0].name)
        assert("root/file" == filesArray[0].diskName)

        readContent = fs.readFileSync("root/file", "utf8")
        assert(writeContent == readContent)
        fs.unlinkSync("root/file")
        done()

    it "Folder and file", (done) ->
        fs.mkdirSync("root")
        fs.mkdirSync("root/folder-1")

        localFs = LocalFs.create("root")
        writeContent = "The content in the file."
        localFs.write("folder-1/folder-2/file", writeContent)

        dirsArray = util.mapToArray(localFs.dirsMap)
        assert(3 == dirsArray.length)

        assert("" == dirsArray[0].name)
        assert("root" == dirsArray[0].diskName)
        assert(1 == dirsArray[0].children)

        assert("folder-1" == dirsArray[1].name)
        assert("root/folder-1" == dirsArray[1].diskName)
        assert(1 == dirsArray[1].children)

        assert("folder-1/folder-2" == dirsArray[2].name)
        assert("root/folder-1/folder-2" == dirsArray[2].diskName)
        assert(1 == dirsArray[2].children)

        filesArray = util.mapToArray(localFs.filesMap)
        assert(1 == filesArray.length)
        assert("folder-1/folder-2/file" == filesArray[0].name)
        assert("root/folder-1/folder-2/file" == filesArray[0].diskName)

        readContent = fs.readFileSync("root/folder-1/folder-2/file", "utf8")
        assert(writeContent == readContent)
        fs.unlinkSync("root/folder-1/folder-2/file")
        fs.rmdirSync("root/folder-1/folder-2")
        fs.rmdirSync("root/folder-1")
        done()

describe "LocalFs::delete", () ->
    before util.clearRoot
    afterEach util.clearRoot

    it "Folder and file", (done) ->
        fs.mkdirSync("root")
        fs.mkdirSync("root/folder-1")
        fs.mkdirSync("root/folder-1/folder-2")
        fs.writeFileSync("root/folder-1/folder-2/file", "......")
        fs.writeFileSync("root/folder-1/file-x", "......")

        localFs = LocalFs.create("root")
        localFs.delete("folder-1/folder-2/file")

        dirsArray = util.mapToArray(localFs.dirsMap)
        assert(2 == dirsArray.length)
        assert(1 == dirsArray[0].children)

        assert("folder-1" == dirsArray[1].name)
        assert("root/folder-1" == dirsArray[1].diskName)
        assert(1 == dirsArray[1].children)

        filesArray = util.mapToArray(localFs.filesMap)
        assert(1 == filesArray.length)
        assert("folder-1/file-x" == filesArray[0].name)
        assert("root/folder-1/file-x" == filesArray[0].diskName)
        done()

    it "Delete nonexist file", (done) ->
        fs.mkdirSync("root")
        try
            readContent =  localFs.delete("file-x")
        catch error
            done()
        throw util.shouldThrowError()
