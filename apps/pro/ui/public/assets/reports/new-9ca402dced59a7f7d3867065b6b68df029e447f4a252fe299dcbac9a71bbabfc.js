(function() {

  jQuery(document).on('requirejs-ready', function() {
    var modal;
    modal = null;
    return window.initRequire(['jquery', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js', '/assets/reports/backbone/views/report_form-ca05e3ca636b2338c6f632e9345f153dacacb9d1e896a6d10edd55b153d3e586.js', '/assets/reports/switch_report_type-d399651ccc07ceebabe423596faf62c483a869bf859f1e5da96f954cbde47f50.js'], function($, Modal, ReportsLayoutForm) {
      var url;
      url = $('meta[name=custom_resource_create]').attr('content');
      return $('#upload_report_custom_resource').click(function(e) {
        e.preventDefault();
        if (modal != null) {
          modal.close();
        }
        modal = new Modal({
          "class": 'flat',
          title: "New Custom Resource",
          width: 500
        });
        modal.open();
        return modal.content.show(new ReportsLayoutForm({
          url: url
        }));
      });
    });
  });

}).call(this);
