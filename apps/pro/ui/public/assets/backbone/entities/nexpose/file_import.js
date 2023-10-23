(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/input_generator'], function() {
    return this.Pro.module("Entities.Nexpose", function(Nexpose, App) {
      var API;
      Nexpose.FileImport = (function(_super) {

        __extends(FileImport, _super);

        function FileImport() {
          return FileImport.__super__.constructor.apply(this, arguments);
        }

        FileImport.include("InputGenerator");

        FileImport.prototype.urlRoot = function() {
          return Routes.start_import_path(WORKSPACE_ID);
        };

        FileImport.prototype.validateModel = function(opts) {
          var config;
          if (opts == null) {
            opts = {};
          }
          config = _.defaults(opts, {
            no_files: false,
            validate_file_path: true
          });
          opts = _.extend(opts, {
            url: Routes.validate_import_path(WORKSPACE_ID)
          });
          return this.save({
            no_files: config.no_files,
            validate_file_path: config.validate_file_path
          }, opts);
        };

        return FileImport;

      })(App.Entities.Model);
      API = {
        getFileImport: function(opts) {
          if (opts == null) {
            opts = {};
          }
          return new Nexpose.FileImport(opts);
        }
      };
      return App.reqres.setHandler("nexpose:fileImport:entity", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getFileImport(opts);
      });
    });
  });

}).call(this);
