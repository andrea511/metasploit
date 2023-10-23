(function() {

  define([], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      return Concerns.HoverTimeout = {
        ui: {
          hoverContainer: '.hover-container'
        },
        events: {
          'mouseenter @ui.hoverContainer': 'setHoverTimeout',
          'mouseleave @ui.hoverContainer': 'clearHoverTimeout',
          'mouseleave @ui.hoverContainer': 'setHideHoverTimeout',
          'mouseleave': 'setHideHoverTimeout'
        },
        setHoverTimeout: function() {
          var _this = this;
          return this.hoverTimeout = setTimeout((function() {
            return _this.triggerHover();
          }), 100);
        },
        clearHoverTimeout: function() {
          return clearTimeout(this.hoverTimeout);
        },
        setHideHoverTimeout: function() {
          var _this = this;
          return this.hideHoverTimeout = setTimeout((function() {
            return _this.triggerHideHover();
          }), 200);
        },
        clearHideHoverTimeout: function() {
          return clearTimeout(this.hideHoverTimeout);
        },
        triggerHover: function() {
          return this.trigger('show:hover');
        },
        triggerHideHover: function() {
          return this.trigger('hide:hover');
        }
      };
    });
  });

}).call(this);
