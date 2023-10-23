(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      $("#modules-table").dataTable({
        searchInputHint: "Search Modules",
        searchable: true,
        sDom: '<"control-bar"f>t<"list-table-footer clearfix"ip <"sel" l>>r',
        sPaginationType: 'r7Style',
        datatableOptions: {
          "aaSorting": [[2, 'asc']],
          "aoColumns": [
            {
              "sType": "title-numeric"
            }, null, null, {
              "bSortable": false
            }
          ]
        }
      });
      $('#all_actions').click(function() {
        var items, selected;
        selected = $('#all_actions').prop('checked');
        items = $('input[type="checkbox"][name="action_ids[]"]');
        return items.prop('checked', selected);
      });
      $('a.add').live('click', function(e) {
        var $dialog, $spinner,
          _this = this;
        $spinner = $(this).siblings('img.spinner');
        $spinner.show();
        $dialog = $('<div style="display:hidden"></div>').appendTo('body');
        $.get($('#macro-module-options-url').html(), {
          'module': $(this).parent().siblings('td.fullname').html(),
          'id': $('#macro-id').html()
        }, function(responseText, textStatus, xhrRequest) {
          $dialog.html(responseText);
          $spinner.hide();
          return $dialog.dialog({
            title: "Configure Module",
            width: 600,
            buttons: {
              "Add Action": function() {
                return $(this).find('form').submit();
              }
            }
          });
        });
        return e.preventDefault();
      });
      return $('#action-delete-submit').multiDeleteConfirm({
        tableSelector: '#action_list',
        pluralObjectName: 'actions'
      });
    });
  });

}).call(this);
