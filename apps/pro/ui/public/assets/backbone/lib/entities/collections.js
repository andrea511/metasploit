(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      return Entities.Collection = (function(_super) {

        __extends(Collection, _super);

        function Collection() {
          return Collection.__super__.constructor.apply(this, arguments);
        }

        return Collection;

      })(Backbone.Collection);
    });
  });

}).call(this);
