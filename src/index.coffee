window.mockAsync = (object, methodName) ->
  new MockApi(object, methodName)

MockApi = class

  constructor: (@object, @methodName) ->
    @prevMethodFn = @object[@methodName]
    @defaultCallResult = null
    @callResultsForArgs = {}

    @_mockMehod()

  shouldReturn: (callbackOrValue) ->
    if _.isFunction(callbackOrValue)
      @defaultCallResult = callbackOrValue()
    else
      @defaultCallResult = callbackOrValue

  whenCalledWith: (args...) ->
    uniqId = @_getUniqIdForArgs(args)

    shouldReturn: (callbackOrValue) =>
      if _.isFunction(callbackOrValue)
        @callResultsForArgs[uniqId] = callbackOrValue()
      else
        @callResultsForArgs[uniqId] = callbackOrValue

  restore: ->
    @object[@methodName] = @prevMethodFn

# private

  _mockMehod: ->
    @object[@methodName] = _.bind(@_mockedMethod, @)

  _mockedMethod: (args...) ->
    callResult =
      if args.length > 0
        @callResultsForArgs[@_getUniqIdForArgs(args)] || @defaultCallResult
      else
        @defaultCallResult

    deferred = new $.Deferred()
    deferred.resolve(callResult)

  _getUniqIdForArgs: (args) ->
    uniqId = ''
    for arg in args
      if _.isObject(arg)
        uniqId += JSON.stringify(arg)
      else if _.isString(arg)
        uniqId += arg

    uniqId

modula.export('mock_api', MockApi)
