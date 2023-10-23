(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/task_chains/backbone/views/layouts/task_chains_layout-45c9d81b48d332b51e62e0bab2a5eb00db949509fe905e4624ffd4b7990f2a0a.js'], function($, TaskChainsLayout) {
    var TaskChainsController;
    return TaskChainsController = (function(_super) {

      __extends(TaskChainsController, _super);

      function TaskChainsController() {
        this.start = __bind(this.start, this);
        return TaskChainsController.__super__.constructor.apply(this, arguments);
      }

      TaskChainsController.prototype.initialize = function(opts) {
        return this.legacyTasks = opts.legacyTasks, opts;
      };

      TaskChainsController.prototype.start = function() {
        this.region = new Backbone.Marionette.Region({
          el: '#task-chain-region'
        });
        return this.region.show(new TaskChainsLayout({
          legacyTasks: this.legacyTasks
        }));
      };

      return TaskChainsController;

    })(Marionette.Controller);
  });

}).call(this);
