(function() {

  define(['jquery', 'lib/components/modal/modal_controller', 'entities/abstract/modal'], function($) {
    return describe('Components.Modal.Controller', function() {
      beforeEach(function() {
        this.$el = $("<div />", {
          id: 'dialog-region'
        }).appendTo($('body'))[0];
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
      return describe('when making an App Request', function() {
        it('renders the default modal', function() {
          var contentView, controller;
          contentView = new Backbone.Marionette.ItemView({
            template: _.template('View Content')
          });
          controller = Pro.request('modal:component', contentView, {
            modal: {
              description: 'Custom Description'
            }
          });
          controller.show(controller.getMainView(), {
            region: this.region
          });
          expect($('.header h1', this.region.el).html()).toEqual("Default Title");
          return expect($('.header p', this.region.el).html()).toEqual("Custom Description");
        });
        return it('renders the modal content', function() {
          var contentView, controller;
          contentView = new Backbone.Marionette.ItemView({
            template: _.template('View Content')
          });
          controller = Pro.request('modal:component', contentView);
          controller.show(controller.getMainView(), {
            region: this.region
          });
          return expect($('.content', this.region.el).html()).toEqual("<div>View Content</div>");
        });
      });
    });
  });

}).call(this);
