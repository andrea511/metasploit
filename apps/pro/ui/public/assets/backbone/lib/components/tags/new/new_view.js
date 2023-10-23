(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'lib/components/tags/new/templates/tag_form_layout', 'base_view', 'base_itemview', 'base_layout', 'css!css/components/tags/new', '/assets/jquery.tokeninput-967a3a6cea335c7437dfcd702c96692ceca5ce17cb0c075fb10578f754fcb141.js'], function($, Template, TokenInput, ModalForm) {
    return this.Pro.module('Components.Tags.New', function(New, App, Backbone, Marionette, $, _) {
      return New.TagForm = (function(_super) {

        __extends(TagForm, _super);

        function TagForm() {
          this._showError = __bind(this._showError, this);

          this._removeError = __bind(this._removeError, this);

          this._nameField = __bind(this._nameField, this);

          this.onShow = __bind(this.onShow, this);

          this.focus = __bind(this.focus, this);

          this.serialize = __bind(this.serialize, this);
          return TagForm.__super__.constructor.apply(this, arguments);
        }

        TagForm.prototype.template = TagForm.prototype.templatePath('tags/new/tag_form_layout');

        TagForm.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          this.model.set('informationAssetTag', '<img src="/assets/icons/silky/information-c0210a97250ec34cc04d6c8ff768012bf9e054abe33c7fcc558f65bf57a1661a.png" />');
          $.extend(this, opts);
          return TagForm.__super__.initialize.apply(this, arguments);
        };

        TagForm.prototype.serialize = function() {
          return this;
        };

        TagForm.prototype.focus = function() {
          return this.$el.find('input:visible').focus();
        };

        TagForm.prototype.onShow = function() {
          var nameField, route, wid, _ref,
            _this = this;
          nameField = this._nameField();
          wid = this.workspace_id || window.WORKSPACE_ID;
          route = Routes.search_workspace_tags_path(wid, {
            format: 'json'
          });
          if (nameField.data('tokenInputObject') == null) {
            this.tokenInput = nameField.tokenInput(route, {
              theme: "metasploit",
              hintText: "Type in a tag name...",
              searchingText: "Searching tags...",
              allowCustomEntry: true,
              preventDuplicates: true,
              allowFreeTagging: true,
              resultsLimit: 3,
              tokenValue: (_ref = this.tokenValue) != null ? _ref : 'id',
              onAdd: function() {
                return _this.trigger('token:changed');
              },
              onRemove: function() {
                return _this.trigger('token:changed');
              }
            });
          }
          return window.Forms.renderHelpLinks(this.el);
        };

        TagForm.prototype._nameField = function() {
          return $('[name=name]', this.el);
        };

        TagForm.prototype._removeError = function() {
          return $('form .error-box', this.el).remove();
        };

        TagForm.prototype._showError = function(err) {
          var $errDiv;
          this._removeError();
          $errDiv = $('<div />', {
            "class": 'error-box'
          });
          err = err.substr(err.indexOf(" ") + 1);
          $errDiv.text(err);
          return $('form', this.el).prepend($errDiv);
        };

        return TagForm;

      })(App.Views.Layout);
    });
  });

}).call(this);
