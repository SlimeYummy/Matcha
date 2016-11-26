# # # # # # # # # # # # # # # # # # # #
# signle_sync.coffee
# # # # # # # # # # # # # # # # # # # #

{LocalFs} = require("./local_fs.coffee")
{RemoteFs} = require("./remote_fs.coffee")

signleSync = (sshOptions, remoteRoot, localRoot) ->
    remoteFs = null
    return coroutine () ->
        # create local file system
        try
            localFs = LocalFs.create(localRoot)
            console.log("Local file system OK: #{localRoot}")
        catch error
            console.log("Local file system ERR: #{localRoot}")
            console.log(error)
            return
        # create remote file system
        try
            remoteFs = yield RemoteFs.create(sshOptions, remoteRoot)
            console.log("Remote file system OK: #{localRoot}")
        catch error
            console.log("Remote file system ERR: #{localRoot}")
            console.log(error)
            return
        # upland files
        uplandArray = []
        for _, localInfo of localFs.filesMap
            remoteInfo = remoteFs.filesMap[localInfo.name]
            if not remoteInfo or localInfo.mtime >= remoteInfo.mtime
                try
                    yield remoteFs.upland(remoteInfo.name, localInfo.diskName)
                    console.log("Upland OK: #{localInfo.name}")
                catch error
                    console.log("Upland ERR: #{localInfo.name}")
                    console.log(error)
        # delete files
        for _, remoteInfo of remoteFs.filesMap
            if not localFs.filesMap[remoteInfo.name]
                try
                    yield remoteFs.delete(remoteInfo.name)
                    console.log("Delete OK: #{localInfo.name}")
                catch error
                    console.log("Delete ERR: #{localInfo.name}")
                    console.log(error)
        return
    .finally () ->
        RemoteFs.destory(remoteFs)
        console.log("Signle Sync Finish.")
        return

signleSync({
    host: 'fenqi.io'
    port: 22,
    username: 'nanuno',
    password: "jbcnmb8888"
}, "/home/nanuno/root/", "./root")
