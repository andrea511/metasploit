(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_model', 'base_collection'], function($) {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.ModuleDetail = (function(_super) {

        __extends(ModuleDetail, _super);

        function ModuleDetail() {
          this.url = __bind(this.url, this);
          return ModuleDetail.__super__.constructor.apply(this, arguments);
        }

        ModuleDetail.prototype.refsOnly = false;

        ModuleDetail.prototype.defaults = {
          workspace_id: WORKSPACE_ID,
          refsOnly: ModuleDetail.refsOnly
        };

        ModuleDetail.prototype.url = function() {
          return Routes.workspace_module_detail_path(this.get('workspace_id'), this.get('id'));
        };

        return ModuleDetail;

      })(App.Entities.Model);
      API = {
        getModuleDetail: function(opts) {
          var moduleDetail;
          moduleDetail = new Entities.ModuleDetail(opts);
          return moduleDetail;
        }
      };
      return App.reqres.setHandler("module:detail:entity", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getModuleDetail(opts);
      });
    });
  });

}).call(this);
