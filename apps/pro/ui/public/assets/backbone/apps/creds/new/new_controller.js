(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_controller', 'apps/creds/new/new_view', 'apps/logins/new/new_view', 'lib/components/tags/new/new_controller', 'lib/components/tabs/tabs_controller', 'lib/components/file_input/file_input_controller', 'entities/service'], function() {
    return this.Pro.module("CredsApp.New", function(New, App, Backbone, Marionette, $, _) {
      New.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(opts) {
          var _this = this;
          if (opts == null) {
            opts = {};
          }
          this.model = App.request("new:cred:entity");
          this.tableCollection = opts.tableCollection;
          this.setMainView(new New.Layout({
            model: this.model
          }));
          this.listenTo(this.getMainView(), 'type:selected', function(obj) {
            var collection, model, view;
            collection = obj.collection, model = obj.model, view = obj.view;
            if ($(':checked', view.ui.cred_type).val() === "import") {
              return _this.showImportCred();
            } else {
              return _this.showManualCred();
            }
          });
          return this.listenTo(this.getMainView(), "show", function() {
            _this.showManualCred();
            _this.showTagging();
            return typeof _this.hideTypes === "function" ? _this.hideTypes() : void 0;
          });
        };

        Controller.prototype.showTagging = function() {
          var collection, msg, query, url;
          msg = App.request('new:cred:entity').get('taggingModalHelpContent');
          query = "";
          url = this.model.tagUrl();
          collection = new Backbone.Collection([]);
          this.tagController = App.request('tags:new:component', collection, {
            q: query,
            url: url,
            content: msg
          });
          return this.show(this.tagController, {
            region: this._mainView.tags
          });
        };

        Controller.prototype.showImportCred = function() {
          var _this = this;
          this.importView = new New.Import({
            model: this.model
          });
          this.listenTo(this.importView, 'show', function() {
            var importFile, passwordImportFile, usernameImportFile;
            importFile = App.request('file_input:component');
            usernameImportFile = App.request('file_input:component', {
              name: 'file_input[username]',
              id: 'username'
            });
            passwordImportFile = App.request('file_input:component', {
              name: 'file_input[password]',
              id: 'password'
            });
            _this.show(importFile, {
              region: _this.importView.fileInput
            });
            _this.show(usernameImportFile, {
              region: _this.importView.userFileInput
            });
            return _this.show(passwordImportFile, {
              region: _this.importView.passFileInput
            });
          });
          return this.show(this.importView, {
            region: this._mainView.formContainer
          });
        };

        Controller.prototype.showManualCred = function() {
          this.tabController = App.request('tabs:component', this.getTabConfig(this.model));
          return this.show(this.tabController, {
            region: this._mainView.formContainer
          });
        };

        Controller.prototype.getTabConfig = function() {
          return {
            tabs: [
              {
                name: 'Realm',
                view: New.Realm,
                model: this.model
              }, {
                name: 'Public',
                view: New.Public,
                model: this.model
              }, {
                name: 'Private',
                view: New.Private,
                model: this.model
              }
            ]
          };
        };

        Controller.prototype.onFormSubmit = function() {
          var credType, data, defer, fileType, formSubmit, iframeSaveOptions, saveOptions, usingFileInput,
            _this = this;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          this.model.set('tags', this.tagController.getDataOptions());
          this.model.unset('errors');
          credType = $(':checked', this._mainView.ui.cred_type).val();
          usingFileInput = (this.importView != null) && (this.importView.fileInput != null);
          saveOptions = {
            complete: function(data) {
              var error, error_tabs, errors, index, parsedData, _i, _len;
              parsedData = data.responseJSON;
              if (parsedData.success) {
                defer.resolve();
                if (usingFileInput) {
                  return App.vent.trigger('creds:imported', _this.tableCollection);
                } else {
                  return App.vent.trigger('cred:added', _this.tableCollection);
                }
              } else {
                errors = parsedData.error;
                if (parsedData.error.input) {
                  _.extend(errors, {
                    file_input: {
                      data: parsedData.error.input.first()
                    }
                  });
                }
                _this.model.set('errors', errors);
                if (!usingFileInput) {
                  _this.tabController.resetValidTabs();
                  error_tabs = [];
                  for (index = _i = 0, _len = errors.length; _i < _len; index = ++_i) {
                    error = errors[index];
                    if (_.size(error[Object.keys(error)[0]]) > 0) {
                      error_tabs.push(index - 1);
                    }
                  }
                  return _this.tabController.setInvalidTabs(error_tabs);
                }
              }
            }
          };
          if (usingFileInput) {
            fileType = $(':checked', this.importView.ui.importType).val();
            data = this.model.attributes;
            data.authenticity_token = $('meta[name=csrf-token]').attr('content');
            data.cred_type = credType;
            data.iframe = true;
            if (fileType === 'csv' || fileType === 'pwdump') {
              iframeSaveOptions = {
                iframe: true,
                data: data,
                files: this.importView.fileInput.currentView.ui.file_input
              };
            } else {
              iframeSaveOptions = {
                iframe: true,
                data: data,
                files: $(".user-pass-file-input-region").find("input")
              };
            }
            _.extend(saveOptions, iframeSaveOptions);
          }
          this.model.save(_.extend(this.model.attributes, {
            cred_type: credType
          }), saveOptions);
          return formSubmit;
        };

        return Controller;

      })(App.Controllers.Application);
      New.LoginController = (function(_super) {

        __extends(LoginController, _super);

        function LoginController() {
          this._updateServiceForm = __bind(this._updateServiceForm, this);
          return LoginController.__super__.constructor.apply(this, arguments);
        }

        LoginController.prototype.hideTypes = function() {
          return this._mainView.hideCredTypes();
        };

        LoginController.prototype.showManualCred = function() {
          var _this = this;
          this.tabController = App.request('tabs:component', this.getTabConfig(this.model));
          this.loginLayout = new App.LoginsApp.New.Layout();
          this.listenTo(this.loginLayout, 'show', function() {
            _this.loginLayout.removeLoading();
            _this.loginLayout.removeTags();
            _this.loginFormView = new App.LoginsApp.New.Form({
              model: new Backbone.Model({
                hosts: {},
                services: {}
              })
            });
            _this.access_level_view = App.request("creds:accessLevel:view", {
              model: new Backbone.Model({
                access_level: 'Admin'
              }),
              save: false,
              showLabel: true
            });
            _this.listenTo(_this.loginFormView, 'show', function() {
              _this.updateServices();
              _this.loginFormView.hideHost();
              return _this.show(_this.access_level_view, {
                region: _this.loginFormView.accessLevelRegion
              });
            });
            return _this.show(_this.loginFormView, {
              region: _this.loginLayout.form
            });
          });
          this.show(this.loginLayout, {
            region: this._mainView.loginFormContainer
          });
          return this.show(this.tabController, {
            region: this._mainView.formContainer
          });
        };

        LoginController.prototype.updateServices = function() {
          this.host_id = HOST_ID;
          this.services = App.request("services:entities", {
            host_id: this.host_id
          });
          return this.services.fetch({
            reset: true
          }).then(this._updateServiceForm);
        };

        LoginController.prototype._updateServiceForm = function() {
          this.loginFormView.model.set('services', this.services.toJSON());
          this.loginFormView.render();
          this.loginFormView.hideHost();
          this.access_level_view = App.request("creds:accessLevel:view", {
            model: new Backbone.Model({
              access_level: 'Admin'
            }),
            save: false,
            showLabel: true
          });
          return this.show(this.access_level_view, {
            region: this.loginFormView.accessLevelRegion
          });
        };

        LoginController.prototype.onFormSubmit = function() {
          var data;
          $(':checked', this._mainView.ui.cred_type).val('login');
          data = Backbone.Syphon.serialize(this.loginLayout);
          this.model.set('login', data);
          return LoginController.__super__.onFormSubmit.apply(this, arguments);
        };

        return LoginController;

      })(New.Controller);
      return App.reqres.setHandler('creds:new', function(opts) {
        if (opts == null) {
          opts = {};
        }
        if (opts.login != null) {
          return new New.LoginController(opts);
        } else {
          return new New.Controller(opts);
        }
      });
    });
  });

}).call(this);
