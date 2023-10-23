(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/module_run_task-2d1e55b82cdb2d20af33b3a7684fb8795c4b4ba07d3b7d3416582e90d3d9545a.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js'], function($, Template, TaskConfigView, Modal) {
    var RcLaunchTask;
    return RcLaunchTask = (function(_super) {

      __extends(RcLaunchTask, _super);

      function RcLaunchTask() {
        this._removeActions = __bind(this._removeActions, this);

        this.onBeforeClose = __bind(this.onBeforeClose, this);
        return RcLaunchTask.__super__.constructor.apply(this, arguments);
      }

      RcLaunchTask.prototype.template = HandlebarsTemplates['task_chains/item_views/module_run_task'];

      RcLaunchTask.prototype.WORKSPACE_URL_BASE = "/workspaces/" + WORKSPACE_ID + "/";

      RcLaunchTask.prototype.RCSCRIPT_URL_BASE = "/workspaces/" + WORKSPACE_ID + "/tasks/new_rc_script_run";

      RcLaunchTask.prototype.VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/tasks/validate_rc_script_run";

      RcLaunchTask.prototype.ui = _.extend({}, TaskConfigView.prototype.ui, {
        'center': '.center',
        'search_form': '.center .searchform'
      });

      RcLaunchTask.prototype.events = _.extend({}, TaskConfigView.prototype.events, {
        'click .rc-script-link': '_loadRCScript'
      });

      RcLaunchTask.prototype.onShow = function() {
        return this.loadPartial("/workspaces/" + WORKSPACE_ID + "/rc_scripts", this._afterLoad, this);
      };

      RcLaunchTask.prototype.onBeforeClose = function() {
        RcLaunchTask.__super__.onBeforeClose.apply(this, arguments);
        return this._validate(this.VALIDATION_URL);
      };

      RcLaunchTask.prototype._removeActions = function() {
        return $("#rc-script-list input[type='checkbox']").hide();
      };

      RcLaunchTask.prototype._loadRCScript = function(e) {
        var l, rc_script_path;
        e.preventDefault();
        l = document.createElement("a");
        l.href = $(e.target).attr('href');
        rc_script_path = $(e.target).text();
        return this._loadForm("" + this.RCSCRIPT_URL_BASE + "/" + rc_script_path + l.search);
      };

      RcLaunchTask.prototype._loadForm = function(url) {
        var $form, data, opts,
          _this = this;
        $form = $('form', this.el);
        data = [
          {
            name: 'authenticity_token',
            value: $('meta[name=csrf-token]').attr('content')
          }
        ];
        data = data.concat($('input,select,textarea', $form).not(':file').serializeArray());
        opts = {
          type: 'GET',
          data: data
        };
        $('ol', $form).show();
        return $.ajax(url, opts).done(function(data) {
          var modulePath;
          _this.ui.config.html(data);
          $('.module-wrapper', _this.ui.config).css('margin', 'auto');
          modulePath = $('.rc_script_filename', _this.el).text();
          $('form', _this.el).append("<input type='hidden' name='authenticity_token' value='" + ($('meta[name=csrf-token]').attr('content')) + "' />");
          $('form', _this.el).append('<input name="utf8" type="hidden" value="✓">');
          $('form', _this.el).append("<input type='hidden' name='path' value='" + modulePath + "' />");
          _this.bindUIElements();
          _this.undelegateEvents();
          _this.delegateEvents();
          _this._setCache();
          _this.errors = null;
          _this._initErrorMessages();
          $(document).trigger('validated', _this);
          return _this.moduleSelected = true;
        });
      };

      return RcLaunchTask;

    })(TaskConfigView);
  });

}).call(this);
