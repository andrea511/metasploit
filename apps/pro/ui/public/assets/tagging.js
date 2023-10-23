(function() {
  var $;

  $ = jQuery;

  $(function() {
    var $tagDialog;
    $tagDialog = $('#tag-dialog');
    $tagDialog.dialog({
      title: "Tag Hosts",
      width: 430,
      height: 350,
      buttons: {
        "Tag": function() {
          return $('#tag-form').submit();
        }
      },
      autoOpen: false,
      open: function(e, ui) {
        var $checkedRows, $tokenInput, tagSearchPath, tokenInputOptions, wid;
        wid = this.workspace_id || window.WORKSPACE_ID;
        tagSearchPath = Routes.search_workspace_tags_path(wid, {
          format: 'json'
        });
        tokenInputOptions = {
          "theme": "metasploit",
          "hintText": "Type in a tag name...",
          "searchingText": "Searching tags...",
          "allowCustomEntry": true,
          "preventDuplicates": true,
          "allowFreeTagging": true
        };
        $tokenInput = $('#new_host_tags');
        $checkedRows = $("table.list tbody tr td input[type='checkbox']").filter(':checked').parents('tr');
        if (!$tokenInput.data('tokenInputObject')) {
          $tokenInput.tokenInput(tagSearchPath, tokenInputOptions);
        }
        $tokenInput.tokenInput('clear');
        if ($checkedRows.size() === 1) {
          $checkedRows.children('td').find('.tag').each(function() {
            var id, name;
            name = $(this).children('span.tag-name').html();
            id = parseInt($(this).children('span.tag-id').html());
            return $tokenInput.tokenInput("add", {
              name: name,
              id: id
            });
          });
        }
        return e.preventDefault();
      }
    });
    $(document).on('click', 'span.button a:contains(Tag)', function(e) {
      var $checkedHosts;
      if (!$(this).parent().hasClass('disabled')) {
        $tagDialog.find('.error-container').html('');
        $tagDialog.dialog('open');
        $checkedHosts = $("table.list tbody tr td input[type='checkbox']").filter(':checked');
        if ($checkedHosts.size() === 1) {
          $tagDialog.dialog('option', 'title', 'Edit Tags');
        } else {
          $tagDialog.dialog('option', 'title', 'Tag Hosts');
        }
        $('ul.token-input-list-facebook').click();
      }
      return e.preventDefault();
    });
    $('#tag-form').submit(function(e) {
      var action;
      action = $(this).attr('action');
      $.ajax({
        url: action,
        type: 'POST',
        data: $('#tag-form, #table-form').serialize(),
        success: function() {
          $tagDialog.dialog('close');
          $('table.list').data('dataTableObject').fnDraw();
          return $("table.list thead tr th input[type='checkbox']").attr('checked', false);
        },
        error: function(result) {
          return $('.error-container').html("<div class='flash errors'>" + result.responseText + "</div>");
        }
      });
      e.preventDefault();
      return false;
    });
    return $(document).on('change', "table.sortable tbody tr td input[type='checkbox'].hosts", function() {
      var $tagButton, numChecked;
      $tagButton = $('span.button a:contains(Tag)');
      numChecked = $("table.sortable tbody tr td input[type='checkbox'].hosts").filter(':checked').size();
      switch (numChecked) {
        case 0:
          $tagButton.removeClass('tag-edit tag-add');
          return $tagButton.addClass('tag-edit');
        case 1:
          $tagButton.removeClass('tag-edit tag-add');
          return $tagButton.addClass('tag-edit');
        default:
          $tagButton.removeClass('tag-edit tag-add');
          return $tagButton.addClass('tag-add');
      }
    });
  });

}).call(this);
