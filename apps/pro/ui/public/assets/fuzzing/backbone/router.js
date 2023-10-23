(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/fuzzing/backbone/controllers/fuzzing_frame_controller-cc54249f9d63956114f802cf481a72d742ccd5c29fb80800f501c39736d98eac.js'], function(FuzzingFrameController) {
    var Router;
    return Router = (function(_super) {

      __extends(Router, _super);

      function Router() {
        return Router.__super__.constructor.apply(this, arguments);
      }

      Router.prototype.initialize = function() {
        return this.fuzzing_frame_controller = new FuzzingFrameController;
      };

      Router.prototype.routes = {
        "request_collector": "request_collector",
        "fuzzing_frame": "fuzzing_frame"
      };

      Router.prototype.request_collector = function() {
        return this.fuzzing_frame_controller.showRequestCollector();
      };

      Router.prototype.fuzzing_frame = function() {
        return this.fuzzing_frame_controller.showFuzzingFrame();
      };

      return Router;

    })(Backbone.Marionette.AppRouter);
  });

}).call(this);
