(function() {

  define(['jquery', 'base_controller', 'lib/concerns/controllers/pro_carpenter', 'carpenter'], function($) {
    return this.Pro.module("Components.Table", function(Table, App) {
      Marionette.Carpenter.Controller.include('ProCarpenter');
      return App.reqres.setHandler('table:component', function(options) {
        if (options == null) {
          options = {};
        }
        if (options.search) {
          options.fetch = false;
        }
        _.defaults(options, {
          perPageOptions: [20, 50, 100, 500]
        });
        return new Marionette.Carpenter.Controller(options);
      });
    });
  });

}).call(this);
