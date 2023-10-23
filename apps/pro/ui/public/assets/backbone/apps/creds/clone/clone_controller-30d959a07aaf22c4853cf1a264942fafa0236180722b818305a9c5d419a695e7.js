(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/creds/clone/clone_view'], function() {
    return this.Pro.module("CredsApp.Clone", function(Clone, App) {
      return Clone.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(opts) {
          var cred, credsCollection, regionName,
            _this = this;
          cred = opts.cred, credsCollection = opts.credsCollection, regionName = opts.regionName;
          this.layout = this.getLayoutView(cred, credsCollection);
          this.listenTo(this.layout, 'show', function() {
            _this.layout.dropContainingEl();
            _this.publicRegion(cred);
            _this.privateRegion(cred);
            _this.realmRegion(cred);
            return _this.typeRegion(cred);
          });
          return this.show(this.layout, {
            region: App[regionName]
          });
        };

        Controller.prototype.publicRegion = function(cred) {
          var publicView;
          publicView = this.getPublicView(cred);
          return this.layout.publicRegion.show(publicView);
        };

        Controller.prototype.privateRegion = function(cred) {
          var privateView;
          privateView = this.getPrivateView(cred);
          return this.layout.privateRegion.show(privateView);
        };

        Controller.prototype.realmRegion = function(cred) {
          var realmView;
          realmView = this.getRealmView(cred);
          return this.layout.realmRegion.show(realmView);
        };

        Controller.prototype.typeRegion = function(cred) {
          var typeView;
          typeView = this.getTypeView(cred);
          return this.layout.typeRegion.show(typeView);
        };

        Controller.prototype.getLayoutView = function(cred, credsCollection) {
          return new Clone.Layout({
            model: cred,
            credsCollection: credsCollection
          });
        };

        Controller.prototype.getPublicView = function(cred) {
          return new Clone.Public({
            model: cred
          });
        };

        Controller.prototype.getPrivateView = function(cred) {
          return new Clone.Private({
            model: cred
          });
        };

        Controller.prototype.getRealmView = function(cred) {
          return new Clone.Realm({
            model: cred
          });
        };

        Controller.prototype.getTypeView = function(cred) {
          return new Clone.Type({
            model: cred
          });
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
