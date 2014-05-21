MockApi = modula.require 'mock_api'

describe 'MockApi', ->
  beforeEach ->
    @sourceMethod = $.getJSON
    @mockedMethodApi = new MockApi($, 'getJSON')

  afterEach ->
    @mockedMethodApi.restore()

  it 'mocks source method', ->
    expect($.getJSON).to.not.be.equal @sourceMethod

  it "returns deferred object on mocked method's call", ->
    expect($.getJSON()).to.have.property 'promise'

  it 'resolves deferred object state on call automatically', ->
    isResolved = false
    $.getJSON().done -> isResolved = true
    expect(isResolved).to.be.true

  describe 'MockApi#shouldReturn', ->
    it 'makes mocked method to return specified value on resolving (when called)', ->
      @mockedMethodApi.shouldReturn 'ololo'
      $.getJSON().done (result) ->
        expect(result).to.be.eql 'ololo'

    it 'makes mocked method to return callback result on resolving if callback provided', ->
      @mockedMethodApi.shouldReturn -> 'ololo'
      $.getJSON().done (result) ->
        expect(result).to.be.eql 'ololo'

  describe 'MockApi#whenCalledWith', ->
    it 'makes mocked method to return specified value when called with specified string argument', ->
      @mockedMethodApi.shouldReturn 'ololo'
      @mockedMethodApi.whenCalledWith('custom_path').shouldReturn 'pish-pish'
      @mockedMethodApi.whenCalledWith('another_custom_path').shouldReturn 'hmm'

      $.getJSON().done (result) ->
        expect(result).to.be.eql 'ololo'

      $.getJSON('custom_path').done (result) ->
        expect(result).to.be.eql 'pish-pish'

      $.getJSON('another_custom_path').done (result) ->
        expect(result).to.be.eql 'hmm'

      $.getJSON('unmocked_custom_path').done (result) ->
        expect(result).to.be.eql 'ololo'

    it 'makes mocked method to return callback result when called with specified string argument if callback is provided', ->
      @mockedMethodApi.whenCalledWith('custom_path').shouldReturn -> 'pish-pish'
      $.getJSON('custom_path').done (result) ->
        expect(result).to.be.eql 'pish-pish'

    it 'makes mocked method to return specified value when called with specified set of arguments', ->
      @mockedMethodApi.shouldReturn 'ololo'
      @mockedMethodApi.whenCalledWith('custom_path', a: 1).shouldReturn 'pish-pish'
      @mockedMethodApi.whenCalledWith('another_custom_path', a: 2).shouldReturn 'hmm'
      @mockedMethodApi.whenCalledWith('another_custom_path', a: 1, b: 2).shouldReturn 'another string'

      $.getJSON('custom_path', a: 1).done (result) ->
        expect(result).to.be.eql 'pish-pish'

      $.getJSON('another_custom_path', a: 2).done (result) ->
        expect(result).to.be.eql 'hmm'

      $.getJSON('another_custom_path', a: 1, b: 2).done (result) ->
        expect(result).to.be.eql 'another string'

  describe 'MockApi#restore', ->
    it 'restores mocked method', ->
      @mockedMethodApi.restore()
      expect($.getJSON).to.be.equal @sourceMethod
