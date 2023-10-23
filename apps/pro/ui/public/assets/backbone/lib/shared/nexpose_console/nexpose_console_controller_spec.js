(function() {

  define(['jquery', 'lib/shared/nexpose_console/nexpose_console_controller'], function($) {
    return describe('Shared.NexposeConsole.Controller', function() {
      beforeEach(function() {
        this.$el = $("<div />", {
          id: 'nexpose-console-region'
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
        return it('renders the form', function() {
          var controller;
          controller = Pro.request('nexposeConsole:shared');
          controller.show(controller.getMainView(), {
            region: this.region
          });
          return expect($('input', this.region.el).length).toEqual(5);
        });
      });
    });
  });

}).call(this);
