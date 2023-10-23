(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var PASSWORD_UNCHANGED, TAB_KEY_CODE, input;
      PASSWORD_UNCHANGED = "password unchanged";
      TAB_KEY_CODE = 9;
      input = $('#smtp_password');
      if (input.val() === PASSWORD_UNCHANGED) {
        return input.keydown(function(event) {
          if (event.keyCode !== TAB_KEY_CODE && !event.shiftKey && input.val() === PASSWORD_UNCHANGED) {
            return $(this).val('');
          }
        });
      }
    });
  });

}).call(this);
