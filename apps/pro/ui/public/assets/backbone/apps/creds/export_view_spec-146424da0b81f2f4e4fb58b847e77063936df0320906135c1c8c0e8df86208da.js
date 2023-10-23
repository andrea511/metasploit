(function() {

  define(['jquery', 'lib/components/modal/modal_controller', 'apps/creds/export/export_controller', 'apps/creds/export/export_view'], function($) {
    var TestHelpers;
    TestHelpers = {
      showExportModal: function() {
        this.controller = new Pro.CredsApp.Export.Controller;
        this.controller.show(this.controller.getMainView(), {
          region: this.region
        });
        return this.view = this.controller._mainView;
      }
    };
    return describe('CredsApp.Export.Layout', function() {
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
        Pro.vent.off('modal:shown');
        Pro.removeRegion('mainRegion');
        this.region.reset();
        return (_ref = this.$el) != null ? typeof _ref.remove === "function" ? _ref.remove() : void 0 : void 0;
      });
      describe('when the modal is displayed', function() {
        beforeEach(function() {
          return TestHelpers.showExportModal();
        });
        return it('fills in an initial value for the export filename', function() {
          return expect(this.$el.find('#filename')).not.toEqual("");
        });
      });
      return describe('form behaviors', function() {
        describe('when the pwdump export option is selected', function() {
          beforeEach(function() {
            return TestHelpers.showExportModal();
          });
          it('hides the selected row options', function() {
            this.$el.find('#pwdump').click();
            return expect(this.$el.find('.row-options:visible').length).toEqual(0);
          });
          return it('displays the pwdump ssh key warning', function() {
            this.$el.find('#pwdump').click();
            return expect(this.$el.find('.pwdump-warning:visible').length).toEqual(1);
          });
        });
        return describe('when the csv export option is selected', function() {
          beforeEach(function() {
            return TestHelpers.showExportModal();
          });
          it('shows the selected row options', function() {
            this.$el.find('#pwdump').click();
            this.$el.find('#csv').click();
            return expect(this.$el.find('.row-options:visible').length).toEqual(1);
          });
          return it('hides the pwdump ssh key warning', function() {
            this.$el.find('#pwdump').click();
            this.$el.find('#csv').click();
            return expect(this.$el.find('.pwdump-warning:visible').length).toEqual(0);
          });
        });
      });
    });
  });

}).call(this);
