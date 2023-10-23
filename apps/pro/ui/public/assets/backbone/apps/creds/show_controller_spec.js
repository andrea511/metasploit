(function() {

  define(['jquery', 'apps/creds/show/show_controller'], function($) {
    return describe('CredsApp.Show.Controller', function() {
      set('json', function() {
        return JSON.stringify({
          collection: [],
          total_count: 0,
          total_pages: 0
        });
      });
      beforeEach(function() {
        this.server = sinon.fakeServer.create();
        this.server.respondWith(/.*/, [
          200, {
            "Content-Type": "application/json"
          }, json
        ]);
        this.regionEl = $("<div />").appendTo($('body'))[0];
        return this.region = new Backbone.Marionette.Region({
          el: this.regionEl
        });
      });
      afterEach(function() {
        var _ref;
        this.server.restore();
        this.region.reset();
        return (_ref = $(this.regionEl)) != null ? typeof _ref.remove === "function" ? _ref.remove() : void 0 : void 0;
      });
      return it('should render', function() {
        new Pro.CredsApp.Show.Controller({
          id: 1,
          workspace_id: 1,
          region: this.region
        });
        return expect($(this.regionEl).children().length).toBeGreaterThan(0);
      });
    });
  });

}).call(this);
