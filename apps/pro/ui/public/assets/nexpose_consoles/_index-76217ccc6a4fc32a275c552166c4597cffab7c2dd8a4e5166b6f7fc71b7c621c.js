(function() {
  var $;

  $ = jQuery;

  $(document).ready(function() {
    var $checkboxes, $table;
    $table = $('table#nexpose_console_list');
    $checkboxes = $table.find('[type=checkbox]');
    $checkboxes.change(function() {
      var any;
      any = $checkboxes.filter(':checked').length > 0;
      $('#nexpose_console_delete').parent().toggleClass('disabled', !any);
      return true;
    });
    $checkboxes.change();
    return $table.find('td.toggle').click(function(e) {
      e.preventDefault();
      e.stopImmediatePropagation();
      if ($(e.target).hasClass('disabled')) {
        return;
      }
      if (!confirm($(e.target).attr('data-confirm'))) {
        return;
      }
      $(e.target).addClass('disabled');
      return $.ajax({
        url: $(e.target).attr('href'),
        type: 'POST',
        success: function() {
          return location.reload(true);
        }
      });
    });
  });

}).call(this);
