(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/templates/task_chains/layouts/task_chains-c81fac35c84c64108bf8dc2b3c91e22765ecbcd484e98b2563879c864f2c09bb.js', '/assets/task_chains/backbone/views/item_views/task_chain_header-acfe3b37c5d34d2bd9992229651fd8e11ed4a20837e012b9e45a50bd825b7ac5.js', '/assets/task_chains/backbone/views/layouts/task_chain_nav-bedea5200914d4cf134ba39a9375a072cf3bb817ed3b47afc6978325fa294bce.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js', '/assets/task_chains/backbone/views/item_views/empty_task_config-b7829de3d350f766b61f3b14d9cb38234068b5a2a4182e7438c74a5444993aec.js', 'lib/components/modal/modal_controller', '/assets/templates/task_chains/item_views/legacy_warning-ee7ab79320b2a7b7c0cee22c4b0a7e1f0f32b33d7e7b2429fb667105337864d4.js'], function($, Template, Header, Nav, TaskConfig, EmptyTaskConfig) {
    var EmptyView, LegacyWarningView, TaskChainsLayout;
    Backbone.Syphon.InputWriters.register("checkbox", function($el, value) {
      if (typeof value !== 'boolean') {
        if (value === "true") {
          value = true;
        } else {
          value = false;
        }
      }
      return $el.prop("checked", value);
    });
    Backbone.Syphon.InputReaders.register("hidden", function($el) {
      var value;
      value = $el.val();
      if ($el.val() === 'true') {
        value = true;
      }
      if ($el.val() === 'false') {
        value = false;
      }
      return value;
    });
    LegacyWarningView = (function(_super) {

      __extends(LegacyWarningView, _super);

      function LegacyWarningView() {
        return LegacyWarningView.__super__.constructor.apply(this, arguments);
      }

      LegacyWarningView.prototype.template = HandlebarsTemplates['task_chains/item_views/legacy_warning'];

      LegacyWarningView.prototype.onFormSubmit = function() {
        var defer, formSubmit;
        defer = $.Deferred();
        formSubmit = function() {};
        defer.promise(formSubmit);
        defer.resolve();
        return formSubmit;
      };

      return LegacyWarningView;

    })(Backbone.Marionette.ItemView);
    EmptyView = (function(_super) {

      __extends(EmptyView, _super);

      function EmptyView() {
        return EmptyView.__super__.constructor.apply(this, arguments);
      }

      EmptyView.prototype.template = _.template('');

      return EmptyView;

    })(Backbone.Marionette.ItemView);
    return TaskChainsLayout = (function(_super) {

      __extends(TaskChainsLayout, _super);

      function TaskChainsLayout() {
        this._renderErrors = __bind(this._renderErrors, this);

        this._showView = __bind(this._showView, this);

        this._formSubmit = __bind(this._formSubmit, this);

        this._saveChainAndRun = __bind(this._saveChainAndRun, this);

        this._saveChain = __bind(this._saveChain, this);

        this._rewriteInputs = __bind(this._rewriteInputs, this);

        this._disableButtonOnValidation = __bind(this._disableButtonOnValidation, this);

        this._updateSaveButton = __bind(this._updateSaveButton, this);

        this._updateHeadButtons = __bind(this._updateHeadButtons, this);

        this._showAddState = __bind(this._showAddState, this);

        this._toggleActiveTaskChainItemView = __bind(this._toggleActiveTaskChainItemView, this);

        this._showActivePie = __bind(this._showActivePie, this);

        this._showErrorPie = __bind(this._showErrorPie, this);

        this._clearErrorPie = __bind(this._clearErrorPie, this);

        this._loadNextTask = __bind(this._loadNextTask, this);

        this._updateTaskChainRunning = __bind(this._updateTaskChainRunning, this);

        this.onShow = __bind(this.onShow, this);
        return TaskChainsLayout.__super__.constructor.apply(this, arguments);
      }

      TaskChainsLayout.prototype.template = HandlebarsTemplates['task_chains/layouts/task_chains'];

      TaskChainsLayout.prototype.TASK_CHAIN_VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/task_chains/validate";

      TaskChainsLayout.prototype.events = {
        'showTaskConfig .nav': '_showTaskConfig',
        'showEmptyState .nav': '_showEmptyState',
        'showAddState .nav': '_showAddState',
        'cloneTaskConfig .nav': '_cloneTaskConfig',
        'saveChain .header': '_saveChain',
        'saveChainAndRun .header': '_saveChainAndRun',
        'taskConfigChanged .content': '_configChanged'
      };

      TaskChainsLayout.prototype.ui = {
        hidden_inputs: '.hidden-inputs',
        hidden_form: '#hidden-form',
        content: '.content'
      };

      TaskChainsLayout.prototype.regions = {
        header: '.header',
        nav: '.nav',
        content: '.content'
      };

      TaskChainsLayout.prototype.initialize = function(opts) {
        var _this = this;
        this.legacyTasks = opts.legacyTasks;
        this.emptyView = new EmptyTaskConfig();
        this.view_cache = {};
        this.model = new Backbone.Model({});
        this._initialized = false;
        this.listenTo(this.content, 'show', function() {
          return _this.ui.content.addClass('loaded');
        });
        return this.listenTo(this.content, 'before:swap', function() {
          return _this.ui.content.removeClass('loaded');
        });
      };

      TaskChainsLayout.prototype.onShow = function() {
        var content,
          _this = this;
        content = $('meta[name="task_chain"]').attr('content') || "null";
        this.task_chain = $.parseJSON(content);
        this.listenTo(this.header, "show", function() {
          return gon.watch('taskChainRunning', {
            interval: 3000
          }, _this._updateTaskChainRunning);
        });
        this.listenTo(this.header, "destroy", function() {
          return gon.unwatch('taskChainRunning', _this._updateTaskChainRunning);
        });
        this.listenTo(this.nav, "show", function() {
          return _this.listenTo(_this.nav.currentView.pies, "show", function() {
            return _this._updateSaveButton();
          });
        });
        this.header.show(new Header({
          model: new Backbone.Model({
            task_chain: this.task_chain
          })
        }), {
          preventDestroy: true
        });
        this.nav.show(new Nav());
        this.content.show(this.emptyView);
        this._bind_events();
        if (this.task_chain == null) {
          this.emptyView = new EmptyTaskConfig();
          return this.view_cache = {};
        } else {
          return this._initSavedConfig();
        }
      };

      TaskChainsLayout.prototype.onDestroy = function() {
        return this._unbind_events();
      };

      TaskChainsLayout.prototype._updateTaskChainRunning = function(running) {
        gon.taskChainRunning = running;
        return this._updateSaveButton({
          tooltipMsg: {
            disabled: 'Unable to edit a running task chain'
          }
        });
      };

      TaskChainsLayout.prototype._bind_events = function() {
        $(document).on('clearErrorPie', this._clearErrorPie);
        $(document).on('showErrorPie', this._showErrorPie);
        $(document).on('showActivePie', this._showActivePie);
        $(document).on('validated', this._updateSaveButton);
        return $(document).on('before:validated', this._disableButtonOnValidation);
      };

      TaskChainsLayout.prototype._unbind_events = function() {
        $(document).off('clearErrorPie', this._clearErrorPie);
        $(document).off('showErrorPie', this._showErrorPie);
        $(document).off('showActivePie', this._showActivePie);
        $(document).off('validated', this._updateSaveButton);
        return $(document).off('before:validated', this._disableButtonOnValidation);
      };

      TaskChainsLayout.prototype._initSavedConfig = function() {
        this.header.currentView.setName(this.task_chain.name);
        this.header.currentView.setScheduleInfo(this.task_chain.schedule_info);
        this.header.currentView.setState(this.task_chain);
        helpers.showLoadingDialog.call(this);
        if (this.task_chain.scheduled_tasks.length > 0) {
          this.ui.content.hide().css('min-height', '300px');
          this._loadIdx = 0;
          return this._loadNextTask();
        }
      };

      TaskChainsLayout.prototype._loadNextTask = function() {
        var task, _ref;
        if (!this._initialized) {
          if (((_ref = this.task_chain) != null ? _ref.scheduled_tasks.length : void 0) > this._loadIdx) {
            task = this.task_chain.scheduled_tasks[this._loadIdx];
            task.setCurrent = true;
            this.nav.currentView.addExistingTask(task);
            return this._loadIdx++;
          } else {
            this._initialized = true;
            this.ui.content.show();
            helpers.hideLoadingDialog.call(this);
            return this._showLegacyWarning();
          }
        }
      };

      TaskChainsLayout.prototype._showLegacyWarning = function() {
        var view, _ref;
        if (((_ref = this.legacyTasks) != null ? _ref.length : void 0) > 0) {
          view = new LegacyWarningView({
            model: new Backbone.Model({
              legacyTasks: this.legacyTasks
            })
          });
          return Pro.execute('showModal', view, {
            modal: {
              title: 'Task Chain Warning',
              description: '',
              width: 600,
              height: 180
            },
            buttons: [
              {
                name: 'OK',
                "class": 'btn primary'
              }
            ]
          });
        }
      };

      TaskChainsLayout.prototype._cloneTaskConfig = function() {
        this.content.currentView._storeForm({
          callSuper: false
        });
        return this.clonedConfigNode = helpers.cloneNodeAndForm(this.content.currentView.ui.config[0]);
      };

      TaskChainsLayout.prototype._showTaskConfig = function(e, opts) {
        var options, _base;
        if (opts.task != null) {
          if (this.view_cache[opts.form_id] == null) {
            this.view_cache[opts.form_id] = new opts.task_view({
              model: new Backbone.Model({
                form_id: opts.form_id,
                task: opts.task
              })
            });
            this.listenTo(this.view_cache[opts.form_id], 'loaded', function() {
              return this._loadNextTask();
            });
          }
          this.content.currentView.close();
          return this.content.show(this.view_cache[opts.form_id], {
            preventDestroy: true,
            forceShow: true
          });
        } else {
          if (this.view_cache[opts.form_id] == null) {
            options = {
              form_id: opts.form_id
            };
            if ((opts.cloned != null) && opts.cloned) {
              options = _.extend(opts, {
                cloned: opts.cloned,
                clonedConfigNode: this.clonedConfigNode,
                clonedModel: typeof (_base = this.content.currentView).formModel === "function" ? _base.formModel() : void 0
              });
            }
            this.view_cache[opts.form_id] = new opts.task_view({
              model: new Backbone.Model(options)
            });
            this.listenTo(this.view_cache[opts.form_id], 'loaded', function() {
              return this._loadNextTask();
            });
          }
          this.content.currentView.close();
          return this.content.show(this.view_cache[opts.form_id], {
            preventDestroy: true,
            forceShow: true
          });
        }
      };

      TaskChainsLayout.prototype._clearErrorPie = function(e, task_config_view) {
        return this._toggleActiveTaskChainItemView(e, task_config_view, false);
      };

      TaskChainsLayout.prototype._showErrorPie = function(e, task_config_view) {
        return this._toggleActiveTaskChainItemView(e, task_config_view, true);
      };

      TaskChainsLayout.prototype._showActivePie = function(e, task_config_view) {
        var active_task_chain_item_model, active_task_chain_item_view;
        active_task_chain_item_model = this._getActiveTaskChainModel(task_config_view);
        if (active_task_chain_item_model) {
          active_task_chain_item_view = this.nav.currentView.pies.currentView.children.findByModel(active_task_chain_item_model);
          return active_task_chain_item_view.active();
        }
      };

      TaskChainsLayout.prototype._toggleActiveTaskChainItemView = function(e, task_config_view, flag) {
        var active_task_chain_item_model, active_task_chain_item_view;
        if (flag == null) {
          flag = true;
        }
        active_task_chain_item_model = this._getActiveTaskChainModel(task_config_view);
        if (active_task_chain_item_model) {
          active_task_chain_item_view = this.nav.currentView.pies.currentView.children.findByModel(active_task_chain_item_model);
          if (flag) {
            return active_task_chain_item_view.flag();
          } else {
            return active_task_chain_item_view.unflag();
          }
        }
      };

      TaskChainsLayout.prototype._getActiveTaskChainModel = function(task_config_view) {
        var active_task_chain_item_model, collection;
        collection = this.nav.currentView.pies.currentView.collection;
        return active_task_chain_item_model = collection.findWhere({
          'cid': task_config_view.model.get('form_id')
        });
      };

      TaskChainsLayout.prototype._showEmptyState = function(e) {
        this.content.currentView.close();
        return this.content.show(this.emptyView, {
          preventDestroy: true
        });
      };

      TaskChainsLayout.prototype._showAddState = function(e, collection) {
        return this._updateSaveButton();
      };

      TaskChainsLayout.prototype._configChanged = function(e, task_config) {
        return this._updateSaveButton({
          ignoreTaskConfig: task_config
        });
      };

      TaskChainsLayout.prototype._updateHeadButtons = function(e) {
        return this._updateSaveButton();
      };

      TaskChainsLayout.prototype._updateSaveButton = function(opts) {
        var collection, disableSave, ignoreTaskConfig, tooltipMsg,
          _this = this;
        if (opts == null) {
          opts = {};
        }
        ignoreTaskConfig = opts.ignoreTaskConfig, tooltipMsg = opts.tooltipMsg;
        disableSave = false;
        collection = this.nav.currentView.pies.currentView.collection;
        collection.each(function(task_chain_item, index) {
          var task_config_view;
          task_config_view = _this.view_cache[task_chain_item.cid];
          if (task_config_view != null) {
            if (!ignoreTaskConfig || ((ignoreTaskConfig != null) && ignoreTaskConfig.cid !== task_config_view.cid)) {
              if (task_config_view.errors != null) {
                disableSave = true;
              }
            }
          }
        });
        if ((disableSave && collection.length > 1) || collection.length === 0 || gon.taskChainRunning) {
          this.header.currentView.disableSave({
            toolTipMsg: tooltipMsg != null ? tooltipMsg.disabled : void 0
          });
        } else {
          this.header.currentView.enableSave({
            tooltipMsg: tooltipMsg != null ? tooltipMsg.enabled : void 0
          });
        }
        return this.header;
      };

      TaskChainsLayout.prototype._disableButtonOnValidation = function() {
        return this.header.currentView.disableSave();
      };

      TaskChainsLayout.prototype._rewriteInputs = function(form, chain_index, task_chain_item) {
        var $inputs, cid, task,
          _this = this;
        $inputs = $('input, textarea, select', form);
        cid = task_chain_item.get('cid');
        task = this.view_cache[cid];
        if ((task.mm != null) && (task.mm.formOverrides != null) && $('[name="task_config[cred_type]"]:checked', form).val() === "stored") {
          $inputs = task.mm.sendAjax(form, form);
        }
        $inputs.each(function(index, input) {
          var name, reportIndex, startIndex;
          name = $(input).attr('name');
          if (name === "utf8" || name === "authenticity_token") {
            return $(input).remove();
          } else {
            if (name === 'no_files') {
              $(input).val('0');
            }
            if (name) {
              startIndex = name.indexOf('[');
              reportIndex = name.indexOf('report[');
              switch (task_chain_item.get('type')) {
                case 'nexpose':
                case 'import':
                  name = "inputs_for_task[" + chain_index + "]" + name;
                  return $(input).attr('name', name);
                default:
                  if (startIndex > 1 && task_chain_item.get('type') !== 'metamodule') {
                    name = "inputs_for_task[" + chain_index + "]" + (name.substring(startIndex));
                    return $(input).attr('name', name);
                  } else {
                    if (reportIndex === 0) {
                      name = "inputs_for_task[" + chain_index + "][report]" + (name.substring(startIndex));
                      return $(input).attr('name', name);
                    } else {
                      name = "inputs_for_task[" + chain_index + "]" + (name.substring(startIndex));
                      return $(input).attr('name', name);
                    }
                  }
              }
            }
          }
        });
        return $inputs;
      };

      TaskChainsLayout.prototype._filterInputs = function(form, index) {
        var $form;
        $form = $(form);
        $('[name="_method"]', $form).remove();
        if (index > 1) {
          $('[name="authenticity_token"]', $form).remove();
          $('[name="utf8"]', $form).remove();
        }
        return $('input, textarea, select', form);
      };

      TaskChainsLayout.prototype._construct_task_order = function(collection) {
        var length, task_order;
        task_order = "";
        length = collection.length;
        collection.each(function(task_chain_item, index) {
          var delimitter;
          delimitter = index + 1 === length ? '' : ',';
          return task_order = task_order.concat("" + (index + 1) + delimitter);
        });
        return task_order;
      };

      TaskChainsLayout.prototype._save = function() {
        if ($('.tab-loading:visible', this.el).length < 1) {
          $(document).on('validated', this._formSubmit);
          this.content.currentView.close();
          return this.content.show(new EmptyView(), {
            preventDestroy: true
          });
        }
      };

      TaskChainsLayout.prototype._saveChain = function() {
        this.model.set('run_now', false);
        return this._save();
      };

      TaskChainsLayout.prototype._saveChainAndRun = function() {
        this.model.set('run_now', true);
        return this._save();
      };

      TaskChainsLayout.prototype._formSubmit = function(e, view) {
        this.header.currentView.disableSave();
        _.defer(this._showView, view);
        this._validate_chain_before_submit(view.errors);
        if (!view.errors) {
          return $(document).off('validated', this._formSubmit);
        }
      };

      TaskChainsLayout.prototype._showView = function(view) {
        var _base;
        if (typeof (_base = this.content.currentView).close === "function") {
          _base.close();
        }
        return this.content.show(view, {
          preventDestroy: true
        });
      };

      TaskChainsLayout.prototype._validate_chain_before_submit = function(errors) {
        var chain_id, data,
          _this = this;
        chain_id = typeof TASK_CHAIN_ID !== "undefined" && TASK_CHAIN_ID !== null ? TASK_CHAIN_ID : '';
        data = [
          {
            name: 'authenticity_token',
            value: $('meta[name=csrf-token]').attr('content')
          }, {
            name: 'task_chain[name]',
            value: this.header.currentView.ui.task_chain_name.val()
          }, {
            name: 'id',
            value: chain_id
          }
        ];
        this.viewErrors = errors;
        return $.ajax({
          url: this.TASK_CHAIN_VALIDATION_URL,
          type: "POST",
          data: data,
          success: function(data) {
            var _base;
            if (!_this.viewErrors) {
              if (_this.content.currentView != null) {
                if (typeof (_base = _this.content.currentView).hideForSubmit === "function") {
                  _base.hideForSubmit();
                }
              } else {
                _this.ui.content.html('<div class="tab-loading vertical-spacer></div>');
              }
              _this._formatTaskConfigs();
              _this._appendInputs();
              _this._appendSchedule();
              if (_this.task_chain != null) {
                _this._appendId();
              }
              _this._appendAuthToken(_this.ui.hidden_form);
              _this.ui.hidden_form.hide();
              $(document).off('validated', _this._formSubmit);
              return _this.ui.hidden_form.submit();
            } else {
              $('.field-container .error', _this.el).remove();
              $(document).off('validated', _this._formSubmit);
              return _this.header.currentView.enableSave();
            }
          },
          error: function(data) {
            var json_response;
            $('.field-container .error', _this.el).remove();
            json_response = $.parseJSON(data.responseText);
            $(document).off('validated', _this._formSubmit);
            _this._renderErrors(json_response.errors);
            return _this.header.currentView.enableSave();
          }
        });
      };

      TaskChainsLayout.prototype._renderErrors = function(errors) {
        var _this = this;
        return _.each(errors, function(v, k) {
          var $msg, name;
          name = "task_chain[" + k + "]";
          $msg = $('<div />', {
            "class": 'error'
          }).text(v[0]);
          return $("input[name='" + name + "']", _this.el).addClass('invalid').after($msg);
        });
      };

      TaskChainsLayout.prototype._appendAuthToken = function($form) {
        if ($('[name="authenticity_token"]', $form).length === 0) {
          return this.ui.hidden_form.append("<input name='authenticity_token' type='hidden' value='" + ($('meta[name=csrf-token]').attr('content')) + "'>");
        }
      };

      TaskChainsLayout.prototype._appendId = function() {
        this.ui.hidden_form.attr('action', "" + (this.ui.hidden_form.attr('action')) + "/" + this.task_chain.id);
        return this.ui.hidden_form.append('<input name="_method" type="hidden" value="put" />');
      };

      TaskChainsLayout.prototype._formatTaskConfigs = function() {
        var _this = this;
        this.ui.hidden_form.attr('action', "/workspaces/" + WORKSPACE_ID + "/task_chains");
        return this.nav.currentView.pies.currentView.collection.each(function(task_chain_item, index) {
          var $inputs, form, scheduled_task_types, task_config_view;
          task_config_view = _this.view_cache[task_chain_item.cid];
          if (task_config_view.storedForm.get == null) {
            form = task_config_view.storedForm;
          } else {
            form = task_config_view.storedForm.generateInputs();
          }
          task_config_view._applyStashedFileInput(form);
          $inputs = _this._rewriteInputs(form, index + 1, task_chain_item);
          $(form).empty();
          $(form).append($inputs);
          $inputs = _this._filterInputs(form, index + 1);
          _this.ui.hidden_inputs.append($inputs);
          scheduled_task_types = "<input name='scheduled_task_types[" + (index + 1) + "]' value='" + (task_chain_item.get("type")) + "'>";
          return _this.ui.hidden_inputs.append(scheduled_task_types);
        });
      };

      TaskChainsLayout.prototype._appendInputs = function() {
        var $task_chain_name, collection, scheduled_task_order, task_order;
        collection = this.nav.currentView.pies.currentView.collection;
        task_order = this._construct_task_order(collection);
        scheduled_task_order = "<input name='scheduled_task_order' value='" + task_order + "'>";
        this.ui.hidden_inputs.append(scheduled_task_order);
        $task_chain_name = $(this.header.currentView.ui.task_chain_name).clone(false);
        $task_chain_name.val(this.header.currentView.ui.task_chain_name.val());
        this.ui.hidden_inputs.append($task_chain_name);
        return this.ui.hidden_inputs.append("<input name='run_now' value='" + (this.model.get('run_now')) + "'>");
      };

      TaskChainsLayout.prototype._appendSchedule = function() {
        var $schedule, $storedSchedule, schedule;
        if (this.header.currentView.cachedSchedule.restoreSchedule != null) {
          schedule = this.header.currentView.cachedSchedule.restoreSchedule;
        } else {
          schedule = this.header.currentView.cachedSchedule.cachedView;
        }
        if ((schedule.restoreEl != null) || (schedule.cachedEl != null)) {
          if (schedule.restoreEl != null) {
            $storedSchedule = schedule.restoreEl;
          } else {
            $storedSchedule = schedule.cachedEl;
          }
        } else {
          $storedSchedule = this.header.currentView.cachedSchedule.cachedView.el;
        }
        if (this.header.currentView.ui.schedule_state.hasClass('schedule')) {
          this.ui.hidden_inputs.append("<input type='hidden' name='scheduled' value='false' />");
          $('input.suspend', $storedSchedule).val('manual');
          $('input.suspend', $storedSchedule).prop('checked', 'checked');
        }
        $schedule = $('input, select', $storedSchedule);
        return this.ui.hidden_inputs.append($schedule);
      };

      return TaskChainsLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
