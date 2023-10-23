(function() {

  define(['backbone_chooser'], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      Concerns.Chooser = {
        initialize: function() {
          return new Backbone.Chooser(this);
        }
      };
      Concerns.SingleChooser = {
        beforeIncluded: function(klass, concern) {
          return klass.prototype.model.include("Chooser");
        },
        initialize: function() {
          return new Backbone.SingleChooser(this);
        }
      };
      return Concerns.MultiChooser = {
        beforeIncluded: function(klass, concern) {
          return klass.prototype.model.include("Chooser");
        },
        initialize: function() {
          return new Backbone.MultiChooser(this);
        }
      };
    });
  });

}).call(this);
