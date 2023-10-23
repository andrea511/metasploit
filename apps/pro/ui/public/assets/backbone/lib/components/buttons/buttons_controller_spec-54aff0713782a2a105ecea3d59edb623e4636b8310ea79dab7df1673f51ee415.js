(function() {

  define(['jquery', 'lib/components/buttons/buttons_controller', 'entities/abstract/buttons'], function($) {
    return describe('Components.Buttons.Controller', function() {
      beforeEach(function() {
        this.$el = $("<div />", {
          id: 'button-region'
        }).appendTo($('body'))[0];
        return this.region = new Backbone.Marionette.Region({
          el: this.$el
        });
      });
      afterEach(function() {
        var _ref;
        this.region.reset();
        return (_ref = this.$el) != null ? typeof _ref.remove === "function" ? _ref.remove() : void 0 : void 0;
      });
      return describe('when making an App Request', function() {
        it('renders with default buttons', function() {
          var controller;
          controller = Pro.request('buttons:component');
          controller.show(controller.getMainView(), {
            region: this.region
          });
          return expect($('.inline-block', this.region.el).length).toEqual(2);
        });
        return it('renders with buttons set as an option hash', function() {
          var controller;
          controller = Pro.request('buttons:component', {
            buttons: {
              name: 'Done',
              "class": 'btn primary'
            }
          });
          controller.show(controller.getMainView(), {
            region: this.region
          });
          return expect($('.inline-block', this.region.el).length).toEqual(1);
        });
      });
    });
  });

}).call(this);
