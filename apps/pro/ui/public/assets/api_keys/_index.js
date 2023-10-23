(function() {
  var $;

  $ = jQuery;

  $(document).ready(function() {
    return $(document).on('click', 'a.reveal', function(e) {
      var $dialog,
        _this = this;
      $dialog = $('<div style="display:hidden"></div>').appendTo('body');
      $dialog.load($(this).parent().parent().attr('rurl'), {
        'id': $(this).parent().parent().attr('rid')
      }, function(responseText, textStatus, xhrRequest) {
        return $dialog.dialog({
          title: "Unobfuscated API Key",
          height: 100,
          width: 300
        });
      });
      return e.preventDefault();
    });
  });

  $(document).ready(function() {
    var $checkboxes, $table;
    $table = $('table#api_key_list');
    $checkboxes = $table.find('[type=checkbox]');
    $checkboxes.change(function() {
      var any;
      any = $checkboxes.filter(':checked').length > 0;
      $('#api_key_delete').parent().toggleClass('disabled', !any);
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
