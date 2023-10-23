(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/brute_force_guess/index/index_views', 'apps/brute_force_guess/quick/quick_controller'], function() {
    return this.Pro.module("BruteForceGuessApp.Index", function(Index, App) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var mutationModel, payloadModel, show, taskChain,
            _this = this;
          _.defaults(options, {
            show: true,
            taskChain: false
          });
          show = options.show, taskChain = options.taskChain, payloadModel = options.payloadModel, mutationModel = options.mutationModel;
          this.layout = new Index.Layout();
          this.setMainView(this.layout);
          this.listenTo(this._mainView, 'show', function() {
            _this.quickBruteforce = new Pro.BruteForceGuessApp.Quick.Controller({
              taskChain: taskChain,
              payloadModel: payloadModel,
              mutationModel: mutationModel
            });
            return _this.show(_this.quickBruteforce, {
              region: _this._mainView.contentRegion
            });
          });
          if (show) {
            return this.show(this._mainView);
          }
        };

        Controller.prototype.getPayloadSettings = function() {
          return this.quickBruteforce.payloadModel;
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
