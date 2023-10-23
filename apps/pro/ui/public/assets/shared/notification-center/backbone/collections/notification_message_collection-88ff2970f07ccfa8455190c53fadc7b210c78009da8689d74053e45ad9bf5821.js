(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/shared/notification-center/backbone/models/notification_message_model-3dc5da8081aaf46bc9e5b710e4b09aa0f18877ed73effff067b1fc8209975128.js', 'jquery'], function(NotificationMessage, $) {
    var NotificationMessageCollection;
    return NotificationMessageCollection = (function(_super) {

      __extends(NotificationMessageCollection, _super);

      function NotificationMessageCollection() {
        this.myDataFilter = __bind(this.myDataFilter, this);

        this.sync = __bind(this.sync, this);
        return NotificationMessageCollection.__super__.constructor.apply(this, arguments);
      }

      NotificationMessageCollection.prototype.model = NotificationMessage;

      NotificationMessageCollection.prototype.url = "" + (Routes.notifications_messages_path()) + ".json";

      NotificationMessageCollection.prototype.sync = function(meth, coll, opts) {
        var oldSuccess, xhr;
        oldSuccess = opts.success;
        opts.success = function(resp) {
          try {
            return resp = $.parseJSON(resp);
          } catch (e) {

          } finally {
            if (oldSuccess != null) {
              oldSuccess.call(this, resp);
            }
          }
        };
        opts.data || (opts.data = {});
        opts.data['workspace_id'] = window.WORKSPACE_ID;
        return xhr = NotificationMessageCollection.__super__.sync.call(this, meth, coll, $.extend({}, opts, {
          dataFilter: this.myDataFilter
        }));
      };

      NotificationMessageCollection.prototype.myDataFilter = function(data, type) {
        var json;
        try {
          json = $.parseJSON(data);
          if ((json != null ? json.messages : void 0) != null) {
            $(document).trigger('updateBadges', json);
            return JSON.stringify(json.messages);
          }
        } catch (e) {

        }
        return data;
      };

      return NotificationMessageCollection;

    })(Backbone.Collection);
  });

}).call(this);
