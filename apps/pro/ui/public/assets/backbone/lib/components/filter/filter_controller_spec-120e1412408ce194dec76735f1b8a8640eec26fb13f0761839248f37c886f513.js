(function() {

  define(['jquery', 'lib/components/filter/filter_controller', 'css!css/visualsearch-datauri'], function($) {
    return describe('Components.Filter.FilterController', function() {
      beforeEach(function() {
        this.$el = $("<div />", {
          id: 'filter-region'
        }).appendTo($('body'))[0];
        return this.region = new Backbone.Marionette.Region({
          el: this.$el
        });
      });
      afterEach(function() {
        var _ref;
        this.region.reset();
        return (_ref = this.$el) != null ? _ref.remove() : void 0;
      });
      return describe('when making an App Request', function() {
        return it('renders the filter component', function() {
          var controller;
          controller = Pro.request('filter:component');
          controller.show(controller.getMainView(), {
            region: this.region
          });
          return expect($('.filter-component', this.region.el).length).toEqual(1);
        });
      });
    });
  });

}).call(this);
