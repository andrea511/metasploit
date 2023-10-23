(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.WebPageFormView = (function(_super) {

      __extends(WebPageFormView, _super);

      function WebPageFormView() {
        this.uploadFile = __bind(this.uploadFile, this);

        this.editorChanged = __bind(this.editorChanged, this);

        this.fileChanged = __bind(this.fileChanged, this);
        return WebPageFormView.__super__.constructor.apply(this, arguments);
      }

      WebPageFormView.prototype.initialize = function() {
        var _this = this;
        this.configuring = false;
        this.dontRenderSelect2 = true;
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Loading... ',
          autoOpen: false,
          width: '700px',
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
        return WebPageFormView.__super__.initialize.apply(this, arguments);
      };

      WebPageFormView.prototype.events = _.extend({
        "click .clone-btn": 'showCloneDialog',
        "change [name=editor-buttonset]": 'editorChanged',
        "change li#social_engineering_web_page_template_id_input select": 'editorChanged',
        'scrollProxy': 'scrollProxy'
      }, PaginatedFormView.prototype.events);

      WebPageFormView.prototype.scrollProxy = function() {
        var $iframe;
        $iframe = $('.preview iframe', this.el);
        return $iframe.contents().scrollTop($('.blocker', this.el).scrollTop());
      };

      WebPageFormView.prototype.fileUrl = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/files/new?inline=true";
      };

      WebPageFormView.prototype.fileChanged = function(e) {
        var $selOption;
        $selOption = $('option:selected', e.target);
        if ($selOption.index() === 1) {
          this.beginFileSetup();
          return $selOption.parents('select').select2("val", "");
        }
      };

      WebPageFormView.prototype.editorChanged = function(e) {
        var $form, $iframe, $input, $inputs, $new_form, $preview, content, h, reverse, self, tmpl, url, val, _i, _len,
          _this = this;
        self = this;
        val = $('[name=editor-buttonset]:checked', this.el).val();
        h = $('.CodeMirror-scroll', this.el).height();
        $form = $('form', this.el).first();
        reverse = function(str) {
          return str.split("").reverse().join("");
        };
        content = reverse($form.triggerHandler('getMirrorContent'));
        $('.CodeMirror,.clone-btn', this.el).toggle(val === 'edit');
        $preview = $('.preview', this.el);
        $preview.toggle(val === 'preview');
        if (val === 'preview') {
          $iframe = $('.preview iframe', this.el);
          $iframe.css({
            width: '100%',
            border: '0'
          }).hide().height(h);
          tmpl = $('li#social_engineering_web_page_template_id_input select option:selected', this.el).val();
          url = $('meta[name=preview-url]', this.el).attr('content');
          $preview.addClass('loading').height(380).css({
            'min-height': '0'
          }).show().css({
            border: '1px solid #ddd'
          });
          $new_form = $("<form method='POST' style='display:none'></form>").appendTo($('body'));
          $new_form.attr('action', url);
          $new_form.attr('target', 'web-page-iframe');
          $inputs = [$('<input type="hidden" name="template_id"></input>'), $('<input type="hidden" name="content"></input>'), $('<input type="hidden" name="authenticity_token"></input>')];
          $inputs[0].val(tmpl);
          $inputs[1].val(content);
          $inputs[2].val($('meta[name=csrf-token]').attr('content'));
          for (_i = 0, _len = $inputs.length; _i < _len; _i++) {
            $input = $inputs[_i];
            $new_form.append($input);
          }
          $new_form.submit();
          return $iframe[0].onload = function() {
            var iframeWin;
            $('.preview', _this.el).show().removeClass('loading').css({
              height: 'auto'
            });
            h = $('.CodeMirror-scroll', _this.el).height();
            $iframe.show().height(h);
            $new_form.remove();
            $('.blocker', $form).height(h);
            iframeWin = $iframe[0].contentWindow || $iframe[0].contentWindow.parentWindow;
            if (iframeWin.document.body) {
              $('.blocker .spacer').height(iframeWin.document.documentElement.scrollHeight || iframeWin.document.body.scrollHeight);
            }
            return $('.blocker', _this.el).scroll(function() {
              return $(self.el).trigger('scrollProxy');
            });
          };
        }
      };

      WebPageFormView.prototype.showLoading = function() {
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

      WebPageFormView.prototype.showFileConfig = function() {
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

      WebPageFormView.prototype.uploadFile = function() {
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
              _this.configuring = {
                falsewidth: '430px'
              };
              file = jsonData['user_submitted_file'];
              $select = $("select[name='social_engineering_web_page[user_supplied_file]']", _this.el);
              $newOption = $("<option>").val(file.id).html(_.escape(file.name));
              $select.append($newOption);
              return $select.select2('val', file.id);
            }
          },
          error: function() {}
        });
        return this.showLoading();
      };

      WebPageFormView.prototype.beginFileSetup = function() {
        var url,
          _this = this;
        this.configuring = true;
        url = this.fileUrl();
        this.showLoading();
        return $(this.loadingModal).load(url, function() {
          return _this.showFileConfig();
        });
      };

      WebPageFormView.prototype.onLoad = function() {
        var $li, $opts;
        WebPageFormView.__super__.onLoad.apply(this, arguments);
        $opts = $("select[name='social_engineering_web_page[phishing_redirect_web_page_id]'] option");
        if ($opts.size() === 0 || ($opts.size() === 1 && $opts.eq(0).text() === '')) {
          $li = $opts.parents('li').first().addClass('ui-disabled');
          $li.after($('<div>').addClass('no-pages').text('You must create another Web Page to redirect to first.'));
        }
        $('select', this.el).select2($.extend({
          escapeMarkup: function(markup) {
            return markup;
          },
          formatSelection: function(state) {
            return _.escape(state['text']);
          },
          formatResult: function(state, container) {
            var img;
            if (state['id'] !== 'Upload a new file...') {
              return _.escape(state['text']);
            }
            img = '<img alt="+" style="vertical-align: middle; position: relative; bottom: 2px; right: 1px;" src="/assets/icons/silky/add-c06a52df3361df380a02a45159a0858d6f7cd8cbc3f71ff732a65d6c25ea6af6.png" />';
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
        $('.white-box.editor-box', this.el).buttonset();
        return $("select[name='social_engineering_web_page[user_supplied_file]']", this.el).change(this.fileChanged);
      };

      WebPageFormView.prototype.showCloneDialog = function() {
        return window.renderCloneDialog();
      };

      return WebPageFormView;

    })(PaginatedFormView);
  });

}).call(this);
