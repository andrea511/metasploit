(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var setFileFieldState;
      setFileFieldState = function() {
        if ($('#collect_evidence_task_collect_files').prop('checked')) {
          $('#collect_evidence_task_collect_files_pattern').removeAttr("disabled");
          $('#collect_evidence_task_collect_files_count').removeAttr("disabled");
          return $('#collect_evidence_task_collect_files_size').removeAttr("disabled");
        } else {
          $('#collect_evidence_task_collect_files_pattern').attr("disabled", "disabled");
          $('#collect_evidence_task_collect_files_count').attr("disabled", "disabled");
          return $('#collect_evidence_task_collect_files_size').attr("disabled", "disabled");
        }
      };
      setFileFieldState();
      $(document).on('click', '#collect_evidence_task_collect_files', function(e) {
        return setFileFieldState();
      });
      $("#collect_all_sessions").checkAll($("#collect_sessions"));
      return $('#collect_all_sessions').trigger('click');
    });
  });

}).call(this);
