/*! mock-async (v0.1.2),
 Simple one-method library for mocking asynchronous methods,
 by Sergey Shishkalov <sergeyshishkalov@gmail.com>, Alex Chrome <dify.chrome@gmail.com>
 Wed Dec 23 2015 */
(function() {
  var modules;

  modules = {};

  if (window.modula == null) {
    window.modula = {
      "export": function(name, exports) {
        return modules[name] = exports;
      },
      require: function(name) {
        var Module;
        Module = modules[name];
        if (Module) {
          return Module;
        } else {
          throw "Module '" + name + "' not found.";
        }
      }
    };
  }

}).call(this);

(function() {
  var MockApi, PublicApi,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  window.mockAsync = function(object, methodName) {
    return new MockApi(object, methodName);
  };

  PublicApi = (function() {
    function PublicApi(MockApi, params) {
      this.MockApi = MockApi;
      this.params = params != null ? params : {};
      this.shouldReturn = __bind(this.shouldReturn, this);
      this.shouldFail = __bind(this.shouldFail, this);
      this.shouldSucceed = __bind(this.shouldSucceed, this);
      this.whenCalledWith = __bind(this.whenCalledWith, this);
    }

    PublicApi.prototype.whenCalledWith = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return new PublicApi(this.MockApi, _.assign({}, this.params, {
        args: args
      }));
    };

    PublicApi.prototype.shouldSucceed = function(value) {
      var params;
      params = _.assign({}, this.params, {
        success: true,
        value: value
      });
      this.MockApi._addCondition(params);
      return this.MockApi;
    };

    PublicApi.prototype.shouldFail = function(value) {
      var params;
      params = _.assign({}, this.params, {
        success: false,
        value: value
      });
      this.MockApi._addCondition(params);
      return this.MockApi;
    };

    PublicApi.prototype.shouldReturn = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return this.shouldSucceed.apply(this, args);
    };

    return PublicApi;

  })();

  MockApi = (function() {
    MockApi.prototype.defaultParams = {
      success: true
    };

    function MockApi(object, methodName) {
      var ApiRoot, func, name, _ref;
      this.object = object;
      this.methodName = methodName;
      this._mockedMethod = __bind(this._mockedMethod, this);
      this.callResults = {};
      ApiRoot = new PublicApi(this);
      _ref = PublicApi.prototype;
      for (name in _ref) {
        func = _ref[name];
        this[name] = ApiRoot[name];
      }
      this._mockMehod();
    }

    MockApi.prototype.restore = function() {
      if (this.prevMethodFn) {
        return this.object[this.methodName] = this.prevMethodFn;
      }
    };

    MockApi.prototype._addCondition = function(params) {
      this.callResults[this._getUniqIdForArgs(params.args)] = params;
      return void 0;
    };

    MockApi.prototype._mockMehod = function() {
      this.prevMethodFn = this.object[this.methodName];
      return this.object[this.methodName] = this._mockedMethod;
    };

    MockApi.prototype._mockedMethod = function() {
      var args, deferred, params, result;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      params = this.callResults[this._getUniqIdForArgs(args)] || this.callResults['default'] || this.defaultParams;
      result = _.isFunction(params != null ? params.value : void 0) ? params.value() : params != null ? params.value : void 0;
      deferred = new $.Deferred();
      if (params.success) {
        return deferred.resolve(result);
      } else {
        return deferred.reject(result);
      }
    };

    MockApi.prototype._getUniqIdForArgs = function(args) {
      var arg, uniqId, _i, _len;
      if (!(args && args.length > 0)) {
        return 'default';
      }
      uniqId = '';
      for (_i = 0, _len = args.length; _i < _len; _i++) {
        arg = args[_i];
        if (_.isObject(arg)) {
          uniqId += JSON.stringify(arg);
        } else if (_.isString(arg)) {
          uniqId += arg;
        }
      }
      return uniqId;
    };

    return MockApi;

  })();

  modula["export"]('mock_api', MockApi);

}).call(this);
