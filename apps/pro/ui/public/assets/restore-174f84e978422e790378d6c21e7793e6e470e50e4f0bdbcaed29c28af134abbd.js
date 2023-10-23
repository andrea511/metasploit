
jQuery(document).ready(function ($) {
  // TODO: generate this form in the view and submit through an iframe
  var fn = function() {
    $.ajax({
      url: '/backups/status',
      type: 'POST',
      data: {authenticity_token: $('meta[name="csrf-token"]').attr('content'), backup: $('meta[name="msp:backup_name"]').attr('content')},
      success: function(data, textStatus, jqXHR) {
        $('#restart_status').html(data);
      },
      complete: function() {
        if ($('#restart_status .btn').length == 0) { setTimeout(fn, 3000); }
      }
    });
  };
  if ($('meta[name="msp:backup_present"]').length > 0) {
    setTimeout(fn, 3000);
  }
});
