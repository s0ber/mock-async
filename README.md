Mock Async
=====
[![Build Status](https://travis-ci.org/s0ber/mock-async.png?branch=master)](https://travis-ci.org/s0ber/mock-async)

## How to use

Just mock an asynchronous method with this simple function.

```coffeescript
@getJSON = mockAsync($, 'getJSON')
```

The first argument here is an object, and the second one is method name. Mocked method API will be returned. Here we've saved reference to it with ```getJSON``` variable.

## Mock API

Than we can make our mocked method to do what we want from it to do.

### MockApi.shouldReturn(callback or value)

Makes mocked method to return specified result by default.

```coffeescript
@getJSON = mockAsync($, 'getJSON')

@getJSON.shouldReturn '5'
$.getJSON().done (result) ->
  console.log result # => 5
```

You can provide callback, so, result will be calculated, based on callback's returned value.

```coffeescript
a = 5, b = 3
@getJSON = mockAsync($, 'getJSON')

@getJSON.shouldReturn -> a + b
$.getJSON().done (result) ->
  console.log result # => 8
```

### MockApi.whenCalledWith(arguments...).shouldReturn(callback or value)

You can make mocked method to return different results based on provided to this method arguments.

```coffeescript
@getJSON = mockAsync($, 'getJSON')

@getJSON.whenCalledWith(location.pathname).shouldReturn
  html: '<div class="page1"></div>'

@getJSON.whenCalledWith(location.pathname, page: 1).shouldReturn
  html: '<div class="page1"></div>'

@getJSON.whenCalledWith(location.pathname, page: 2).shouldReturn
  html: '<div class="page2"></div>'

$.getJSON(location.pathname, page: 1).done (result) ->
  console.log result.html # => '<div class="page1"></div>'

$.getJSON(location.pathname, page: 2).done (result) ->
  console.log result.html # => '<div class="page2"></div>'
```


### MockApi.restore()

Restores mocked method.

```coffeescript
initialMethod = $.getJSON
@getJSON = mockAsync($, 'getJSON')
$.getJSON is initialMehod # => false
@getJSON.restore()
$.getJSON is initialMethod # => true

```
