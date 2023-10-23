(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.EmailFormView = (function(_super) {

      __extends(EmailFormView, _super);

      function EmailFormView() {
        this.fileChanged = __bind(this.fileChanged, this);

        this.uploadFile = __bind(this.uploadFile, this);
        return EmailFormView.__super__.constructor.apply(this, arguments);
      }

      EmailFormView.prototype.initialize = function(opts) {
        var _this = this;
        _.bindAll(this, 'targetListChanged', 'bindForm');
        this.configuring = false;
        this.campaignSummary = opts['campaignSummary'];
        this.dontRenderSelect2 = true;
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          maxHeight: 480,
          title: 'Loading... ',
          autoOpen: false,
          width: '430px',
          closeOnEscape: false,
          close: function() {
            return _.delay((function() {
              return _this.configuring = false;
            }), 300);
          },
          buttons: {
            "Cancel": function() {
              return $(this).dialog("close");
            },
            "Upload": this.uploadFile
          }
        });
        return EmailFormView.__super__.initialize.apply(this, arguments);
      };

      EmailFormView.prototype.uploadFile = function() {
        var _this = this;
        $.ajax({
          url: $('form', this.loadingModal).attr('action'),
          type: 'POST',
          files: $('form :file', this.loadingModal),
          data: $('form input,select,textarea', this.loadingModal).not(':file').serializeArray(),
          iframe: true,
          processData: false,
          success: function(data, status) {
            var $newOption, $select, file, jsonData, saveStatus;
            _this.loadingModal.html(data);
            saveStatus = $('meta[name=save-status]', _this.loadingModal).attr('content');
            if (saveStatus === 'false' || !saveStatus) {
              return _this.showFileConfig();
            } else {
              jsonData = $.parseJSON(saveStatus);
              _this.loadingModal.dialog('close');
              _this.configuring = false;
              file = jsonData['user_submitted_file'];
              $select = $("select[name='social_engineering_email[user_supplied_file]']", _this.el);
              $newOption = $("<option>").val(file.id).html(_.escape(file.name));
              $select.append($newOption);
              return $select.select2('val', file.id);
            }
          },
          error: function() {}
        });
        return this.showLoading();
      };

      EmailFormView.prototype.beginFileSetup = function() {
        var url,
          _this = this;
        this.configuring = true;
        url = this.fileUrl();
        this.showLoading();
        return $(this.loadingModal).load(url, function() {
          return _this.showFileConfig();
        });
      };

      EmailFormView.prototype.fileUrl = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/files/new?inline=true";
      };

      EmailFormView.prototype.fileChanged = function(e) {
        var $selOption;
        $selOption = $('option:selected', e.target);
        if ($selOption.index() === 1) {
          this.beginFileSetup();
          return $selOption.parents('select').select2("val", "");
        }
      };

      EmailFormView.prototype.showFileConfig = function() {
        this.loadingModal.dialog('close');
        this.loadingModal.dialog({
          title: 'Upload a new file',
          width: '700px'
        });
        this.loadingModal.css({
          'max-height': '450px'
        });
        this.loadingModal.removeClass('loading');
        $('.ui-dialog-titlebar-close', this.loadingModal.parents('.ui-dialog')).show();
        this.loadingModal.dialog('open');
        return $('.ui-dialog-buttonpane', this.loadingModal.parents('.ui-dialog')).show();
      };

      EmailFormView.prototype.targetListUrl = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/target_lists/new.html?inline=true";
      };

      EmailFormView.prototype.targetListChanged = function(e) {
        var $selOption;
        $selOption = $('option:selected', e.target);
        if ($selOption.index() === 1) {
          this.beginTargetListSetup();
          return $selOption.parents('select').select2("val", "");
        }
      };

      EmailFormView.prototype.showLoading = function() {
        this.loadingModal.dialog('close');
        this.loadingModal.dialog({
          width: '430px',
          title: 'Loading...'
        });
        $('.ui-dialog-titlebar-close', this.loadingModal.parents('.ui-dialog')).hide();
        this.loadingModal.html('<div class="loading"></div>');
        this.loadingModal.dialog('open');
        return $('.ui-dialog-buttonpane', this.loadingModal.parents('.ui-dialog')).hide();
      };

      EmailFormView.prototype.showTargetListConfig = function(dontBind) {
        var _this = this;
        if (dontBind == null) {
          dontBind = false;
        }
        this.loadingModal.dialog('close');
        this.loadingModal.dialog({
          title: 'New Target List',
          width: '700px'
        });
        this.loadingModal.css({
          'max-height': '450px'
        });
        this.loadingModal.removeClass('loading');
        $('.ui-dialog-titlebar-close', this.loadingModal.parents('.ui-dialog')).show();
        this.loadingModal.dialog('open');
        $('.ui-dialog-buttonpane', this.loadingModal.parents('.ui-dialog')).hide();
        if (!dontBind) {
          return _.delay((function() {
            return _this.bindForm();
          }), 0);
        }
      };

      EmailFormView.prototype.beginTargetListSetup = function() {
        var url,
          _this = this;
        this.configuring = true;
        url = this.targetListUrl();
        this.showLoading();
        return $(this.loadingModal).load(url, function() {
          return _this.showTargetListConfig();
        });
      };

      EmailFormView.prototype.bindForm = function() {
        var _this = this;
        window.renderTargets();
        $('a.save-targets').click(function(e) {
          $('form', _this.loadingModal).first().submit();
          return e.preventDefault();
        });
        return $('form', this.loadingModal).first().submit(function(e) {
          e.preventDefault();
          $('form', _this.loadingModal).hide();
          $('.target-list-new>div.full_errors', _this.loadingModal).remove();
          $.ajax({
            url: $(e.target).attr('action'),
            type: 'POST',
            files: $('form :file', _this.loadingModal),
            data: $('form input,select,textarea', _this.loadingModal).not(':file').serializeArray(),
            iframe: true,
            processData: false,
            success: function(data, status) {
              var $newOption, $sandbox, $select, jsonData, saveStatus, targetList;
              $sandbox = $('<div style="display:none">').appendTo($('body'));
              $sandbox.html(data);
              saveStatus = $('meta[name=save-status]', $sandbox).attr('content');
              if (saveStatus === 'false' || !saveStatus) {
                $('.loading', _this.loadingModal).remove();
                $('form', _this.loadingModal).show();
                $('#errorExplanation', $sandbox).parent().addClass('full_errors').prependTo($('.target-list-new', _this.loadingModal));
                return _this.showTargetListConfig(true);
              } else {
                jsonData = $.parseJSON(saveStatus);
                _this.loadingModal.dialog('close');
                _this.configuring = false;
                targetList = jsonData['target_list'];
                $select = $("select[name='social_engineering_email[target_list_id]']");
                $newOption = $("<option>").val(targetList.id).html(_.escape(targetList.name));
                $select.append($newOption);
                return $select.select2('val', targetList.id);
              }
            },
            error: function() {}
          });
          _this.loadingModal.dialog('close');
          _this.loadingModal.dialog({
            width: '430px',
            title: 'Loading...'
          });
          _this.loadingModal.append($('<div class="loading"></div>'));
          return _this.loadingModal.dialog('open');
        });
      };

      EmailFormView.prototype.close = function() {
        if (this.configuring) {
          return;
        }
        return EmailFormView.__super__.close.apply(this, arguments);
      };

      EmailFormView.prototype.page = function(idx) {
        EmailFormView.__super__.page.apply(this, arguments);
        if (idx === 1) {
          return $('.editor-box input[type=radio]', this.el).change();
        }
      };

      EmailFormView.prototype.onLoad = function() {
        EmailFormView.__super__.onLoad.apply(this, arguments);
        $('fieldset.inputs', this.el).css('float', 'none');
        $('input[type=checkbox],input[type=radio]', this.el).css('vertical-align', 'baseline');
        $("select[name='social_engineering_email[target_list_id]']", this.el).change(this.targetListChanged);
        $('.white-box.editor-box', this.el).buttonset();
        $('select', this.el).select2($.extend({
          escapeMarkup: function(markup) {
            return markup;
          },
          formatSelection: function(state) {
            return _.escape(state['text']);
          },
          formatResult: function(state, container) {
            var img;
            if (!(state['id'] === 'Create a new Target List...' || state['id'] === 'Upload a new file...')) {
              return _.escape(state['text']);
            }
            img = '<img style="vertical-align: middle; position: relative;bottom: 2px; right: 1px;" alt="+" src="/assets/icons/silky/add-c06a52df3361df380a02a45159a0858d6f7cd8cbc3f71ff732a65d6c25ea6af6.png" />';
            $(container).css({
              'border-bottom': '1px dotted #ccc'
            });
            $(container).css({
              'border-top': '1px dotted #ccc'
            });
            $(container).css({
              'margin-bottom': '4px'
            });
            $(container).css({
              'padding-bottom': '8px'
            });
            $(container).css({
              'padding-top': '8px'
            });
            return img + state['text'];
          }
        }, DEFAULT_SELECT2_OPTS));
        $("select[name='social_engineering_email[user_supplied_file]']", this.el).change(this.fileChanged);
        window.renderAttributeDropdown();
        window.renderCodeMirror();
        return window.renderEmailEdit();
      };

      return EmailFormView;

    })(PaginatedFormView);
  });

}).call(this);
