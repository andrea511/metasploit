(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_formview', 'apps/creds/clone/templates/clone_layout', 'apps/creds/clone/templates/public', 'apps/creds/clone/templates/private', 'apps/creds/new/templates/realm', 'apps/creds/clone/templates/type', 'lib/components/flash/flash_controller', 'lib/concerns/views/spinner'], function() {
    return this.Pro.module('CredsApp.Clone', function(Clone, App, Backbone, Marionette, $, _) {
      Clone.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.include("Spinner");

        Layout.prototype.template = Layout.prototype.templatePath('creds/clone/clone_layout');

        Layout.prototype.modelEvents = {
          'change:errors': 'renderErrors'
        };

        Layout.prototype.regions = {
          publicRegion: 'td.public',
          privateRegion: 'td.private',
          realmRegion: 'td.realm',
          typeRegion: 'td.type'
        };

        Layout.prototype.events = {
          'click a.save': 'onFormSubmit',
          'submit form': 'onFormSubmit',
          'click a.cancel': 'destroy'
        };

        Layout.prototype.initialize = function(options) {
          this.credsCollection = options.credsCollection;
          return Layout.__super__.initialize.call(this, options);
        };

        Layout.prototype.dropContainingEl = function() {
          this.setElement(this.$el.parent());
          return this.$el.html(this.$el.find('div').first().html());
        };

        Layout.prototype.onFormSubmit = function(e) {
          var _this = this;
          e.preventDefault();
          this.model.unset('errors');
          this.showSpinner();
          return this.model.save(_.extend(this.model.attributes, {
            cred_type: 'manual'
          }), {
            success: function() {
              App.vent.trigger('cred:added', _this.credsCollection);
              return _this.destroy();
            },
            error: function(cred, response) {
              var errors;
              _this.hideSpinner();
              errors = $.parseJSON(response.responseText).error;
              return _this.model.set('errors', errors);
            }
          });
        };

        Layout.prototype.renderErrors = function(cred, errors) {
          var _ref, _ref1;
          errors = (_ref = errors[0]) != null ? (_ref1 = _ref.core) != null ? _ref1.base : void 0 : void 0;
          if (errors !== void 0 && errors.length > 0) {
            return _.each(errors, function(error) {
              return App.execute('flash:display', {
                title: 'Credential not saved',
                style: 'error',
                message: "The credential " + error,
                duration: 5000
              });
            });
          }
        };

        return Layout;

      })(App.Views.Layout);
      Clone.Public = (function(_super) {

        __extends(Public, _super);

        function Public() {
          return Public.__super__.constructor.apply(this, arguments);
        }

        Public.prototype.template = Public.prototype.templatePath('creds/clone/public');

        Public.prototype.nestedAttributeName = 'public';

        Public.prototype.onShow = function() {
          Public.__super__.onShow.call(this);
          return this.$(":text:visible:enabled:first").select();
        };

        return Public;

      })(App.Views.FormView);
      Clone.Private = (function(_super) {

        __extends(Private, _super);

        function Private() {
          return Private.__super__.constructor.apply(this, arguments);
        }

        Private.prototype.template = Private.prototype.templatePath('creds/clone/private');

        Private.prototype.nestedAttributeName = 'private';

        Private.prototype.updateModel = function() {
          var data, _ref;
          data = Backbone.Syphon.serialize(this);
          data["private"].type = (_ref = this.model.attributes["private"]) != null ? _ref.type : void 0;
          return this.model.set(data);
        };

        return Private;

      })(App.Views.FormView);
      Clone.Realm = (function(_super) {

        __extends(Realm, _super);

        function Realm() {
          return Realm.__super__.constructor.apply(this, arguments);
        }

        Realm.prototype.template = Realm.prototype.templatePath('creds/new/realm');

        Realm.prototype.initialize = function(opts) {
          return _.extend(this.ui, {
            realmKeySelect: '#realm'
          });
        };

        Realm.prototype.nestedAttributeName = 'realm';

        Realm.prototype.onShow = function() {
          var _ref;
          if (!((_ref = this.model.attributes.realm) != null ? _ref.key : void 0)) {
            this.ui.realmKeySelect.val('None');
            this.model.get('realm').key = 'None';
          }
          return Realm.__super__.onShow.call(this);
        };

        return Realm;

      })(App.Views.FormView);
      return Clone.Type = (function(_super) {

        __extends(Type, _super);

        function Type() {
          return Type.__super__.constructor.apply(this, arguments);
        }

        Type.prototype.template = Type.prototype.templatePath('creds/clone/type');

        Type.prototype.nestedAttributeName = 'private';

        Type.prototype.updateModel = function() {
          var data, _ref;
          data = Backbone.Syphon.serialize(this);
          data["private"].data = (_ref = this.model.attributes["private"]) != null ? _ref.data : void 0;
          return this.model.set(data);
        };

        return Type;

      })(App.Views.FormView);
    });
  });

}).call(this);
