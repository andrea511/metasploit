(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/logins/new/new_view', 'lib/components/tags/new/new_controller', 'apps/creds/show/show_view', 'entities/service', 'entities/host'], function() {
    return this.Pro.module("LoginsApp.New", function(New, App, Backbone, Marionette, $, _) {
      New.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this._updateServiceForm = __bind(this._updateServiceForm, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(core_id) {
          var _this = this;
          this.core_id = core_id;
          this.hosts = App.request("hosts:entities:limited", {}, {
            workspace_id: WORKSPACE_ID
          });
          this.access_level_view = App.request("creds:accessLevel:view", {
            model: new Backbone.Model({
              access_level: 'Admin'
            }),
            save: false,
            showLabel: true
          });
          this.formView = new New.Form({
            model: new Backbone.Model({
              hosts: {},
              services: {}
            })
          });
          this.setMainView(new New.Layout());
          this.listenTo(this.hosts, "reset", function() {
            _this._mainView.removeLoading();
            _this.formView.model.set('hosts', _this.hosts.toJSON());
            _this.formView.render();
            _this.formView.updateService();
            _this.access_level_view = App.request("creds:accessLevel:view", {
              model: _this.access_level_view.model,
              save: false,
              showLabel: true
            });
            return _this.show(_this.access_level_view, {
              region: _this.formView.accessLevelRegion,
              preventDestroy: true
            });
          });
          this.listenTo(this.formView, "updateServices", function(args) {
            return _this.updateServices(args);
          });
          return this.listenTo(this._mainView, 'show', function() {
            this.show(this.formView, {
              region: this._mainView.form,
              preventDestroy: true
            });
            this.showTagging();
            return this.hosts.fetch({
              reset: true
            });
          });
        };

        Controller.prototype.showTagging = function() {
          var collection, msg, query, url;
          msg = "<p>\n  A tag is an identifier that you can use to group together logins.\n  You apply tags so that you can easily search for logins.\n  For example, when you search for a particular tag, any login that\n  is labelled with that tag will appear in your search results.\n</p>\n<p>\n  To apply a tag, start typing the name of the tag you want to use in the\n  Tag field. As you type in the search box, Metasploit automatically predicts\n  the tags that may be similar to the ones you are searching for. If the tag\n  does not exist, Metasploit creates and adds it to the project.\n</p>";
          query = "";
          url = "";
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

        Controller.prototype.updateServices = function(args) {
          this.$viewEl = args.view.$el;
          this.host_id = $('select.host', this.$viewEl).val();
          this.services = App.request("services:entities", {
            host_id: this.host_id
          });
          return this.services.fetch({
            reset: true
          }).then(this._updateServiceForm);
        };

        Controller.prototype._updateServiceForm = function() {
          this.formView.model.set('services', this.services.toJSON());
          this.formView.render();
          this.access_level_view = App.request("creds:accessLevel:view", {
            model: this.access_level_view.model,
            save: false,
            showLabel: true
          });
          this.show(this.access_level_view, {
            region: this.formView.accessLevelRegion,
            preventDestroy: true
          });
          return $('select.host', this.$viewEl).val(this.host_id);
        };

        Controller.prototype.onFormSubmit = function() {
          var data, defer, formSubmit,
            _this = this;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          data = Backbone.Syphon.serialize(this._mainView);
          this.loginModel = App.request("new:login:entity", data);
          this.loginModel.set('tags', this.tagController.getDataOptions());
          this.loginModel.unset('errors');
          this.loginModel.set('core_id', this.core_id);
          this.loginModel.save({}, {
            success: function() {
              defer.resolve();
              return App.vent.trigger('login:added');
            },
            error: function(login, response) {
              var errors;
              errors = $.parseJSON(response.responseText).error;
              _this.loginModel.set('errors', errors);
              return _this._mainView.updateErrors(errors);
            }
          });
          return formSubmit;
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('logins:new', function(core_id) {
        return new New.Controller(core_id);
      });
    });
  });

}).call(this);
