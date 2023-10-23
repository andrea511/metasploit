(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities.Nexpose", function(Nexpose, App) {
      var API;
      Nexpose.Import = (function(_super) {

        __extends(Import, _super);

        function Import() {
          return Import.__super__.constructor.apply(this, arguments);
        }

        Import.prototype.url = '/nexpose_consoles.json';

        return Import;

      })(App.Entities.Model);
      API = {
        newImport: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Nexpose.Import(attributes);
        }
      };
      return App.reqres.setHandler("new:nexpose:import:entity", function(attributes) {
        return API.newImport(attributes);
      });
    });
  });

}).call(this);
