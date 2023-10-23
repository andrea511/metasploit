(function() {

  define(['jquery', 'apps/brute_force_guess/quick/quick_controller'], function($) {
    return describe('BruteForceGuessApp.Quick.Controller', function() {
      var TestHelpers,
        _this = this;
      TestHelpers = {
        showQuickBruteForce: function() {
          _this.controller = new Pro.BruteForceGuessApp.Quick.Controller();
          return _this.controller.show(_this.controller.getMainView(), {
            region: _this.region
          });
        }
      };
      beforeEach(function() {
        window.gon = sinon.stub().returns({
          workspace_cred_count: 0
        });
        this.$el = $("<div />", {
          id: '#bruteforce-main-region'
        }).appendTo($('body'));
        this.region = new Backbone.Marionette.Region({
          el: this.$el
        });
        Pro.addRegions({
          mainRegion: this.region
        });
        return TestHelpers.showQuickBruteForce();
      });
      afterEach(function() {
        var _ref;
        window.gon = void 0;
        Pro.removeRegion('mainRegion');
        this.region.reset();
        return (_ref = this.$el) != null ? typeof _ref.remove === "function" ? _ref.remove() : void 0 : void 0;
      });
      it("renders the target region", function() {
        return expect(this.$el.find('#targets-region > div').length).toEqual(1);
      });
      it("renders the creds region", function() {
        return expect(this.$el.find('#creds-region > div').length).toEqual(1);
      });
      return it("renders the options region", function() {
        return expect(this.$el.find('#options-region > div').length).toEqual(1);
      });
    });
  });

}).call(this);
