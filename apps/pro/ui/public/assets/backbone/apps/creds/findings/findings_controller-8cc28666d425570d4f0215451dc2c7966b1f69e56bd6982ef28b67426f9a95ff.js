(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/creds/findings/findings_view'], function() {
    return this.Pro.module("CredsApp.Findings", function(Findings, App) {
      Findings.PrivateController = (function(_super) {

        __extends(PrivateController, _super);

        function PrivateController() {
          return PrivateController.__super__.constructor.apply(this, arguments);
        }

        PrivateController.prototype.initialize = function(opts) {
          var itemView, model;
          model = opts.model;
          itemView = new Findings.Private({
            model: model
          });
          return this.setMainView(itemView);
        };

        return PrivateController;

      })(App.Controllers.Application);
      return Findings.RealmController = (function(_super) {

        __extends(RealmController, _super);

        function RealmController() {
          return RealmController.__super__.constructor.apply(this, arguments);
        }

        RealmController.prototype.initialize = function(opts) {
          var itemView, model;
          model = opts.model;
          itemView = new Findings.Realm({
            model: model
          });
          this.setMainView(itemView);
          this.listenTo(this._mainView, 'show:hover', function() {
            this.hoverView = new Findings.RealmHover({
              model: model
            });
            return this.show(this.hoverView, {
              region: this._mainView.hoverRegion
            });
          });
          return this.listenTo(this._mainView, 'hide:hover', function() {
            return this.hoverView.destroy();
          });
        };

        return RealmController;

      })(App.Controllers.Application);
    });
  });

}).call(this);
