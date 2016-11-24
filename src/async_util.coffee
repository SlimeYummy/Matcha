# # # # # # # # # # # # # # # # # # # #
# async_util.coffee
# # # # # # # # # # # # # # # # # # # #

coroutine = (generator, argument) ->
    if "function" != typeof generator
        throw new Error("Type Error: Not A Generator.")
    pointer = generator(argument)
    if "function" != typeof pointer.next
        throw new Error("Type Error: Not A Generator.")
    if "function" != typeof pointer.throw
        throw new Error("Type Error: Not A Generator.")

    wrapPromise = (resolve, reject) ->
        whenReslove = (proResult) ->
            try
                genResult = pointer.next(proResult)
            catch error
                return reject(error)
            callNext(genResult)
            return

        whenReject = (error) ->
            try
                genResult = pointer.throw(error)
            catch error
                return reject(error)
            callNext(genResult)
            return

        callNext = (genResult) ->
            if genResult.done
                return resolve(genResult.value)
            genPromise = genResult.value
            if "function" != typeof genPromise.then
                return whenReject(new Error("Type Error: Not A Promise."))
            genPromise.then(whenReslove, whenReject)

        whenReslove()
        return

    return new Promise(wrapPromise)

exports.coroutine = coroutine



###
func1 = (num) ->
    console.log num
    num = yield new Promise (resolve, reject) ->
        setImmediate () ->
            resolve(4)
    console.log num
    num = yield new Promise (resolve, reject) ->
        setImmediate () ->
            resolve(5)
    console.log num
    return 6
coroutine func1, 3
.then (resNum) ->
    console.log resNum
.catch (error) ->
    console.log error

func2 = () ->
    try
        yield () ->
    catch e
        console.log "#{e.message}"
coroutine func2
.catch (error) ->
    console.log error

func3 = () ->
    throw new Error("In Gemerator.")
    yield new Promise () ->
        return
coroutine func3
.catch (error) ->
    console.log "#{error.message}"

func4 = () ->
    try
        yield new Promise () ->
            throw new Error("In Promise.")
    catch error
        console.log "#{error.message}"
coroutine func4
###
