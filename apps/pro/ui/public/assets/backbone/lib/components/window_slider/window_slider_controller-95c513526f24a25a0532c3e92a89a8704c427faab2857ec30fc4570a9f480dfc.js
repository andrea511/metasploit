(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/window_slider/window_slider_view'], function() {
    return this.Pro.module("Components.WindowSlider", function(WindowSlider, App) {
      WindowSlider.WindowSliderController = (function(_super) {

        __extends(WindowSliderController, _super);

        function WindowSliderController() {
          return WindowSliderController.__super__.constructor.apply(this, arguments);
        }

        WindowSliderController.prototype.defaults = function() {
          return {
            proxy: false,
            onBeforeSlide: function() {},
            onAfterSlide: function() {},
            show: true
          };
        };

        WindowSliderController.prototype.initialize = function(options) {
          var config;
          if (options == null) {
            options = {};
          }
          this.contentView = options.contentView;
          config = this.getConfig(options);
          this.showView = config.show;
          this.windowSliderLayout = this.getWindowSliderLayout(config);
          this.setMainView(this.windowSliderLayout);
          if (config.proxy) {
            this.parseProxys(config.proxy);
          }
          this.createListeners(config);
          return this.show(this.windowSliderLayout);
        };

        WindowSliderController.prototype.getWindowSliderLayout = function(config) {
          return new WindowSlider.WindowSliderLayout(config);
        };

        WindowSliderController.prototype.createListeners = function(config) {};

        /*
                @listenTo @windowSliderLayout, "before:slide", => @beforeSlide(config)
                @listenTo @windowSliderLayout, "after:slide", => @afterSlide(config)
        
              beforeSlide: (config) ->
                config.onBeforeSlide()
                @trigger "before:slide"
        
              afterSlide: (config) ->
                config.onAfterSlide()
                @trigger "after:slide"
        */


        WindowSliderController.prototype.showWindowSliderContentRegion = function(options, showFunc, args) {
          var slideToRegion;
          if (options == null) {
            options = {};
          }
          if (showFunc == null) {
            showFunc = null;
          }
          _.defaults(options, {
            show: this.showView,
            contentView: this.contentView,
            loading: false
          });
          slideToRegion = this.windowSliderLayout.addSliderRegion();
          if (showFunc) {
            return showFunc.call({}, args, slideToRegion);
          } else {
            if (options.show) {
              return this.show(options.contentView, {
                region: slideToRegion,
                loading: options.loading
              });
            }
          }
        };

        /*
              #Good Canidates for Mixin
        */


        WindowSliderController.prototype.getConfig = function(options) {
          var config, windowSlider;
          windowSlider = _.result(this.contentView, "windowSlider");
          config = this.mergeDefaultsInto(windowSlider);
          return _.extend(config, _(options).omit("contentView", "model", "collection"));
        };

        WindowSliderController.prototype.parseProxys = function(proxys) {
          var proxy, _i, _len, _ref, _results;
          _ref = _([proxys]).flatten();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            proxy = _ref[_i];
            _results.push(this.windowSliderLayout[proxy] = _.result(this.contentView, proxy));
          }
          return _results;
        };

        return WindowSliderController;

      })(App.Controllers.Application);
      App.reqres.setHandler("window_slider:component", function(contentView, options) {
        if (options == null) {
          options = {};
        }
        if (contentView) {
          options.contentView = contentView;
          return new WindowSlider.WindowSliderController(options);
        } else {
          return WindowSlider.WindowSliderController;
        }
      });
      return App.commands.setHandler('sliderRegion:show', function(options, showFunc, args) {
        var contentView, loading, show, windowSliderController;
        if (options == null) {
          options = {};
        }
        if (showFunc == null) {
          showFunc = null;
        }
        contentView = options.contentView, show = options.show, loading = options.loading;
        if (this.windowSlider == null) {
          windowSliderController = App.request("window_slider:component");
          this.windowSlider = new windowSliderController({
            show: false
          });
        }
        return this.windowSlider.showWindowSliderContentRegion({
          contentView: contentView,
          show: show,
          loading: loading
        }, showFunc, args);
      });
    });
  });

}).call(this);
