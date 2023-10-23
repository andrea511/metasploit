(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var $tagDialog;
      $("#tags-table").table({
        searchInputHint: "Search Tags",
        datatableOptions: {
          "aaSorting": [[1, 'asc']],
          "oLanguage": {
            "sEmptyTable": "No tags are associated with this project. Click 'New Tag' from the Hosts tab to create new Tags.."
          },
          "aoColumns": [
            {
              "bSortable": false
            }, {}, {
              "bSortable": false
            }, {}, {
              "bSortable": false
            }, {
              "bSortable": false
            }, {
              "bSortable": false
            }
          ]
        }
      });
      $tagDialog = $('#tag-dialog');
      $tagDialog.dialog({
        title: "Edit Tag",
        autoOpen: false,
        width: 600,
        buttons: {
          "Cancel": function() {
            return $(this).dialog('close');
          },
          "Update Tag": function() {
            return $(this).find('form').submit();
          }
        }
      });
      return $('span.button a.edit-notable', '.control-bar').live('click', function(e) {
        var tag_url;
        if (!$(this).parents('span.button').hasClass('disabled')) {
          tag_url = $("input[type='checkbox']", "table.list").filter(':checked').siblings('a').attr('href');
          $.ajax(tag_url, {
            type: "GET",
            dataType: 'html',
            success: function(data, textStatus, jqXHR) {
              $tagDialog.html(data);
              return $tagDialog.dialog('open');
            }
          });
        }
        return e.preventDefault();
      });
    });
  });

}).call(this);
