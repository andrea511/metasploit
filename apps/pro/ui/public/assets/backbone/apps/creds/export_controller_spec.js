(function() {

  define(['jquery', 'lib/components/modal/modal_controller', 'apps/creds/export/export_controller'], function($) {
    var TestHelpers;
    TestHelpers = {
      showExportModal: function() {
        var controller;
        controller = new Pro.CredsApp.Export.Controller;
        return controller.show(controller.getMainView(), {
          region: this.region
        });
      }
    };
    return describe('CredsApp.Export.Controller', function() {
      beforeEach(function() {
        this.$el = $("<div />", {
          id: 'export-region'
        }).appendTo($('body'));
        this.region = new Backbone.Marionette.Region({
          el: this.$el
        });
        return Pro.addRegions({
          mainRegion: this.region
        });
      });
      afterEach(function() {
        var _ref;
        Pro.removeRegion('mainRegion');
        this.region.reset();
        return (_ref = this.$el) != null ? typeof _ref.remove === "function" ? _ref.remove() : void 0 : void 0;
      });
      return it('renders properly', function() {
        TestHelpers.showExportModal();
        return expect(this.$el.find('.export-form').length).toEqual(1);
      });
    });
  });

}).call(this);
