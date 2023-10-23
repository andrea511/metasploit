(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/scan_task-045c580bc0b8e8d42ae4e62d8303f2930dd9a3b631c5f5bc1c4f6f04ea180fd7.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js'], function($, Template, TaskConfigView) {
    var ScanTask;
    return ScanTask = (function(_super) {

      __extends(ScanTask, _super);

      function ScanTask() {
        return ScanTask.__super__.constructor.apply(this, arguments);
      }

      ScanTask.prototype.template = HandlebarsTemplates['task_chains/item_views/scan_task'];

      ScanTask.prototype.VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/tasks/validate_scan";

      ScanTask.prototype.onShow = function() {
        return this.loadPartial("/workspaces/" + WORKSPACE_ID + "/tasks/new_scan");
      };

      ScanTask.prototype.onBeforeClose = function() {
        ScanTask.__super__.onBeforeClose.apply(this, arguments);
        return this._validate(this.VALIDATION_URL);
      };

      return ScanTask;

    })(TaskConfigView);
  });

}).call(this);
