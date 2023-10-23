(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/cleanup_task-9d6492c6cf4b1726fb0bba59f79d45145c1121a5dc0ee17b79dffb079c2a58da.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js'], function($, Template, TaskConfigView) {
    var CleanupTask;
    return CleanupTask = (function(_super) {

      __extends(CleanupTask, _super);

      function CleanupTask() {
        this._afterLoad = __bind(this._afterLoad, this);

        this.onBeforeClose = __bind(this.onBeforeClose, this);
        return CleanupTask.__super__.constructor.apply(this, arguments);
      }

      CleanupTask.prototype.template = HandlebarsTemplates['task_chains/item_views/cleanup_task'];

      CleanupTask.prototype.onShow = function() {
        return this.loadPartial("/workspaces/" + WORKSPACE_ID + "/tasks/new_cleanup?_nl=1", this._afterLoad, this);
      };

      CleanupTask.prototype.onBeforeClose = function() {
        this.errors = null;
        return $(document).trigger('validated', this);
      };

      CleanupTask.prototype._afterLoad = function(args) {
        this.delegateEvents();
        this.bindUIElements();
        return $("#cleanup_all_sessions", this.el).checkAll($("#cleanup_sessions"));
      };

      return CleanupTask;

    })(TaskConfigView);
  });

}).call(this);
