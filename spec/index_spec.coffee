MockApi = modula.require 'mock_api'

describe 'MockApi', ->
  beforeEach ->
    @sourceMethod = $.getJSON
    @mockedMethodApi = new MockApi($, 'getJSON')
    @spy = sinon.spy()

  afterEach ->
    @mockedMethodApi.restore()
    @spy.reset()

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
      $.getJSON().done @spy
      expect(@spy).to.be.calledWith 'ololo'

    it 'makes mocked method to return callback result on resolving if callback provided', ->
      @mockedMethodApi.shouldReturn -> 'ololo'
      $.getJSON().done @spy
      expect(@spy).to.be.calledWith 'ololo'

  describe 'MockApi#shouldSucceed', ->
    it 'makes mocked method to return specified value on resolving (when called)', ->
      @mockedMethodApi.shouldSucceed 'ololo'
      $.getJSON().done @spy
      expect(@spy).to.be.calledWith 'ololo'

    it 'makes mocked method to return callback result on resolving if callback provided', ->
      @mockedMethodApi.shouldSucceed -> 'ololo'
      $.getJSON().done @spy
      expect(@spy).to.be.calledWith 'ololo'

  describe 'MockApi#shouldFail', ->
    it 'makes mocked method to return specified value on rejecting (when called)', ->
      @mockedMethodApi.shouldFail 'ololo'
      $.getJSON().fail @spy
      expect(@spy).to.be.calledWith 'ololo'

    it 'makes mocked method to return callback result on rejecting if callback provided', ->
      @mockedMethodApi.shouldFail -> 'ololo'
      $.getJSON().fail @spy
      expect(@spy).to.be.calledWith 'ololo'

  describe 'MockApi#whenCalledWith', ->
    it 'makes mocked method to return specified value when called with specified string argument', ->
      @mockedMethodApi
        .shouldReturn 'ololo'
        .whenCalledWith('custom_path').shouldReturn 'pish-pish'
        .whenCalledWith('another_custom_path').shouldReturn 'hmm'

      $.getJSON().done @spy
      expect(@spy).to.be.calledWith 'ololo'

      $.getJSON('custom_path').done @spy
      expect(@spy).to.be.calledWith 'pish-pish'

      $.getJSON('another_custom_path').done @spy
      expect(@spy).to.be.calledWith 'hmm'

      $.getJSON('unmocked_custom_path').done @spy
      expect(@spy).to.be.calledWith 'ololo'

    it 'makes mocked method to return callback result when called with specified string argument if callback is provided', ->
      @mockedMethodApi.whenCalledWith('custom_path').shouldReturn -> 'pish-pish'
      $.getJSON('custom_path').done @spy
      expect(@spy).to.be.calledWith 'pish-pish'

    it 'makes mocked method to return specified value when called with specified set of arguments', ->
      @mockedMethodApi
        .shouldReturn 'ololo'
        .whenCalledWith('custom_path', a: 1).shouldReturn 'pish-pish'
        .whenCalledWith('another_custom_path', a: 2).shouldReturn 'hmm'
        .whenCalledWith('another_custom_path', a: 1, b: 2).shouldReturn 'another string'

      $.getJSON('custom_path', a: 1).done @spy
      expect(@spy).to.be.calledWith 'pish-pish'

      $.getJSON('another_custom_path', a: 2).done @spy
      expect(@spy).to.be.calledWith 'hmm'

      $.getJSON('another_custom_path', a: 1, b: 2).done @spy
      expect(@spy).to.be.calledWith 'another string'

  describe 'MockApi#restore', ->
    it 'restores mocked method', ->
      @mockedMethodApi.restore()
      expect($.getJSON).to.be.equal @sourceMethod
