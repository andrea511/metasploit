(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/webscan_task-29821c00b45fe78f1b0f6c98a4ade726ee5403fc3a119c562c6225af9eecd60f.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js'], function($, Template, TaskConfigView) {
    var WebscanTask;
    return WebscanTask = (function(_super) {

      __extends(WebscanTask, _super);

      function WebscanTask() {
        this._afterLoad = __bind(this._afterLoad, this);
        return WebscanTask.__super__.constructor.apply(this, arguments);
      }

      WebscanTask.prototype.template = HandlebarsTemplates['task_chains/item_views/webscan_task'];

      WebscanTask.prototype.VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/tasks/validate_webscan";

      WebscanTask.prototype.onShow = function() {
        return this.loadPartial("/workspaces/" + WORKSPACE_ID + "/tasks/new_webscan", this._afterLoad, this);
      };

      WebscanTask.prototype.onBeforeClose = function() {
        WebscanTask.__super__.onBeforeClose.apply(this, arguments);
        return this._validate(this.VALIDATION_URL);
      };

      WebscanTask.prototype._afterLoad = function(args) {
        this.delegateEvents();
        this.bindUIElements();
        return $("#all_vhosts", this.el).checkAll($("#vhost_list"));
      };

      return WebscanTask;

    })(TaskConfigView);
  });

}).call(this);
