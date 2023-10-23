(function() {
  var RequireConfig;

  RequireConfig = (function() {

    function RequireConfig() {
      this.fuzzing_require = requirejs.config({
        context: "app",
        paths: {
          jquery: '/assets/shared/backbone/jquery-require-bootstrap-bd9387c71c2398a770de26d5f43987d783d85aa46f76fd4aad5ecad3c7957aa5'
        }
      });
      this.fuzzing_require(['jquery', '/assets/fuzzing/app-8ceb4b26ea7e1a257eb9449bd41cc694cb493835e492108d2dbc92f42f21c499.js'], function($, App) {
        var app;
        app = new App;
        return app.start();
      });
    }

    return RequireConfig;

  })();

  new RequireConfig();

}).call(this);
