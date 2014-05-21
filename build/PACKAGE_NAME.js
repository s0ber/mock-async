/*! PACKAGE_NAME (v0.1.0),
 DESCRIPTION,
 by AUTHOR_NAME <AUTHOR_EMAIL>
 Sun May 11 2014 */
(function() {
  var modules;

  modules = {};

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

}).call(this);

(function() {
  var MyClass;

  MyClass = (function() {
    function _Class() {
      this.property = true;
    }

    return _Class;

  })();

  modula["export"]('my_class', MyClass);

}).call(this);
