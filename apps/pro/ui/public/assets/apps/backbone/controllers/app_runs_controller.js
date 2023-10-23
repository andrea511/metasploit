(function() {

  define(['/assets/apps/backbone/views/layouts/app_runs_layout-280c238c3db26f0e5f3faf4d4c90059f011ba24c658f9a1a8410e3551b27b376.js'], function(AppRunsLayout) {
    var AppRunsController;
    return AppRunsController = (function() {

      function AppRunsController(_arg) {
        this.region = _arg.region;
        this.layout = new AppRunsLayout();
        this.region.show(this.layout);
        this.layout.renderRegions();
      }

      return AppRunsController;

    })();
  });

}).call(this);
