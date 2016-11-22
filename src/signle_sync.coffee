# # # # # # # # # # # # # # # # # # # #
# signle_sync.coffee
# # # # # # # # # # # # # # # # # # # #

{LocalFs} = require("./local_fs.coffee")
{RemoteFs} = require("./remote_fs.coffee")

signleSync = (sshOptions, remotePath, localFs) ->
    $remoteFs = null
    $uplandArray = []
    RemoteFs.create(sshOptions, remotePath)
    .then (remoteFs) ->
        $remoteFs = remoteFs
        localFs.forEach (localInfo) ->
            remoteInfo = $remoteFs.find(localInfo.name)
            if not remoteInfo
                $uplandArray.push(localInfo.name)
            else if localInfo.mtime >= remoteInfo.mtime
                $uplandArray.push(localInfo.name)
    .then readFunc = () ->
        fileName = $uplandArray.shift()
        if fileName
            console.log("Uplanding file : #{fileName}")
            return $remoteFs.upland(fileName).then(readFunc)
    .catch (error) ->
        if error
            console.log(error)

localFs = LocalFs.create("./root")
signleSync({
    host: 'fenqi.io'
    port: 22,
    username: 'nanuno',
    password: "jbcnmb8888"
}, "/home/nanuno/root/", localFs)
