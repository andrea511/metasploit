(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'lib/utilities/uuid', 'base_layout', 'base_itemview', 'lib/components/window_slider/templates/window_slider'], function($, UUID) {
    return this.Pro.module("Components.WindowSlider", function(WindowSlider, App) {
      return WindowSlider.WindowSliderLayout = (function(_super) {

        __extends(WindowSliderLayout, _super);

        function WindowSliderLayout() {
          this.showSlider = __bind(this.showSlider, this);

          this.animate = __bind(this.animate, this);

          this.removeNode = __bind(this.removeNode, this);
          return WindowSliderLayout.__super__.constructor.apply(this, arguments);
        }

        WindowSliderLayout.prototype.template = WindowSliderLayout.prototype.templatePath("window_slider/window_slider");

        WindowSliderLayout.prototype.className = 'window-slider-container';

        WindowSliderLayout.prototype.regions = {
          windowSliderRegion: '#window-slider-region'
        };

        WindowSliderLayout.prototype.initialize = function() {
          return this.shown = false;
        };

        WindowSliderLayout.prototype.addSliderRegion = function() {
          if ($('.window-slider-pane', this.el).length > 1) {
            $(".window-slider-pane:not(." + this.id + ")", this.el).remove();
          }
          this.addNode();
          this.addRegion(this.id, "." + this.id);
          this.listenTo(this[this.id], 'show', this.animateSlider);
          return this[this.id];
        };

        WindowSliderLayout.prototype.addNode = function() {
          var klass;
          this.id = Pro.Utilities.createGuid();
          klass = this.shown ? '' : 'show first';
          this.shown = true;
          return this.$el.append("<div class='" + this.id + " " + klass + " window-slider-pane'></div>");
        };

        WindowSliderLayout.prototype.removeNode = function(e) {
          var klass;
          klass = $(e.target).attr('class').split(" ")[0];
          if (this[klass] != null) {
            this.removeRegion(klass);
            return $("." + klass, this.el).remove();
          }
        };

        WindowSliderLayout.prototype.animateSlider = function() {
          return _.delay(this.animate, 1);
        };

        WindowSliderLayout.prototype.animate = function() {
          var $elem, klass;
          if ($('.window-slider-pane', this.el).first().attr('class').indexOf(this.id) === -1) {
            if ($('.window-slider-pane', this.el).length > 2) {
              $elem = $(".window-slider-pane:not(." + this.id + ")", this.el);
              klass = $(e.target).attr('class').split(" ")[0];
              this.removeRegion(klass);
              $elem.remove();
              $elem = $(".window-slider-pane:not(." + this.id + ")", this.el);
              klass = $(e.target).attr('class').split(" ")[0];
              this.removeRegion(klass);
              $elem.remove();
            } else {
              $('.window-slider-pane', this.el).css({
                position: 'absolute'
              });
              $('.window-slider-pane', this.el).first().addClass('slideOutLeft');
              $('.window-slider-pane', this.el).first().one('transitionEnd transitionend webkitTransitionEnd', this.removeNode);
            }
          }
          return _.defer(this.showSlider);
        };

        WindowSliderLayout.prototype.showSlider = function() {
          var $myEl;
          $myEl = this.$el;
          $("." + this.id, this.el).addClass('show').one('transitionEnd transitionend webkitTransitionEnd', function() {
            $(this).css({
              position: 'relative'
            });
            return $myEl.css('min-height', 0);
          });
          return $myEl.css('min-height', this.$el.children().last().height());
        };

        return WindowSliderLayout;

      })(App.Views.Layout);
    });
  });

}).call(this);
