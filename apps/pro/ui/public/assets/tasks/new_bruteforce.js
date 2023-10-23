(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      $("#all_services").checkAll($("#service_list"));
      return $("#all_cred_files").checkAll($("#cred_file_list"));
    });
  });

}).call(this);
