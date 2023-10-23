jQuery ($) ->
  $(document).ready ->
    # Modules table should be sortable and searchable.
    $("#tags-table").table
      searchInputHint:    "Search Tags"
      datatableOptions:
        "aaSorting":      [[1, 'asc']]
        "oLanguage":
          "sEmptyTable":    "No tags are associated with this project. Click 'New Tag' from the Hosts tab to create new Tags.."
        "aoColumns": [
          {"bSortable": false}
          {}
          {"bSortable": false}
          {}
          {"bSortable": false}
          {"bSortable": false}
          {"bSortable": false}
        ]

    # Tag dialog should display as a dialog window.
    $tagDialog = $('#tag-dialog')
    $tagDialog.dialog
      title:    "Edit Tag"
      autoOpen: false
      width:    600
      buttons:
        "Cancel": ->
          $(this).dialog('close')
        "Update Tag": ->
          $(this).find('form').submit()

    # Clicking the tag button should display the tag dialog.
    $('span.button a.edit-notable', '.control-bar').live 'click', (e) ->
      unless $(this).parents('span.button').hasClass 'disabled'
        tag_url = $("input[type='checkbox']", "table.list").filter(':checked').siblings('a').attr('href')
        $.ajax tag_url,
          type: "GET"
          dataType: 'html'
          success: (data, textStatus, jqXHR) ->
            $tagDialog.html(data)
            $tagDialog.dialog('open')
      e.preventDefault()


