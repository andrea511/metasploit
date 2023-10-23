(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/collect_task-d5ef49d3dfcdf3b7740394d84d197490b00d9564a2480c6cd56b3156dc7c1f70.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js'], function($, Template, TaskConfigView) {
    var CollectTask;
    return CollectTask = (function(_super) {

      __extends(CollectTask, _super);

      function CollectTask() {
        this._afterLoad = __bind(this._afterLoad, this);

        this.onBeforeClose = __bind(this.onBeforeClose, this);
        return CollectTask.__super__.constructor.apply(this, arguments);
      }

      CollectTask.prototype.template = HandlebarsTemplates['task_chains/item_views/collect_task'];

      CollectTask.prototype.onShow = function() {
        return this.loadPartial("/workspaces/" + WORKSPACE_ID + "/tasks/new_collect?_nl=1", this._afterLoad, this);
      };

      CollectTask.prototype.onBeforeClose = function() {
        this.errors = null;
        return $(document).trigger('validated', this);
      };

      CollectTask.prototype._afterLoad = function(args) {
        var _this = this;
        this.delegateEvents();
        this.bindUIElements();
        $('#collect_evidence_task_collect_files', this.el).on('click', function(e) {
          return _this.setFileFieldState();
        });
        $("#collect_all_sessions", this.el).checkAll($("#collect_sessions"));
        $('#collect_all_sessions', this.el).trigger('click');
        return this.setFileFieldState();
      };

      CollectTask.prototype.setFileFieldState = function() {
        if ($('#collect_evidence_task_collect_files', this.el).attr('checked')) {
          $('#collect_evidence_task_collect_files_pattern', this.el).removeAttr("disabled");
          $('#collect_evidence_task_collect_files_count', this.el).removeAttr("disabled");
          return $('#collect_evidence_task_collect_files_size', this.el).removeAttr("disabled");
        } else {
          $('#collect_evidence_task_collect_files_pattern', this.el).attr("disabled", "disabled");
          $('#collect_evidence_task_collect_files_count', this.el).attr("disabled", "disabled");
          return $('#collect_evidence_task_collect_files_size', this.el).attr("disabled", "disabled");
        }
      };

      return CollectTask;

    })(TaskConfigView);
  });

}).call(this);
