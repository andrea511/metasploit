(function() {

  define(['jquery', '/assets/shared/notification-center/backbone/models/notification_message_model-3dc5da8081aaf46bc9e5b710e4b09aa0f18877ed73effff067b1fc8209975128.js'], function($, NotificationMessageModel) {
    return describe("NotificationMessageModel", function() {
      describe("Server Behavior", function() {
        beforeEach(function() {
          return this.server = sinon.fakeServer.create();
        });
        afterEach(function() {
          return this.server.restore();
        });
        it("should fire the change event", function() {
          var callback, notification;
          callback = sinon.spy();
          this.server.respondWith("GET", "/notifications/messages/413", [
            200, {
              "Content-Type": "application/json"
            }, '{"id":413, "title": "Test"}'
          ]);
          notification = new NotificationMessageModel({
            id: 413
          });
          notification.on("change", callback);
          notification.fetch();
          this.server.respond();
          expect(callback.called).toBeTruthy();
          return expect(callback.getCall(0).args[0].attributes).toEqual({
            id: 413,
            title: "Test"
          });
        });
        return it("should hit the correct RESTful Endpoint", function() {
          var notification, spy;
          notification = new NotificationMessageModel({
            id: 413
          });
          spy = sinon.spy($, 'ajax');
          notification.save({
            wait: true
          });
          expect(spy).toHaveBeenCalled();
          expect(spy.getCall(0).args[0].url).toEqual("/notifications/messages/413");
          return $.ajax.restore();
        });
      });
      return describe("Default Values", function() {
        return it("should have urlRoot set", function() {
          var notification;
          notification = new NotificationMessageModel();
          return expect(notification.urlRoot).toEqual('/notifications/messages');
        });
      });
    });
  });

}).call(this);
