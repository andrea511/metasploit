(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var NotificationMessage;
    return NotificationMessage = (function(_super) {

      __extends(NotificationMessage, _super);

      function NotificationMessage() {
        return NotificationMessage.__super__.constructor.apply(this, arguments);
      }

      NotificationMessage.prototype.urlRoot = Routes.notifications_messages_path();

      return NotificationMessage;

    })(Backbone.Model);
  });

}).call(this);
