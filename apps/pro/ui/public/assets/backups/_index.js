(function() {
  var $;

  $ = jQuery;

  $(document).ready(function() {
    var $backup_delete_dialog, $backup_restore_dialog, $checkboxes, $table;
    $table = $('table#backup-list');
    $checkboxes = $table.find('[type=checkbox]');
    $checkboxes.change(function() {
      var any;
      any = $checkboxes.filter(':checked').length > 0;
      if ($('#backup-list tbody tr').length === 0) {
        any = false;
      }
      $('#backup-delete-submit').parent().toggleClass('disabled', !any);
      return true;
    });
    $checkboxes.change();
    $table.find('td.toggle').click(function(e) {
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
    $backup_restore_dialog = $('div#restore-backup-confirmation');
    $('input.restore').click(function(e) {
      var $form, backup_name;
      e.preventDefault();
      backup_name = $(this).attr('data-backup-name');
      $('span#backup-name').text(backup_name);
      $form = $('form#restore');
      $('<input>', {
        name: 'backup_name',
        value: backup_name,
        type: 'hidden'
      }).appendTo($form);
      return $backup_restore_dialog.dialog({
        modal: true,
        draggable: false,
        resizeable: false,
        title: 'Are you sure?',
        width: 600,
        buttons: {
          'Cancel': function() {
            return $("button[title='close']").click();
          },
          'Restore': function() {
            return $form.submit();
          }
        }
      });
    });
    $backup_delete_dialog = $('div#delete-backup-confirmation');
    return $('#backup-delete-submit').click(function(e) {
      var $form;
      $('#delete-backup-confirmation-list').html('');
      e.preventDefault();
      $('#backup-list td :checked').each(function() {
        return $('#delete-backup-confirmation-list').append($('<tr></tr>').html($(this).parent().siblings(".backup-data").clone()));
      });
      $form = $(this).closest('form');
      return $backup_delete_dialog.dialog({
        modal: true,
        draggable: false,
        resizeable: false,
        title: 'Are you sure?',
        width: 600,
        buttons: {
          'Cancel': function() {
            return $("button[title='close']").click();
          },
          'Delete': function() {
            return $form.submit();
          }
        }
      });
    });
  });

}).call(this);
