(function() {

  define(['jquery', 'base_itemview', 'lib/components/window_slider/window_slider_controller'], function($) {
    return describe('Components.WindowSlider.Controller', function() {
      var renderSliderComponent;
      beforeEach(function() {
        this.$el = $("<div />", {
          id: 'window-slider-region'
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
      renderSliderComponent = function(opts) {
        var defaults;
        if (opts == null) {
          opts = {};
        }
        defaults = {
          region: this.region
        };
        _.extend(defaults, opts);
        this.view = new Pro.Views.ItemView;
        return this.controller = Pro.request('window_slider:component', this.view, defaults);
      };
      describe('when calling App.request "window_slider:component", view', function() {
        return it('renders', function() {
          renderSliderComponent.call(this);
          return expect(this.region.el.children.length).toBeGreaterThan(0);
        });
      });
      return describe('when sliding to a new region', function() {
        it('slides to the first region', function() {
          var new_view, slider_controller;
          slider_controller = renderSliderComponent.call(this);
          new_view = new Pro.Views.ItemView;
          new_view.template = _.template("<div>This is the content of the new region</div>");
          slider_controller.showWindowSliderContentRegion({
            contentView: new_view,
            show: true
          });
          return expect($('.window-slider-pane', slider_controller.region.$el).length).toEqual(1);
        });
        return it('slides to the new region and removes the old one', function() {
          var new_view, slide_to_view, slider_controller;
          slider_controller = renderSliderComponent.call(this);
          new_view = new Pro.Views.ItemView;
          slide_to_view = new Pro.Views.ItemView;
          new_view.template = _.template("<div>This is the content of the new region</div>");
          slide_to_view.template = _.template("<div>This is the new region to slide</div>");
          slider_controller.showWindowSliderContentRegion({
            contentView: new_view,
            show: true
          });
          slider_controller.showWindowSliderContentRegion({
            contentView: slide_to_view,
            show: true
          });
          waits(3);
          return runs(function() {
            $('.window-slider-pane', slider_controller.region.$el).first().trigger('transitionEnd');
            return expect($('.window-slider-pane', slider_controller.region.$el).length).toEqual(1);
          });
        });
      });
    });
  });

}).call(this);
