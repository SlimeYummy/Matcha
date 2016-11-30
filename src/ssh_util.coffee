# # # # # # # # # # # # # # # # # # # #
# remote_fs.coffee
# # # # # # # # # # # # # # # # # # # #

exports.createSshLink = (options) ->
    return new Promise (resolve, reject) ->
        sshClient = new ssh.Client()
        sshClient.connect(options)
        sshClient.on "error", (error) ->
            return reject(error)
        sshClient.on "ready", () ->
            return resolve(sshClient)

exports.sshExec = (sshClient, command) ->
    return new Promise (resolve, reject) ->
        stdOut = ""
        stdErr = ""
        sshClient.exec command, (error, stream) ->
            if error
                return reject(error)
            stream.on "close", (code, signal) ->
                return resolve({code, signal})
            stream.on "data", (data) ->
                stdOut = stdOut + data
            stream.stderr.on "data", (data) ->
                stdOut = stdErr + data

exports.createSftpLink = (sshClient, options) ->
    return new Promise (resolve, reject) ->
        sshClient.sftp (error, sftpClient) ->
        if error
            return reject(error)
        return resolve(sftpClient)

exports.sftpUpland = (sftpClient, remotePath, localPath) ->
    return new Promise (resolve, reject) ->
        sftpClient.fastGet remotePath, localPath, (error) ->
        if error
            return reject(error)
        return resolve()

exports.sftpDownland = (sftpClient, remotePath, localPath) ->
    return new Promise (resolve, reject) ->
        sftpClient.fastPut remotePath, localPath, (error) ->
        if error
            return reject(error)
        return resolve()

exports.sftpUnlink = (sftpClient, remotePath) ->
    return new Promise (resolve, reject) ->
        sftpClient.unlink remotePath, (error) ->
        if error
            return reject(error)
        return resolve()

exports.sftpReaddir = (sftpClient, remotePath) ->
    return new Promise (resolve, reject) ->
        sftpClient.readdir remotePath, (error) ->
        if error
            return reject(error)
        return resolve(infosArray)

exports.sftpMkdir = (sftpClient, remotePath) ->
    return new Promise (resolve, reject) ->
        sftpClient.mkdir remotePath, (error) ->
        if error
            return reject(error)
        return resolve()

exports.sftpRmdir = (sftpClient, remotePath) ->
    return new Promise (resolve, reject) ->
        sftpClient.rmdir remotePath, (error) ->
        if error
            return reject(error)
        return resolve()
