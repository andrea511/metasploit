(function() {

  define([], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      return Concerns.InputGenerator = {
        generateInputs: function() {
          var $inputs, obj, prefix;
          $inputs = $('<form></form>');
          obj = this.toJSON();
          prefix = "";
          this.recurseInputs($inputs, obj, prefix, true);
          return $inputs;
        },
        recurseInputs: function($inputs, obj, prefix, firstTime) {
          var _this = this;
          if (typeof obj !== 'object') {
            return $inputs.append("<input name='" + prefix + "' value='" + obj + "' type='hidden'>");
          } else {
            return _.each(obj, function(value, key, obj) {
              var arrayPrefix, elem, i, prefixedKey, _i, _len, _results;
              prefixedKey = firstTime ? "" + key : "" + prefix + "[" + key + "]";
              if (typeof value === 'object') {
                if (Array.isArray(value)) {
                  _results = [];
                  for (i = _i = 0, _len = value.length; _i < _len; i = ++_i) {
                    elem = value[i];
                    arrayPrefix = firstTime ? "" + key + "[]" : "[" + key + "][]";
                    _results.push(_this.recurseInputs($inputs, elem, arrayPrefix, false));
                  }
                  return _results;
                } else {
                  return _this.recurseInputs($inputs, value, prefixedKey, false);
                }
              } else {
                return $inputs.append("<input name='" + prefixedKey + "' value='" + value + "' type='hidden'>");
              }
            });
          }
        }
      };
    });
  });

}).call(this);
