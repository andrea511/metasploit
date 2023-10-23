(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Origin = (function(_super) {

        __extends(Origin, _super);

        function Origin() {
          return Origin.__super__.constructor.apply(this, arguments);
        }

        return Origin;

      })(App.Entities.Model);
      API = {
        getOrigin: function(id, url) {
          var origin;
          origin = new Entities.Origin({
            id: id
          });
          origin.url = url;
          return origin;
        },
        newOrigin: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.Origin(attributes);
        }
      };
      App.reqres.setHandler("origin:entity", function(id, url) {
        return API.getOrigin(id, url);
      });
      return App.reqres.setHandler("new:origin:entity", function(attributes) {
        return API.newOrigin(attributes);
      });
    });
  });

}).call(this);
