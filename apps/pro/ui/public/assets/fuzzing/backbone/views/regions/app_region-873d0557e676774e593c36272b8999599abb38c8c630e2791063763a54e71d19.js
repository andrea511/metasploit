(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var AppRegion;
    return AppRegion = (function(_super) {

      __extends(AppRegion, _super);

      function AppRegion() {
        return AppRegion.__super__.constructor.apply(this, arguments);
      }

      AppRegion.prototype.el = "#fuzzing-app-container";

      return AppRegion;

    })(Backbone.Marionette.Region);
  });

}).call(this);
