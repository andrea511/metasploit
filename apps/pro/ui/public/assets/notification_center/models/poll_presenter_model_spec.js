(function() {

  define(['jquery', '/assets/shared/notification-center/backbone/models/poll_presenter_model-68d80f03807d73b5b0fe56d71011439ccc91516b4ca3dd62251b0b4a692175da.js'], function($, PollPresenterModel) {
    return describe("PollPresenterModel", function() {
      describe("Server Behavior", function() {
        beforeEach(function() {
          return this.server = sinon.fakeServer.create();
        });
        afterEach(function() {
          return this.server.restore();
        });
        it("should fire the change event", function() {
          var callback, paramHash, poll_presenter;
          callback = sinon.spy();
          this.server.respondWith("GET", "/notifications/messages/poll.json?workspace_id=1&unread=true", [
            200, {
              "Content-Type": "application/json"
            }, '{"session_count":0,"task_count":0,"unread_message_count":0}'
          ]);
          poll_presenter = new PollPresenterModel();
          paramHash = {
            'unread': true
          };
          poll_presenter.fetch({
            data: paramHash,
            success: callback
          });
          this.server.respond();
          return expect(callback.called).toBeTruthy();
        });
        return it("should hit the correct RESTful Endpoint", function() {
          var poll_presenter, spy;
          poll_presenter = new PollPresenterModel();
          spy = sinon.spy($, 'ajax');
          poll_presenter.save({
            wait: true
          });
          expect(spy).toHaveBeenCalled();
          return $.ajax.restore();
        });
      });
      return describe("Default Values", function() {
        return it("should have urlRoot set", function() {
          var poll_presenter;
          poll_presenter = new PollPresenterModel();
          return expect(poll_presenter.urlRoot).toEqual('/notifications/messages/poll.json?workspace_id=1');
        });
      });
    });
  });

}).call(this);
