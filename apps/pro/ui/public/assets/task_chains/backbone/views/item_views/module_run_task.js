(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/module_run_task-2d1e55b82cdb2d20af33b3a7684fb8795c4b4ba07d3b7d3416582e90d3d9545a.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js'], function($, Template, TaskConfigView, Modal) {
    var ModuleRunTask;
    return ModuleRunTask = (function(_super) {

      __extends(ModuleRunTask, _super);

      function ModuleRunTask() {
        this._afterLoad = __bind(this._afterLoad, this);

        this.onBeforeClose = __bind(this.onBeforeClose, this);
        return ModuleRunTask.__super__.constructor.apply(this, arguments);
      }

      ModuleRunTask.prototype.template = HandlebarsTemplates['task_chains/item_views/module_run_task'];

      ModuleRunTask.prototype.MODULE_URL_BASE = "/workspaces/" + WORKSPACE_ID + "/tasks/new_module_run";

      ModuleRunTask.prototype.VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/tasks/validate_module_run";

      ModuleRunTask.prototype.ui = _.extend({}, TaskConfigView.prototype.ui, {
        'center': '.center',
        'search_form': '.center .searchform'
      });

      ModuleRunTask.prototype.events = _.extend({}, TaskConfigView.prototype.events, {
        'click .module-name': '_loadModule',
        'submit .searchform': '_loadModuleSearch',
        'click .table-sort': '_loadModuleSort'
      });

      ModuleRunTask.prototype.onShow = function() {
        return this.loadPartial("/workspaces/" + WORKSPACE_ID + "/modules", this._afterLoad, this);
      };

      ModuleRunTask.prototype.onBeforeClose = function() {
        if (this.moduleSelected || this.ui.form.length === 0 && !(this.ui.search_form.length === 1)) {
          ModuleRunTask.__super__.onBeforeClose.apply(this, arguments);
          return this._validate(this.VALIDATION_URL);
        } else {
          this.errors = "Need to Select a Module";
          this._setCache();
          $(document).trigger('showErrorPie', this);
          return $(document).trigger('validated', this);
        }
      };

      ModuleRunTask.prototype._afterLoad = function(args) {
        var modulePath;
        if (this.ui.search_form.length === 0) {
          this.moduleSelected = true;
          modulePath = $('.module_path', this.el).html();
          return $('form', this.el).append("<input type='hidden' name='path' value='" + modulePath + "' />");
        } else {
          this.search = $(this.ui.search_form[0].cloneNode(true));
          this.ui.center.html('');
          return this.ui.center[0].appendChild(this.search[0]);
        }
      };

      ModuleRunTask.prototype._loadModuleSearch = function(e) {
        var args, path, query,
          _this = this;
        e.preventDefault();
        query = $('#q', e.target).val();
        path = "/workspaces/" + WORKSPACE_ID + "/modules";
        args = {
          _nl: "1",
          q: query
        };
        return $.ajax(path, {
          type: "POST",
          data: args,
          success: function(data, textStatus, jqXHR) {
            var fragment;
            fragment = $(data).last();
            return $('#modules', _this.ui.config).html($(fragment).html());
          }
        });
      };

      ModuleRunTask.prototype._loadModuleSort = function(e) {
        var query,
          _this = this;
        e.preventDefault();
        query = e.target.pathname;
        return $.ajax(e.target.pathname + e.target.search, {
          type: "GET",
          success: function(data, textStatus, jqXHR) {
            var fragment;
            fragment = $(data).last();
            return $('#modules', _this.ui.config).html($(fragment).html());
          }
        });
      };

      ModuleRunTask.prototype._loadModule = function(e) {
        var module_full_name;
        e.preventDefault();
        module_full_name = $(e.target).attr('module_fullname');
        return this._loadForm("" + this.MODULE_URL_BASE + "/" + module_full_name + "?_nl=1");
      };

      ModuleRunTask.prototype._loadForm = function(url) {
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
          modulePath = $('.module_path', _this.el).html();
          $('form', _this.el).append("<input type='hidden' name='path' value='" + modulePath + "' />");
          $('form', _this.el).append("<input type='hidden' name='authenticity_token' value='" + ($('meta[name=csrf-token]').attr('content')) + "' />");
          $('form', _this.el).append('<input name="utf8" type="hidden" value="✓">');
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

      return ModuleRunTask;

    })(TaskConfigView);
  });

}).call(this);
