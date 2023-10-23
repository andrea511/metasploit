(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery'], function($) {
    var TaskConfigView;
    return TaskConfigView = (function(_super) {

      __extends(TaskConfigView, _super);

      function TaskConfigView() {
        return TaskConfigView.__super__.constructor.apply(this, arguments);
      }

      TaskConfigView.prototype.baseEditUrl = "/workspaces/" + WORKSPACE_ID + "/tasks";

      TaskConfigView.prototype.events = {
        'click @ui.form_headers': '_toggleAccordian',
        'keydown @ui.form': '_formChanged',
        'change @ui.file_inputs': '_formChanged'
      };

      TaskConfigView.prototype.ui = {
        config: '.config',
        errors: '.columns > .errors',
        form: '.config form.formtastic, .config form.new_module_run_task, .config .form-inputs, .config form.metamodule, .config form.rc_script_run_task, .config form.exception-push-form',
        form_headers: '.formtastic fieldset.inputs legend:not(.label)',
        form_section_titles: 'fieldset.inputs legend span',
        form_sections: 'fieldset.inputs ol',
        advanced_options: 'fieldset.inputs advanced-options-container',
        file_inputs: ':file'
      };

      TaskConfigView.prototype.regions = {
        configRegion: '.config'
      };

      TaskConfigView.prototype.close = function() {
        if (typeof this.onBeforeClose === "function") {
          this.onBeforeClose();
        }
        if (typeof this.onClose === "function") {
          this.onClose();
        }
        this.stopListening();
        return this.off();
      };

      TaskConfigView.prototype.onBeforeClose = function() {
        return this._setCache();
      };

      TaskConfigView.prototype._storeForm = function() {
        var hidden_fields;
        hidden_fields = this.ui.form.find('ol:hidden');
        hidden_fields.show();
        this.storedForm = this.ui.form[0] ? helpers.cloneNodeAndForm(this.ui.form[0]) : void 0;
        this.fileInputs = this.ui.file_inputs;
        return hidden_fields.hide();
      };

      TaskConfigView.prototype._setCache = function() {
        this.form_cache = helpers.cloneNodeAndForm(this.ui.config[0]);
        return this._storeForm();
      };

      TaskConfigView.prototype._formChanged = function() {
        return $(this.el).trigger('taskConfigChanged', this);
      };

      TaskConfigView.prototype._centerModule = function() {
        return $('.module-wrapper', this.el).css('margin', 'auto');
      };

      TaskConfigView.prototype.loadPartial = function(url, func, args) {
        var clonedNode,
          _this = this;
        if ((this.model.get('task') != null) && !(this.form_cache != null)) {
          return $.ajax({
            url: "" + this.baseEditUrl + "/" + (this.model.get('task').id) + "/edit",
            data: {
              kind: this.model.get('task').kind,
              _nl: 1
            },
            contentType: "application/json; charset=utf-8",
            success: function(data) {
              _this.bindUIElements();
              _this.ui.config.html(data);
              _this._removeFormCSRF();
              _this._removeActions();
              _this._initErrorMessages();
              _this.bindUIElements();
              _this.undelegateEvents();
              _this.delegateEvents();
              _this._init_accordian();
              _this._setCache();
              _this._centerModule();
              if (func) {
                func.call(args);
              }
              return _this.trigger('loaded');
            }
          });
        } else {
          if ((this.form_cache != null) && !(this.model.get('cloned') != null)) {
            this._applyStashedFileInput(this.form_cache);
            this.ui.config[0].parentNode.replaceChild(this.form_cache, this.ui.config[0]);
            this._initErrorMessages();
            this.bindUIElements();
            this.undelegateEvents();
            this.delegateEvents();
            if (func) {
              return func.call(args);
            }
          } else {
            if (this.model.get('cloned') != null) {
              clonedNode = this.model.get('clonedConfigNode');
              this.ui.config[0].parentNode.replaceChild(clonedNode, this.ui.config[0]);
              this.bindUIElements();
              this.undelegateEvents();
              this.delegateEvents();
              this.model.set('cloned', null);
              if (func) {
                return func.call(args);
              }
            } else {
              return $.ajax({
                url: url,
                contentType: "application/json; charset=utf-8",
                success: function(data) {
                  _this.ui.config.html(data);
                  _this._removeFormCSRF();
                  _this._removeActions();
                  _this._initErrorMessages();
                  _this.bindUIElements();
                  _this.undelegateEvents();
                  _this.delegateEvents();
                  _this._init_accordian();
                  _this._setCache();
                  if (func) {
                    func.call(args);
                  }
                  return _this.trigger('loaded');
                }
              });
            }
          }
        }
      };

      TaskConfigView.prototype.hideForSubmit = function() {
        return this.ui.config.html('<div class="tab-loading"></div>');
      };

      TaskConfigView.prototype._removeActions = function() {
        return $('fieldset.actions', this.ui.config).remove();
      };

      TaskConfigView.prototype._removeFormCSRF = function() {
        return $('input[name=authenticity_token]', this.ui.config).remove();
      };

      TaskConfigView.prototype._initErrorMessages = function() {
        if (typeof this.ui.errors !== "string") {
          if (this.errors) {
            this.ui.errors.show();
            return this.ui.errors.html(this.errors);
          } else {
            this.ui.errors.hide();
            return this.ui.errors.html('');
          }
        }
      };

      TaskConfigView.prototype._validate = function(url, overrides) {
        var $form, data, opts,
          _this = this;
        if (overrides == null) {
          overrides = [];
        }
        if (this.storedForm != null) {
          $form = $('form', this.el);
          data = [
            {
              name: 'authenticity_token',
              value: $('meta[name=csrf-token]').attr('content')
            }
          ];
          data = data.concat($('input,select,textarea', $form).not(':file, [name="_method"][value="delete"] ').serializeArray());
          data = data.concat(overrides);
          opts = {
            type: 'POST',
            data: data
          };
          $('ol', $form).show();
          $.ajax(url, opts).done(function(data) {
            if (!data.success) {
              _this.errors = data.errors;
              $(document).trigger('showErrorPie', _this);
            } else {
              _this.errors = null;
            }
            return $(document).trigger('validated', _this);
          });
        }
        return this._stashFileInput();
      };

      TaskConfigView.prototype._init_accordian = function() {
        this.ui.form_section_titles.prepend('<span class="expand">+ </span><span class="collapse">- <span> ');
        return this.ui.form_sections.hide();
      };

      TaskConfigView.prototype._toggleAccordian = function(e) {
        var $scope;
        $scope = $(e.target).closest('fieldset');
        $('.expand', $scope).toggle();
        $('.collapse', $scope).toggle();
        return $('ol', $scope).slideToggle('fast');
      };

      TaskConfigView.prototype._stashFileInput = function() {
        if (this.ui.file_inputs.length > 0) {
          $('.stashed-form-region').append(this.ui.file_inputs);
          return this.stashedFile = $('.stashed-form-region input:last-child');
        }
      };

      TaskConfigView.prototype._applyStashedFileInput = function(node) {
        var $placeholder, stashed_id;
        if ((this.stashedFile != null) && this.stashedFile.length > 0) {
          stashed_id = $(this.stashedFile).attr('id');
          if ($("#" + stashed_id, node).length === 0) {
            return $(node).append(this.stashedFile);
          } else {
            $placeholder = $("#" + stashed_id, node);
            $placeholder.before(this.stashedFile);
            return $placeholder.remove();
          }
        }
      };

      return TaskConfigView;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
