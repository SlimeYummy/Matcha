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

promise = (promiseFunc) ->
    return new Promise(promiseFunc)

exports.coroutine = coroutine
exports.promise = promise



###
###

func = (num) ->
    console.log num
    num = yield promise (resolve, reject) ->
        setImmediate () ->
            resolve(4)
    console.log num
    num = yield promise (resolve, reject) ->
        setImmediate () ->
            resolve(5)
    console.log num
    return 6

coroutine func, 3
.then (resNum) ->
    console.log resNum
.catch (error) ->
    console.log error
