(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['apps/task_chains/index/index_controller', 'entities/task_chain'], function() {
    return this.Pro.module('TaskChainsApp', function(TaskChainsApp, App, Backbone, Marionette, $, _) {
      var API;
      TaskChainsApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        return Router;

      })(Marionette.AppRouter);
      API = {
        index: function(taskChains) {
          if (taskChains == null) {
            taskChains = App.request('new:task_chains:collection', gon.task_chains);
          }
          return new TaskChainsApp.Index.Controller({
            taskChains: taskChains,
            legacyChains: gon.legacy_chains
          });
        }
      };
      App.vent.on('index:task_chains', function(taskChains) {
        return API.show(taskChains);
      });
      App.addInitializer(function() {
        new TaskChainsApp.Router({
          controller: API
        });
        API.index();
        return this.module("TaskChainsApp").start();
      });
      return App.addRegions({
        mainRegion: "#task-chains-main-region"
      });
    });
  });

}).call(this);
