(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var resetFormValues, tmrw;
      $("#all_exceptions").checkAll($("#exception_list"));
      $("#nexpose_exception_push_task_expiration_set").live('change', function() {
        return $("#nexpose_exception_push_task_expiration_date_input").toggle($("#nexpose_exception_push_task_expiration_set").is(':checked'));
      });
      $("#nexpose_exception_push_task_expiration_set").change();
      tmrw = new Date;
      tmrw.setDate(new Date().getDate() + 1);
      $("#nexpose_exception_push_task_expiration_date").datepicker({
        dateFormat: "yy-mm-dd",
        minDate: tmrw
      });
      resetFormValues = function(reason, comment) {
        var $f;
        $f = $('form#new_nexpose_exception_push_task');
        if (reason && reason.length > 0) {
          $('select>option', $f).removeAttr('selected');
          $('select>option[value="' + reason + '"]').attr('selected', 'selected');
        }
        if (comment) {
          return $('textarea', $f).val(comment);
        }
      };
      return $("#exceptions .ctrls .btn a").click(function(e) {
        $('#reset-form').dialog({
          title: "Reset Form Values",
          width: 430,
          height: 220,
          autoOpen: true,
          modal: true,
          buttons: {
            "Cancel": function() {
              return $(this).dialog("close");
            },
            "Reset form values": function() {
              var comment, reason;
              comment = $('textarea[name=comment]', $(this)).val();
              reason = $('select[name=reason]>option:selected', $(this)).val();
              resetFormValues(reason, comment);
              return $(this).dialog("close");
            }
          },
          open: function() {
            $('textarea', $(this)).val('');
            return $('select>option', $(this)).removeAttr('selected').eq(0).attr('selected', 'selected');
          }
        });
        return e.preventDefault();
      });
    });
  });

}).call(this);
