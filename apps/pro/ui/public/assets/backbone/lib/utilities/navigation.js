(function() {

  this.Pro.module("Utilities", function(Utilities, App, Backbone, Marionette, $, _) {
    return _.extend(App, {
      navigate: function(route, options) {
        if (options == null) {
          options = {};
        }
        return Backbone.history.navigate(route, options);
      },
      getCurrentRoute: function() {
        var frag;
        frag = Backbone.history.fragment;
        if (_.isEmpty(frag)) {
          return null;
        } else {
          return frag;
        }
      },
      startHistory: function() {
        if (Backbone.history) {
          Backbone.history.start();
          return Backbone.history.on('route', function() {
            return App.execute('closeModal');
          });
        }
      }
    });
  });

}).call(this);
