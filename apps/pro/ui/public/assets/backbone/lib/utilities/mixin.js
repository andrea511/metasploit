(function() {
  var __slice = [].slice;

  this.Pro.module("Utilities", function(Utilities, App) {
    var include, key, klass, klasses, mixinKeywords, module, modules, obj, _i, _len, _results;
    mixinKeywords = ["beforeIncluded", "afterIncluded"];
    include = function() {
      var concern, klass, obj, objs, _i, _len, _ref, _ref1, _ref2;
      objs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      klass = this;
      for (_i = 0, _len = objs.length; _i < _len; _i++) {
        obj = objs[_i];
        concern = App.request("concern", obj);
        if ((_ref = concern.beforeIncluded) != null) {
          _ref.call(klass.prototype, klass, concern);
        }
        Cocktail.mixin(klass, (_ref1 = _(concern)).omit.apply(_ref1, mixinKeywords));
        if ((_ref2 = concern.afterIncluded) != null) {
          _ref2.call(klass.prototype, klass, concern);
        }
      }
      return klass;
    };
    modules = [
      {
        Backbone: ["Collection", "Model", "View"]
      }, {
        Marionette: ["ItemView", "LayoutView", "CollectionView", "CompositeView", "Controller"]
      }
    ];
    _results = [];
    for (_i = 0, _len = modules.length; _i < _len; _i++) {
      module = modules[_i];
      _results.push((function() {
        var _results1;
        _results1 = [];
        for (key in module) {
          klasses = module[key];
          _results1.push((function() {
            var _j, _len1, _results2;
            _results2 = [];
            for (_j = 0, _len1 = klasses.length; _j < _len1; _j++) {
              klass = klasses[_j];
              obj = window[key] || App[key];
              _results2.push(obj[klass].include = include);
            }
            return _results2;
          })());
        }
        return _results1;
      })());
    }
    return _results;
  });

}).call(this);
