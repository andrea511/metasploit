(function() {

  define(['jquery', 'apps/brute_force_reuse/cred_selection/cred_selection_controller'], function($) {
    return describe('BruteForceReuseApp.CredSelection.Controller', function() {
      set('WORKSPACE_ID', function() {
        return 1;
      });
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
        this.region = new Backbone.Marionette.Region({
          el: this.regionEl
        });
        return window.gon = {
          filter_values_workspace_metasploit_credential_cores_path: 'foo'
        };
      });
      afterEach(function() {
        var emptyView, _ref;
        emptyView = Backbone.Marionette.ItemView.extend({
          template: function() {
            return "";
          }
        });
        this.region.show(new emptyView(), {
          preventDestroy: true
        });
        this.server.restore();
        this.region.reset();
        return (_ref = $(this.regionEl)) != null ? typeof _ref.remove === "function" ? _ref.remove() : void 0 : void 0;
      });
      return it('should render', function() {
        var controller;
        controller = new Pro.BruteForceReuseApp.CredSelection.Controller({
          workspace_id: 1,
          region: this.region
        });
        return expect($(this.regionEl).children().length).toBeGreaterThan(0);
      });
    });
  });

}).call(this);
