(function() {

  Teaspoon.Runner = (function() {

    Runner.run = false;

    function Runner() {
      if (this.constructor.run) {
        return;
      }
      this.constructor.run = true;
      this.fixturePath = "" + Teaspoon.root + "/fixtures";
      this.params = Teaspoon.params = this.getParams();
      this.setup();
    }

    Runner.prototype.getParams = function() {
      var name, param, params, value, _i, _len, _ref, _ref1;
      params = {};
      _ref = Teaspoon.location.search.substring(1).split("&");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        param = _ref[_i];
        _ref1 = param.split("="), name = _ref1[0], value = _ref1[1];
        params[decodeURIComponent(name)] = decodeURIComponent(value);
      }
      return params;
    };

    Runner.prototype.getReporter = function() {
      if (this.params["reporter"]) {
        return this.findReporter(this.params["reporter"]);
      } else {
        if (window.navigator.userAgent.match(/PhantomJS/)) {
          return this.findReporter("Console");
        } else {
          return this.findReporter("HTML");
        }
      }
    };

    Runner.prototype.setup = function() {};

    Runner.prototype.findReporter = function(type) {
      return Teaspoon.resolveClass("Reporters." + type);
    };

    return Runner;

  })();

}).call(this);
