(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lib/components/loading/loading_controller'], function(StartLoadingModule) {
    return this.Pro.module("Controllers", function(Controllers, App) {
      Controllers.Application = (function(_super) {

        __extends(Application, _super);

        function Application(options) {
          if (options == null) {
            options = {};
          }
          this.region = options.region || App.request("default:region");
          Application.__super__.constructor.call(this, options);
          this._instance_id = _.uniqueId("controller");
          App.execute("register:instance", this, this._instance_id);
        }

        Application.prototype.destroy = function() {
          App.execute("unregister:instance", this, this._instance_id);
          return Application.__super__.destroy.apply(this, arguments);
        };

        Application.prototype.show = function(view, options) {
          var _ref;
          if (options == null) {
            options = {};
          }
          _.defaults(options, {
            loading: false,
            region: this.region
          });
          view = view.getMainView ? view.getMainView() : view;
          if (!view) {
            throw new Error("getMainView() did not return a view instance or " + (view != null ? (_ref = view.constructor) != null ? _ref.name : void 0 : void 0) + " is not a view instance");
          }
          this.setMainView(view);
          return this._manageView(view, options);
        };

        Application.prototype.getMainView = function() {
          return this._mainView;
        };

        Application.prototype.setMainView = function(view) {
          if (this._mainView) {
            return;
          }
          this._mainView = view;
          return this.listenTo(view, "destroy", this.destroy);
        };

        Application.prototype._manageView = function(view, options) {
          if (options.loading) {
            return App.execute("show:loading", view, options);
          } else {
            return options.region.show(view, options);
          }
        };

        Application.prototype.mergeDefaultsInto = function(obj) {
          obj = _.isObject(obj) ? obj : {};
          return _.defaults(obj, this._getDefaults());
        };

        Application.prototype._getDefaults = function() {
          return _.clone(_.result(this, "defaults"));
        };

        return Application;

      })(Marionette.Controller);
      return StartLoadingModule();
    });
  });

}).call(this);
