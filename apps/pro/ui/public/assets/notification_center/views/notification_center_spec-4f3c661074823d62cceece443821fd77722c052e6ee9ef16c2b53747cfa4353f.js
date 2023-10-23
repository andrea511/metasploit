(function() {

  define(['jquery', '/assets/shared/notification-center/backbone/views/layouts/notification_center_layout-b4a2c63ba75b1ccab313a9afb7487c3712934fa724377aec9c92a76ff76524f7.js'], function($, NotificationCenterLayout) {
    return describe('Notificationcenter', function() {
      return describe('Views', function() {
        return describe('NotificationCenterLayout', function() {
          beforeEach(function() {
            return this.region = new Backbone.Marionette.Region({
              el: '#notification-center-region'
            });
          });
          it("should instantiate", function() {
            return expect(this.region.el).toEqual('#notification-center-region');
          });
          describe('Rendering', function() {
            beforeEach(function() {
              var result;
              this.server = sinon.fakeServer.create();
              window.WORKSPACE_ID = 1;
              $('body').append('<div class="notification-center-container"><div id="notification-center-region"></div></div>');
              this.server.respondWith("GET", "/notifications/messages.json?limit=15&workspace_id=1", [
                200, {
                  "Content-Type": "application/json"
                }, JSON.stringify({
                  messages: [NotificationFixtures.read_message]
                })
              ]);
              result = this.region.show(new NotificationCenterLayout());
              return this.server.respond();
            });
            afterEach(function() {
              this.server.restore();
              this.region.reset();
              return $('.notification-center-container').remove();
            });
            it("should render", function() {
              return expect($('.all-notifications', this.region.el).length).toEqual(1);
            });
            return it("should close on click event", function() {
              this.region.currentView.$el.trigger('mouseleave');
              $(document).trigger('click.notification-global-click');
              return expect($('.notification-center-container').hasClass('hidden')).toBeTruthy();
            });
          });
          describe('Message States', function() {
            beforeEach(function() {
              this.server = sinon.fakeServer.create();
              window.WORKSPACE_ID = 1;
              return $('body').append('<div class="notification-center-container"><div id="notification-center-region"></div></div>');
            });
            afterEach(function() {
              this.server.restore();
              return this.region.reset();
            });
            it("should display 1 read notification", function() {
              var result;
              this.server.respondWith("GET", "/notifications/messages.json?limit=15&workspace_id=1", [
                200, {
                  "Content-Type": "application/json"
                }, JSON.stringify({
                  messages: [NotificationFixtures.read_message]
                })
              ]);
              result = this.region.show(new NotificationCenterLayout());
              this.server.respond();
              expect($('.notification-message', this.region.el).length).toEqual(1);
              return expect($('.notification-message', this.region.el).hasClass('message-read')).toBeTruthy();
            });
            return it("should display 1 unread notification", function() {
              var result;
              this.server.respondWith("GET", "/notifications/messages.json?limit=15&workspace_id=1", [
                200, {
                  "Content-Type": "application/json"
                }, JSON.stringify({
                  messages: [NotificationFixtures.unread_message]
                })
              ]);
              result = this.region.show(new NotificationCenterLayout());
              this.server.respond();
              expect($('.notification-message', this.region.el).length).toEqual(1);
              return expect($('.notification-message', this.region.el).hasClass('message-read')).toBeFalsy();
            });
          });
          return describe('Message Type Dropdown', function() {
            beforeEach(function() {
              this.server = sinon.fakeServer.create();
              window.WORKSPACE_ID = 1;
              return $('body').append('<div class="notification-center-container"><div id="notification-center-region"></div></div>');
            });
            afterEach(function() {
              this.server.restore();
              return this.region.reset();
            });
            return it("should display all notification types", function() {
              var result;
              this.server.respondWith("GET", "/notifications/messages.json?limit=15&workspace_id=1", [
                200, {
                  "Content-Type": "application/json"
                }, JSON.stringify({
                  messages: NotificationFixtures.all_message_types
                })
              ]);
              result = this.region.show(new NotificationCenterLayout());
              this.server.respond();
              return expect($('.notification-message', this.region.el).length).toEqual(4);
            });
          });
        });
      });
    });
  });

}).call(this);
