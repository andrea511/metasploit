
/*
 This script defines the Pro global, which contains a top-level Marionette
 Application, on top of which we define different namespaced modules for
 controllers and views. The Pro App can be further "refined" by calling
 instance methods on it (e.g. in your page-specific app source).

 This script is included in application.js (and therefore is on every page).
 This ensures that Pro.module method (used to namespace all of our stuff)
 is always defined and accessible, regardless of load order (important for
 parallel require.js loads).
*/


(function() {

  this.Pro = (function() {
    var App;
    App = new Backbone.Marionette.Application;
    App.reqres.setHandler("default:region", function() {
      return App.mainRegion;
    });
    App.reqres.setHandler("default:region", function() {
      return App.mainRegion;
    });
    App.reqres.setHandler("concern", function(concern) {
      return App.Concerns[concern];
    });
    App.on("start", function(options) {
      if (this.startHistory != null) {
        this.startHistory();
        if (!this.getCurrentRoute()) {
          return this.navigate('', {
            trigger: true
          });
        }
      }
    });
    App.commands.setHandler("loadingOverlay:show", function(opts) {
      var _ref, _ref1;
      if (opts == null) {
        opts = {};
      }
      if (App.mainRegion != null) {
        if ((_ref = App.mainRegion.$el) != null) {
          _ref.addClass('blocking-loading');
        }
        if (opts.loadMsg) {
          return (_ref1 = App.mainRegion.$el) != null ? _ref1.prepend("<div class='tab-loading-text'>" + opts.loadMsg + "</div>") : void 0;
        }
      } else {
        jQuery('.mainContent').addClass('blocking-loading');
        if (opts.loadMsg) {
          return jQuery('mainContent').prepend("<div class='tab-loading-text'>" + opts.loadMsg + "</div>");
        }
      }
    });
    App.commands.setHandler("loadingOverlay:hide", function(opts) {
      var $mainContent, _ref, _ref1, _ref2;
      if (opts == null) {
        opts = {};
      }
      if (App.mainRegion != null) {
        if (((_ref = App.mainRegion) != null ? _ref.$el : void 0) != null) {
          if ((_ref1 = App.mainRegion) != null) {
            _ref1.$el.removeClass('blocking-loading');
          }
          return jQuery('.tab-loading-text', (_ref2 = App.mainRegion) != null ? _ref2.$el : void 0).remove();
        }
      } else {
        $mainContent = jQuery('.mainContent');
        $mainContent.removeClass('blocking-loading');
        return jQuery('.tab-loading-text', $mainContent).remove();
      }
    });
    return App;
  })();

}).call(this);
