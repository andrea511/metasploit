(function() {

  define(['/assets/apps/backbone/views/layouts/apps_overview_layout-2f8bcb12fc31fa98a51aae318cf563111e80e8ab52a7a0fa1c11b7426edb6b45.js'], function(AppsOverviewLayout) {
    var AppsOverviewController;
    return AppsOverviewController = (function() {

      function AppsOverviewController(_arg) {
        this.region = _arg.region;
        this.layout = new AppsOverviewLayout();
        this.region.show(this.layout);
        this.layout.renderRegions();
      }

      return AppsOverviewController;

    })();
  });

}).call(this);
