(function() {

  define([], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      return Concerns.TableSelections = {
        multipleSelected: function() {
          return this.selectAllState || this.selectedIDs.length > 1;
        },
        pluralizedMessage: function(singularVersion, pluralVersion) {
          if (this.multipleSelected()) {
            return pluralVersion;
          } else {
            return singularVersion;
          }
        }
      };
    });
  });

}).call(this);
