window.mockAsync = (object, methodName) ->
  new MockApi(object, methodName)

class PublicApi
  constructor: (@MockApi, @params = {}) ->

  whenCalledWith: (args...) =>
    new PublicApi(@MockApi, _.assign({}, @params, {args}))

  shouldSucceed: (value) =>
    params = _.assign({}, @params, {success: true, value})
    @MockApi._addCondition(params)
    @MockApi

  shouldFail: (value) =>
    params = _.assign({}, @params, {success: false, value})
    @MockApi._addCondition(params)
    @MockApi

  shouldReturn: (args...) => @shouldSucceed(args...)

class MockApi
  defaultParams:
    success: true

  constructor: (@object, @methodName) ->
    @callResults = {}

    ApiRoot = new PublicApi(@)
    @[name] = ApiRoot[name] for name, func of PublicApi::

    @_mockMehod()

  restore: ->
    @object[@methodName] = @prevMethodFn if @prevMethodFn

# private

  _addCondition: (params) ->
    @callResults[@_getUniqIdForArgs(params.args)] = params
    undefined

  _mockMehod: ->
    @prevMethodFn = @object[@methodName]
    @object[@methodName] = @_mockedMethod

  _mockedMethod: (args...) =>
    params = @callResults[@_getUniqIdForArgs(args)] || @callResults['default'] || @defaultParams
    result = if _.isFunction(params?.value) then params.value() else params?.value

    deferred = new $.Deferred()
    if params.success
      deferred.resolve(result)
    else
      deferred.reject(result)

  _getUniqIdForArgs: (args) ->
    return 'default' unless args && args.length > 0
    uniqId = ''
    for arg in args
      if _.isObject(arg)
        uniqId += JSON.stringify(arg)
      else if _.isString(arg)
        uniqId += arg

    uniqId

modula.export('mock_api', MockApi)
