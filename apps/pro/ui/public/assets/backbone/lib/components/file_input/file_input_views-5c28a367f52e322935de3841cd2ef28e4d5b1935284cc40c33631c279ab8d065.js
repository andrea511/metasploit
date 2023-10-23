(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view', 'base_itemview', 'base_layout', 'apps/creds/new/templates/new_layout', 'lib/components/file_input/templates/file_input'], function() {
    return this.Pro.module('Components.FileInput', function(FileInput, App, Backbone, Marionette, $, _) {
      return FileInput.Input = (function(_super) {

        __extends(Input, _super);

        function Input() {
          this.onRender = __bind(this.onRender, this);
          return Input.__super__.constructor.apply(this, arguments);
        }

        Input.prototype.template = Input.prototype.templatePath('file_input/file_input');

        Input.prototype.className = 'data file input';

        Input.prototype.tagName = 'li';

        Input.prototype.ui = {
          file_input: '[type="file"]',
          file_label: 'label p'
        };

        Input.prototype.events = {
          'change input:file': 'changed'
        };

        Input.prototype.triggers = {
          'change @ui.file_input': 'file:changed'
        };

        Input.prototype.resetLabel = function() {
          var path, _ref;
          this.bindUIElements();
          path = (_ref = this.ui.file_input.val()) != null ? _ref.replace(/.*(\\|\/)/g, '') : void 0;
          if (path === '') {
            path = "No file selected...";
          }
          this.fileSet = false;
          return this.ui.file_label.text(path);
        };

        Input.prototype.clearInput = function() {
          this.ui.file_input.wrap('<form>').parent('form').trigger('reset');
          this.ui.file_input.unwrap();
          return this.resetLabel();
        };

        Input.prototype.changed = function(e) {
          var $p, path;
          $p = $('label p', this.$el);
          path = $(e.target).val().replace(/.*(\\|\/)/g, '');
          if (path && path.length > 0) {
            this.fileSet = true;
            return $p.text(path);
          } else {
            this.fileSet = false;
            this.ui.file_input.wrap('<form>').parent('form').trigger('reset');
            this.ui.file_input.unwrap();
            return $p.html(this.setFileText($('input', this.$el).attr('id')));
          }
        };

        Input.prototype.onRender = function() {
          var that;
          that = this;
          return $('input:file', this.el).each(function() {
            var $label, $p, $span, origText;
            $label = $(this).prev();
            origText = $label.text() || 'file';
            $(this).attr('size', '50').css({
              overflow: 'hidden'
            });
            $p = $('<p>').text(that.setFileText($(this).attr('id')));
            $span = $('<span>').text("Choose " + origText + "...");
            $label.html('').append($p).append($span);
            return $(this).change(function() {
              var path;
              path = $(this).val().replace(/.*(\\|\/)/g, '');
              if (path && path.length > 0) {
                return $p.text(path);
              } else {
                return $p.html('&nbsp;');
              }
            });
          });
        };

        Input.prototype.isFileSet = function() {
          return this.fileSet;
        };

        Input.prototype.setFileText = function(attr) {
          var idSpecificText;
          idSpecificText = attr.split('_', 2)[0];
          if (idSpecificText !== "file") {
            idSpecificText = "" + idSpecificText + " file";
          }
          return "No " + idSpecificText + " selected...";
        };

        return Input;

      })(App.Views.ItemView);
    });
  });

}).call(this);
