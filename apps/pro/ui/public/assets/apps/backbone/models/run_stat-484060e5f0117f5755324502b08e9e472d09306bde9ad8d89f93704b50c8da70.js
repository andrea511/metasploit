(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var RunStat;
    return RunStat = (function(_super) {

      __extends(RunStat, _super);

      function RunStat() {
        return RunStat.__super__.constructor.apply(this, arguments);
      }

      RunStat.prototype.defaults = {
        name: '',
        data: 0
      };

      return RunStat;

    })(Backbone.Model);
  });

}).call(this);
