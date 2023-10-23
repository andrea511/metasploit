(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/shared/notification-center/backbone/views/layouts/notification_center_layout-b4a2c63ba75b1ccab313a9afb7487c3712934fa724377aec9c92a76ff76524f7.js'], function($, NotificationCenterLayout) {
    var NotificationCenterController;
    NotificationCenterController = (function(_super) {

      __extends(NotificationCenterController, _super);

      function NotificationCenterController() {
        return NotificationCenterController.__super__.constructor.apply(this, arguments);
      }

      NotificationCenterController.prototype.start = function() {
        var region;
        region = new Backbone.Marionette.Region({
          el: "#notification-center-region"
        });
        return region.show(new NotificationCenterLayout());
      };

      return NotificationCenterController;

    })(Backbone.Marionette.Controller);
    return new NotificationCenterController();
  });

}).call(this);
