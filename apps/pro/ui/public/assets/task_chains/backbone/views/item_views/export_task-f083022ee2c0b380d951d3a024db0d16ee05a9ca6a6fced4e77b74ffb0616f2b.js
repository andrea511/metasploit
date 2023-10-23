(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/nexpose_exception_push_task-b7569dda27ef4f091a13d5763ac01bdfbe79d1b915c4c42c27db085937102c8b.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js'], function($, Template, TaskConfigView) {
    var ExportTask;
    return ExportTask = (function(_super) {

      __extends(ExportTask, _super);

      function ExportTask() {
        this._afterLoad = __bind(this._afterLoad, this);

        this.onBeforeClose = __bind(this.onBeforeClose, this);
        return ExportTask.__super__.constructor.apply(this, arguments);
      }

      ExportTask.prototype.template = HandlebarsTemplates['task_chains/item_views/nexpose_exception_push_task'];

      ExportTask.prototype.VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/tasks/validate_nexpose_exception_push";

      ExportTask.prototype.ui = _.extend({}, TaskConfigView.prototype.ui, {
        'center': '.center',
        'search_form': '.center .searchform'
      });

      ExportTask.prototype.onShow = function() {
        return this.loadPartial("/workspaces/" + WORKSPACE_ID + "/tasks/new_nexpose_exception_push.html?task_chain=t", this._afterLoad, this);
      };

      ExportTask.prototype.onBeforeClose = function() {
        ExportTask.__super__.onBeforeClose.apply(this, arguments);
        return this._validate(this.VALIDATION_URL);
      };

      ExportTask.prototype._afterLoad = function() {
        var consoles;
        consoles = JSON.parse($('meta[name=consoles]').attr('content')).map(function(console) {
          return console.name;
        });
        $('#exception-push-header', this.el).text('Push to Nexpose');
        $('#nexpose_push_task_description', this.el).remove();
        $('#exception-push-header', this.el).after("<div id='nexpose_push_task_description' class='center'>Push Exceptions and Validations in workspace to the following Nexpose Consoles at time of execution: " + (consoles.join(', ')) + "</div>");
        this.ui.form.attr('action', "" + (Routes.workspace_nexpose_result_export_runs_path(WORKSPACE_ID)));
        this.ui.form.attr('method', "POST");
        this.ui.form.append("<input type='hidden' name='authenticity_token' value='" + ($('meta[name=csrf-token]').attr('content')) + "' />");
        this.ui.form.append('<input name="utf8" type="hidden" value="✓"/>');
        return this.ui.form.append("<input type='hidden' name='workspace_id' value='" + WORKSPACE_ID + "' />");
      };

      return ExportTask;

    })(TaskConfigView);
  });

}).call(this);
