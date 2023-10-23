(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/input_generator'], function() {
    return this.Pro.module("Entities.Nexpose", function(Nexpose, App) {
      var API;
      Nexpose.ScanAndImport = (function(_super) {

        __extends(ScanAndImport, _super);

        function ScanAndImport() {
          return ScanAndImport.__super__.constructor.apply(this, arguments);
        }

        ScanAndImport.include("InputGenerator");

        ScanAndImport.prototype.urlRoot = function() {
          return Routes.start_scan_and_import_path(WORKSPACE_ID);
        };

        ScanAndImport.prototype.validateModel = function(opts) {
          opts = _.extend(opts, {
            url: Routes.validate_scan_and_import_path(WORKSPACE_ID)
          });
          return this.save({}, opts);
        };

        ScanAndImport.prototype.isScanAndImport = function() {
          return !(this.get('sites') != null);
        };

        ScanAndImport.prototype.isSiteImport = function() {
          return this.get('sites') != null;
        };

        return ScanAndImport;

      })(App.Entities.Model);
      API = {
        getScanAndImport: function(opts) {
          if (opts == null) {
            opts = {};
          }
          return new Nexpose.ScanAndImport(opts);
        }
      };
      return App.reqres.setHandler("nexpose:scanAndImport:entity", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getScanAndImport(opts);
      });
    });
  });

}).call(this);
