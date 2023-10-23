(function() {

  define([], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      return Concerns.Spinner = {
        showSpinner: function() {
          this.$el.find('.spinner-content').hide();
          return this.$el.find('.spinner').show();
        },
        hideSpinner: function() {
          this.$el.find('.spinner-content').show();
          return this.$el.find('.spinner').hide();
        }
      };
    });
  });

}).call(this);
