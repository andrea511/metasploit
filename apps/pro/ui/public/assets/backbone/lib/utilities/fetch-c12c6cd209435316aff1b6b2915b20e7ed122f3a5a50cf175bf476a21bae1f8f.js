(function() {

  define(['jquery', 'config/sync'], function($) {
    return this.Pro.module("Utilities", function(Utilities, App) {
      return App.commands.setHandler("when:fetched", function(entities, callback) {
        var xhrs;
        xhrs = _.chain([entities]).flatten().pluck("_fetch").value();
        return $.when.apply($, xhrs).done(function() {
          return callback();
        });
      });
    }, $);
  });

}).call(this);
