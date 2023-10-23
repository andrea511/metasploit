(function() {
  var _this = this;

  window.initRequire = requirejs.config({
    context: "app",
    paths: {
      jquery: '/assets/shared/backbone/jquery-require-bootstrap-bd9387c71c2398a770de26d5f43987d783d85aa46f76fd4aad5ecad3c7957aa5',
      form_helpers: '/assets/shared/lib/install_form_helpers-55da59dab52bac2cb1ed38f9892aa1c491c7c8f73dd7199f20f3b9f098f1463b',
      pro: '/javascripts/backbone/pro'
    },
    waitSeconds: 0,
    shim: {
      pro: {
        exports: 'Pro'
      }
    }
  });

  jQuery(document).ready(function() {
    return jQuery(document).trigger('requirejs-ready');
  });

}).call(this);
