/*! mock-async (v0.1.1),
 Simple one-method library for mocking asynchronous methods,
 by Sergey Shishkalov <sergeyshishkalov@gmail.com>
 Wed May 21 2014 */
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
  var MockApi,
    __slice = [].slice;

  window.mockAsync = function(object, methodName) {
    return new MockApi(object, methodName);
  };

  MockApi = (function() {
    function _Class(object, methodName) {
      this.object = object;
      this.methodName = methodName;
      this.prevMethodFn = this.object[this.methodName];
      this.defaultCallResult = null;
      this.callResultsForArgs = {};
      this._mockMehod();
    }

    _Class.prototype.shouldReturn = function(callbackOrValue) {
      if (_.isFunction(callbackOrValue)) {
        return this.defaultCallResult = callbackOrValue();
      } else {
        return this.defaultCallResult = callbackOrValue;
      }
    };

    _Class.prototype.whenCalledWith = function() {
      var args, uniqId;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      uniqId = this._getUniqIdForArgs(args);
      return {
        shouldReturn: (function(_this) {
          return function(callbackOrValue) {
            if (_.isFunction(callbackOrValue)) {
              return _this.callResultsForArgs[uniqId] = callbackOrValue();
            } else {
              return _this.callResultsForArgs[uniqId] = callbackOrValue;
            }
          };
        })(this)
      };
    };

    _Class.prototype.restore = function() {
      return this.object[this.methodName] = this.prevMethodFn;
    };

    _Class.prototype._mockMehod = function() {
      return this.object[this.methodName] = _.bind(this._mockedMethod, this);
    };

    _Class.prototype._mockedMethod = function() {
      var args, callResult, deferred;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      callResult = args.length > 0 ? this.callResultsForArgs[this._getUniqIdForArgs(args)] || this.defaultCallResult : this.defaultCallResult;
      deferred = new $.Deferred();
      return deferred.resolve(callResult);
    };

    _Class.prototype._getUniqIdForArgs = function(args) {
      var arg, uniqId, _i, _len;
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

    return _Class;

  })();

  modula["export"]('mock_api', MockApi);

}).call(this);
