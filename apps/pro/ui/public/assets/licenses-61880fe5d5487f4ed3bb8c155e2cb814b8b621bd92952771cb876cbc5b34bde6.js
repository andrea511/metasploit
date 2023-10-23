jQuery(function($) {
  return $(document).ready(function() {
    var path = document.location.protocol + "//" + document.location.host;
    if (document.location.host.indexOf(":") == -1) {
      path = path + ":" + document.location.port;
    }
    path = path + "/setup/activation";

    url = $('#store_link').attr('href');
    $('#store_link').attr('href', url + "&return_path=" + encodeURIComponent(host));
  });
})
;
