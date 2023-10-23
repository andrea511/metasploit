(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_model', 'base_collection'], function($) {
    return this.Pro.module("Entities", function(Entities, App, Backbone, Marionette, jQuery, _) {
      var API;
      Entities.TaskChain = (function(_super) {

        __extends(TaskChain, _super);

        function TaskChain() {
          return TaskChain.__super__.constructor.apply(this, arguments);
        }

        TaskChain.prototype.urlRoot = gon.workspace_task_chains_path;

        return TaskChain;

      })(App.Entities.Model);
      Entities.TaskChainCollection = (function(_super) {

        __extends(TaskChainCollection, _super);

        function TaskChainCollection() {
          return TaskChainCollection.__super__.constructor.apply(this, arguments);
        }

        TaskChainCollection.prototype.model = Entities.TaskChain;

        TaskChainCollection.prototype.url = gon.workspace_task_chains_path;

        TaskChainCollection.prototype.sortAttribute = "name";

        TaskChainCollection.prototype.sortDirection = 1;

        TaskChainCollection.prototype.sortRows = function(attr) {
          this.sortAttribute = attr;
          return this.sort();
        };

        TaskChainCollection.prototype.comparator = function(a, b) {
          var _ref, _ref1;
          a = a.get(this.sortAttribute);
          b = b.get(this.sortAttribute);
          if (a === b) {
            return 0;
          }
          if (this.sortDirection === 1) {
            return (_ref = a > b) != null ? _ref : {
              1: -1
            };
          } else {
            return (_ref1 = a < b) != null ? _ref1 : {
              1: -1
            };
          }
        };

        TaskChainCollection.prototype.selected = function() {
          return this.where({
            selected: true
          });
        };

        TaskChainCollection.prototype.destroySelected = function() {
          var selectedTaskChainIDs,
            _this = this;
          selectedTaskChainIDs = this.selected().pluck('id');
          _.each(this.selected(), function(taskChain) {
            return _this.remove(taskChain);
          });
          return $.ajax({
            url: gon.destroy_multiple_workspace_task_chains_path,
            type: 'DELETE',
            data: {
              task_chain_ids: selectedTaskChainIDs
            }
          });
        };

        TaskChainCollection.prototype.stopSelected = function() {
          var selectedTaskChainIDs,
            _this = this;
          selectedTaskChainIDs = this.selected().pluck('id');
          return $.ajax({
            url: gon.stop_multiple_workspace_task_chains_path,
            type: 'POST',
            data: {
              task_chain_ids: selectedTaskChainIDs
            },
            success: function(data) {
              return _this.reset(data);
            }
          });
        };

        TaskChainCollection.prototype.suspendSelected = function() {
          var selectedTaskChainIDs,
            _this = this;
          selectedTaskChainIDs = this.selected().pluck('id');
          return $.ajax({
            url: gon.suspend_multiple_workspace_task_chains_path,
            type: 'POST',
            data: {
              task_chain_ids: selectedTaskChainIDs
            },
            success: function(data) {
              return _this.reset(data);
            }
          });
        };

        TaskChainCollection.prototype.resumeSelected = function() {
          var selectedTaskChainIDs,
            _this = this;
          selectedTaskChainIDs = this.selected().pluck('id');
          return $.ajax({
            url: gon.resume_multiple_workspace_task_chains_path,
            type: 'POST',
            data: {
              task_chain_ids: selectedTaskChainIDs
            },
            success: function(data) {
              return _this.reset(data);
            }
          });
        };

        TaskChainCollection.prototype.runSelected = function() {
          var selectedTaskChainIDs,
            _this = this;
          selectedTaskChainIDs = this.selected().pluck('id');
          return $.ajax({
            url: gon.start_multiple_workspace_task_chains_path,
            type: 'POST',
            data: {
              task_chain_ids: selectedTaskChainIDs
            },
            success: function(data) {
              return _this.reset(data);
            }
          });
        };

        return TaskChainCollection;

      })(App.Entities.Collection);
      API = {
        getTaskChains: function() {
          var task_chains;
          task_chains = new Entities.TaskChainsCollection;
          task_chains.fetch({
            reset: true
          });
          return task_chains;
        },
        getTaskChain: function(id) {
          var task_chains;
          task_chains = new Entities.TaskChain({
            id: id
          });
          task_chains.fetch();
          return task_chains;
        },
        newTaskChain: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.TaskChain(attributes);
        },
        newTaskChainCollection: function(taskChains) {
          var taskChainsArray;
          if (taskChains == null) {
            taskChains = [];
          }
          taskChainsArray = [];
          _.each(taskChains, function(taskChainAttributes) {
            return taskChainsArray.push(API.newTaskChain(taskChainAttributes));
          });
          return new Entities.TaskChainCollection(taskChainsArray);
        }
      };
      App.reqres.setHandler("task_chains:entities", function() {
        return API.getTaskChains;
      });
      App.reqres.setHandler("task_chains:entity", function(id) {
        return API.getTaskChain(id);
      });
      App.reqres.setHandler("new:task_chains:entity", function(attributes) {
        return API.newTaskChain(attributes);
      });
      return App.reqres.setHandler("new:task_chains:collection", function(taskChainArray) {
        return API.newTaskChainCollection(taskChainArray);
      });
    });
  });

}).call(this);
