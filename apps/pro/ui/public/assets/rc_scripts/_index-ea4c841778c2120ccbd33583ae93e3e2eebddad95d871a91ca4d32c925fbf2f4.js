(function() {
  var $;

  $ = jQuery;

  $(document).ready(function() {
    var $delete_button, $master_checkbox, $rc_script_delete_dialog, $slave_checkboxes, $table, $upload_button;
    $table = $('table#rc-script-list');
    $master_checkbox = $table.find('[type=checkbox][name="all-rc-scripts"]');
    $slave_checkboxes = $table.find('[type=checkbox][name="rc-script-delete"]');
    $delete_button = $(".rc-scripts").find("input.delete");
    $upload_button = $(".rc-scripts").find("a.import");
    $master_checkbox.change(function() {
      var master_state;
      master_state = $master_checkbox.prop('checked');
      return $slave_checkboxes.prop('checked', master_state);
    });
    $upload_button.click(function(e) {
      return $("#upload").click();
    });
    $('#upload').change(function() {
      return $('[value="Upload"]').click();
    });
    $rc_script_delete_dialog = $('div#delete-rc-script-confirmation');
    return $delete_button.click(function(e) {
      $('#delete-backup-confirmation-list').html('');
      e.preventDefault();
      return $slave_checkboxes.filter(':checked').each(function() {
        return $(this.parentElement).find('[value="Delete"]').click();
      });
    });
  });

}).call(this);
