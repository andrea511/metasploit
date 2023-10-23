(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view', 'base_itemview', 'base_layout', 'apps/creds/new/templates/new_layout', 'apps/creds/new/templates/realm', 'apps/creds/new/templates/public', 'apps/creds/new/templates/private', 'apps/creds/new/templates/import'], function() {
    return this.Pro.module('CredsApp.New', function(New, App, Backbone, Marionette, $, _) {
      New.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          this._renderErrors = __bind(this._renderErrors, this);
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('creds/new/new_layout');

        Layout.prototype.ui = {
          cred_type: '.cred-type',
          tag_container: '.tag-container',
          errors: '.core-errors'
        };

        Layout.prototype.triggers = {
          'change [name="cred_type"]': 'type:selected',
          'submit form': 'preventFormSubmit'
        };

        Layout.prototype.modelEvents = {
          'change:errors': 'updateErrors'
        };

        Layout.prototype.regions = {
          tags: '.tags',
          formContainer: '.form-container.cred',
          loginFormContainer: '.login-form-container'
        };

        Layout.prototype.hideCredTypes = function() {
          return this.ui.cred_type.css('visibility', 'hidden');
        };

        Layout.prototype.updateErrors = function(core, errors) {
          errors = _.filter(errors, function(error) {
            return error['core'] != null;
          });
          return this._renderErrors(errors);
        };

        Layout.prototype.preventFormSubmit = function(e) {
          return e.preventDefault();
        };

        Layout.prototype._renderErrors = function(errors) {
          var _this = this;
          $('.error', this.el).remove();
          if (!_.isEmpty(errors) && (errors[0]['core'] != null)) {
            return _.each(errors[0]['core'], function(v, k) {
              var $msg, error, _i, _len, _results;
              _results = [];
              for (_i = 0, _len = v.length; _i < _len; _i++) {
                error = v[_i];
                $msg = $('<div />', {
                  "class": 'error'
                }).text('The credential ' + error);
                _results.push(_this.ui.errors.append($msg));
              }
              return _results;
            });
          }
        };

        return Layout;

      })(App.Views.Layout);
      New.Realm = (function(_super) {

        __extends(Realm, _super);

        function Realm() {
          this._renderErrors = __bind(this._renderErrors, this);
          return Realm.__super__.constructor.apply(this, arguments);
        }

        Realm.prototype.template = Realm.prototype.templatePath("creds/new/realm");

        Realm.prototype.ui = {
          realmOptions: '#realm option',
          realm: "#realm",
          name: '#name',
          nameLabel: '[for="name"]'
        };

        Realm.prototype.events = {
          'change form': 'updateModel',
          'input form': 'updateModel',
          'change @ui.realm': 'typeChanged'
        };

        Realm.prototype.modelEvents = {
          'change:errors': 'updateErrors'
        };

        Realm.prototype.onShow = function() {
          Backbone.Syphon.deserialize(this, this.model.toJSON());
          return this.initUi();
        };

        Realm.prototype.onDestroy = function() {
          return this.updateModel();
        };

        Realm.prototype.updateModel = function() {
          var data;
          data = Backbone.Syphon.serialize(this);
          return this.model.set(data);
        };

        Realm.prototype.updateErrors = function(cred, errors) {
          errors = _.filter(errors, function(error) {
            return error['realm'] != null;
          });
          return this._renderErrors(errors);
        };

        Realm.prototype._renderErrors = function(errors) {
          var _this = this;
          $('.error', this.el).remove();
          if (!_.isEmpty(errors) && (errors[0]['realm'] != null)) {
            return _.each(errors[0]['realm'], function(v, k) {
              var $msg, error, name, _i, _len, _results;
              _results = [];
              for (_i = 0, _len = v.length; _i < _len; _i++) {
                error = v[_i];
                name = "realm[" + k + "]";
                $msg = $('<div />', {
                  "class": 'error'
                }).text(error);
                _results.push($("input[name='" + name + "']", _this.el).addClass('invalid').after($msg));
              }
              return _results;
            });
          }
        };

        Realm.prototype.initUi = function() {
          var e, _ref;
          if (((_ref = this.model.get('realm')) != null ? _ref.key : void 0) == null) {
            this.ui.realmOptions.first().attr('selected', 'selected');
            this.ui.name.addClass('invisible');
          } else {
            e = {};
            e.target = $(':selected', this.ui.realm);
            this.typeChanged(e);
            Backbone.Syphon.deserialize(this, this.model.toJSON());
          }
          return this.updateErrors(null, this.model.get('errors'));
        };

        Realm.prototype.typeChanged = function(e) {
          var selected;
          selected = $(e.target).val();
          if (selected === "None") {
            this.ui.name.addClass('invisible');
            return this.ui.nameLabel.addClass('invisible');
          } else {
            this.ui.name.removeClass('invisible');
            return this.ui.nameLabel.removeClass('invisible');
          }
        };

        return Realm;

      })(App.Views.ItemView);
      New.Import = (function(_super) {

        __extends(Import, _super);

        function Import() {
          return Import.__super__.constructor.apply(this, arguments);
        }

        Import.prototype.template = Import.prototype.templatePath("creds/new/import");

        Import.prototype.ui = {
          passwordType: '.password-type',
          importType: '.import-type',
          importTypeValue: '[name="import[type]"]',
          fileInputRegion: '.file-input-region',
          importSelect: '[name="import[password_type]"]',
          nonReplayableValue: '[value="non-replayable"]',
          sshValue: '[value="ssh"]'
        };

        Import.prototype.events = {
          'change form': 'updateModel',
          'change input': 'updateModel',
          'change [name="import[type]"]': 'updatePrivateType'
        };

        Import.prototype.modelEvents = {
          'change:errors': 'updateErrors'
        };

        Import.prototype.regions = {
          fileInput: '.file-input-region',
          userFileInput: '.user-file-input-region',
          passFileInput: '.pass-file-input-region'
        };

        Import.prototype.onShow = function() {
          Backbone.Syphon.deserialize(this, this.model.toJSON());
          window.Forms.renderHelpLinks(this.el);
          if (this.model.get('import').type === 'pwdump' || this.model.get('import').type === 'user_pass') {
            return this.ui.importTypeValue.trigger('change');
          }
        };

        Import.prototype.updateModel = function() {
          var data;
          data = Backbone.Syphon.serialize(this);
          return this.model.set(data);
        };

        Import.prototype.updatePrivateType = function(e) {
          var type;
          type = $(e.target).val();
          if (type === "user_pass") {
            $(this.ui.importSelect).find(this.ui.nonReplayableValue).prop('disabled', true);
            $(this.ui.importSelect).find(this.ui.sshValue).prop('disabled', true);
          } else {
            $(this.ui.importSelect).find(this.ui.nonReplayableValue).prop('disabled', false);
            $(this.ui.importSelect).find(this.ui.sshValue).prop('disabled', false);
          }
          if (type === "csv" || type === "user_pass") {
            this.ui.passwordType.css('visibility', 'visible');
          } else {
            this.ui.passwordType.css('visibility', 'hidden');
          }
          return this.updateFileInput(type);
        };

        Import.prototype.updateFileInput = function(type) {
          if (type === "csv" || type === "pwdump") {
            this.ui.fileInputRegion.css('display', 'inline');
            return $(".user-pass-file-input-region").css('display', 'none');
          } else {
            this.ui.fileInputRegion.css('display', 'none');
            return $(".user-pass-file-input-region").css('display', 'inline');
          }
        };

        Import.prototype.updateErrors = function(cred, errors) {
          var $msg;
          $('.error', this.el).remove();
          if (!_.isEmpty(errors) && (errors['file_input'] != null)) {
            if (errors['file_input']['data']) {
              $msg = $('<div />', {
                "class": 'error'
              }).text(errors['file_input']['data']);
              $("input[name='file_input[data]']", this.el).addClass('invalid').after($msg);
            }
            if (errors['file_input']['username']) {
              $msg = $('<div />', {
                "class": 'error'
              }).text(errors['file_input']['username']);
              $("input[name='file_input[username]']", this.el).addClass('invalid').after($msg);
            }
            if (errors['file_input']['password']) {
              $msg = $('<div />', {
                "class": 'error'
              }).text(errors['file_input']['password']);
              return $("input[name='file_input[password]']", this.el).addClass('invalid').after($msg);
            }
          }
        };

        return Import;

      })(App.Views.Layout);
      New.Public = (function(_super) {

        __extends(Public, _super);

        function Public() {
          this._renderErrors = __bind(this._renderErrors, this);
          return Public.__super__.constructor.apply(this, arguments);
        }

        Public.prototype.template = Public.prototype.templatePath("creds/new/public");

        Public.prototype.events = {
          'change form': 'updateModel',
          'input form': 'updateModel'
        };

        Public.prototype.modelEvents = {
          'change:errors': 'updateErrors'
        };

        Public.prototype.onShow = function() {
          Backbone.Syphon.deserialize(this, this.model.toJSON());
          return this.updateErrors(null, this.model.get('errors'));
        };

        Public.prototype.onDestroy = function() {
          return this.updateModel();
        };

        Public.prototype.updateModel = function() {
          var data;
          data = Backbone.Syphon.serialize(this);
          return this.model.set(data);
        };

        Public.prototype.updateErrors = function(cred, errors) {
          errors = _.filter(errors, function(error) {
            return error['public'] != null;
          });
          return this._renderErrors(errors);
        };

        Public.prototype._renderErrors = function(errors) {
          var _this = this;
          $('.error', this.el).remove();
          if (!_.isEmpty(errors) && (errors[0]['public'] != null)) {
            return _.each(errors[0]['public'], function(v, k) {
              var $msg, error, name, _i, _len, _results;
              _results = [];
              for (_i = 0, _len = v.length; _i < _len; _i++) {
                error = v[_i];
                name = "public[" + k + "]";
                $msg = $('<div />', {
                  "class": 'error'
                }).text(error);
                _results.push($("input[name='" + name + "']", _this.el).addClass('invalid').after($msg));
              }
              return _results;
            });
          }
        };

        return Public;

      })(App.Views.ItemView);
      return New.Private = (function(_super) {

        __extends(Private, _super);

        function Private() {
          this._renderErrors = __bind(this._renderErrors, this);
          return Private.__super__.constructor.apply(this, arguments);
        }

        Private.prototype.template = Private.prototype.templatePath("creds/new/private");

        Private.prototype.ui = {
          type: '#type',
          typeOptions: '#type option',
          options: '.option',
          data: '#data'
        };

        Private.prototype.events = {
          'change @ui.type': 'typeChanged',
          'change form': 'updateModel',
          'input form': 'updateModel'
        };

        Private.prototype.modelEvents = {
          'change:errors': 'updateErrors'
        };

        Private.prototype.onShow = function() {
          Backbone.Syphon.deserialize(this, this.model.toJSON());
          this.initUi();
          return this.updateErrors(null, this.model.get('errors'));
        };

        Private.prototype.onDestroy = function() {
          return this.updateModel();
        };

        Private.prototype.updateModel = function() {
          var data;
          data = Backbone.Syphon.serialize(this);
          return this.model.set(data);
        };

        Private.prototype.updateErrors = function(cred, errors) {
          errors = _.filter(errors, function(error) {
            return error['private'] != null;
          });
          return this._renderErrors(errors);
        };

        Private.prototype.initUi = function() {
          var _ref;
          if (((_ref = this.model.get('private')) != null ? _ref.type : void 0) == null) {
            this.ui.typeOptions.first().attr('selected', 'selected');
            return this.ui.data.addClass('invisible');
          } else {
            $(':selected', this.ui.type).change();
            return Backbone.Syphon.deserialize(this, this.model.toJSON());
          }
        };

        Private.prototype._renderErrors = function(errors) {
          var _this = this;
          $('.error', this.el).remove();
          if (!_.isEmpty(errors) && (errors[0]['private'] != null)) {
            return _.each(errors[0]['private'], function(v, k) {
              var $msg, error, name, _i, _len, _results;
              _results = [];
              for (_i = 0, _len = v.length; _i < _len; _i++) {
                error = v[_i];
                name = "private[" + k + "]";
                $msg = $('<div />', {
                  "class": 'error'
                }).text(error);
                _results.push($("[name='" + name + "']", _this.el).addClass('invalid').after($msg));
              }
              return _results;
            });
          }
        };

        Private.prototype.replaceWithInput = function(el) {
          var newEl;
          newEl = jQuery("<input>");
          newEl.attr('type', 'text').attr('id', 'data').attr('name', "private[data]");
          return $("#data").replaceWith(newEl);
        };

        Private.prototype.replaceWithTextArea = function() {
          var newEl;
          newEl = jQuery("<textarea>");
          newEl.attr('id', 'data').attr('name', "private[data]").attr('rows', '4');
          return $("#data").replaceWith(newEl);
        };

        Private.prototype.blankInput = function() {
          return jQuery("#data").addClass('invisible');
        };

        Private.prototype.typeChanged = function(e) {
          var selected;
          selected = $(e.target).val();
          this.ui.options.addClass('invisible');
          $(".option." + selected, this.el).removeClass('invisible');
          if (selected === "none") {
            this.ui.data = this.ui.data.addClass('invisible');
          } else {
            this.ui.data = this.ui.data.removeClass('invisible');
          }
          if (this.ui.type.val() === 'plaintext') {
            return this.replaceWithInput();
          } else if (this.ui.type.val() !== 'none') {
            return this.replaceWithTextArea();
          } else {
            return this.blankInput();
          }
        };

        return Private;

      })(App.Views.ItemView);
    });
  });

}).call(this);
