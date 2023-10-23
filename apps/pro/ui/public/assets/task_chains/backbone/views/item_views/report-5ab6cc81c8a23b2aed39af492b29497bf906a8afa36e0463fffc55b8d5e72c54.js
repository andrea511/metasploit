(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/report-a6639fa5792a7e9cd67220bc0d864576306672d5bce5c7f45b3851f964b7ed64.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js'], function($, Template, TaskConfigView) {
    var Report;
    return Report = (function(_super) {

      __extends(Report, _super);

      function Report() {
        this._report_type_changed = __bind(this._report_type_changed, this);

        this._afterLoad = __bind(this._afterLoad, this);
        return Report.__super__.constructor.apply(this, arguments);
      }

      Report.prototype.template = HandlebarsTemplates['task_chains/item_views/report'];

      Report.prototype.VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/reports/validate_report";

      Report.prototype.onShow = function() {
        $(document).on('report.loaded', this._report_type_changed);
        return this.loadPartial("/workspaces/" + WORKSPACE_ID + "/reports/new?_nl=0", this._afterLoad, this);
      };

      Report.prototype.onBeforeClose = function() {
        Report.__super__.onBeforeClose.apply(this, arguments);
        $(document).off('report.loaded', this._report_type_changed);
        return this._validate(this.VALIDATION_URL);
      };

      Report.prototype._afterLoad = function(args) {
        $($('.inputs ol', this.el)[0]).show();
        $('fieldset.buttons', this.el).remove();
        return $('.text_link_row', this.el).remove();
      };

      Report.prototype._report_type_changed = function() {
        this.delegateEvents();
        this.bindUIElements();
        this.errors = null;
        $(document).trigger('clearErrorPie', this);
        this._initErrorMessages();
        $(document).trigger('validated', this);
        return this._afterLoad(null);
      };

      return Report;

    })(TaskConfigView);
  });

}).call(this);
