(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var setCustomScanTemplateEnablement;
      $(document).on('change', "#additional_creds_checkbox", function() {
        return $("#additional_creds_fields").toggle($("#additional_creds_checkbox").is(':checked'));
      });
      $("#additional_creds_checkbox").change();
      $(document).on('change', "#nexpose_task_use_pass_the_hash_creds", function() {
        return $("#auto_pass_the_hash_fields").toggle($("#nexpose_task_use_pass_the_hash_creds").is(':checked'));
      });
      $("#nexpose_task_use_pass_the_hash_creds").change();
      setCustomScanTemplateEnablement = function() {
        if ($('#nexpose_task_scan_template').val() === "custom") {
          return $('#nexpose_task_custom_template').removeAttr("disabled");
        } else {
          $('#nexpose_task_custom_template').val() === "";
          return $('#nexpose_task_custom_template').attr("disabled", "disabled");
        }
      };
      $(document).on('change', '#nexpose_task_scan_template', function() {
        return setCustomScanTemplateEnablement();
      });
      return setCustomScanTemplateEnablement();
    });
  });

}).call(this);
