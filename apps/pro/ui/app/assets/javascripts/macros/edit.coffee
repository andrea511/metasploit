jQuery ($) ->
  $(document).ready ->
    # Modules table should be sortable and searchable.
    $("#modules-table").dataTable
      searchInputHint:    "Search Modules"
      searchable: true
      sDom: '<"control-bar"f>t<"list-table-footer clearfix"ip <"sel" l>>r'
      sPaginationType: 'r7Style'
      datatableOptions:
        "aaSorting":      [[2, 'asc']]
        "aoColumns":      [
          "sType":        "title-numeric"
          null
          null
          "bSortable":    false
        ]


    # JS needed to make "select all" on the "actions" table functional.
    $('#all_actions').click ->
      selected = $('#all_actions').prop('checked')
      items = $('input[type="checkbox"][name="action_ids[]"]')
      items.prop('checked', selected);


    # Module confirmation dialogs should appear when + button is clicked in
    # macros table.
    $('a.add').live 'click', (e) ->
      $spinner = $(this).siblings('img.spinner')
      $spinner.show()
      $dialog = $('<div style="display:hidden"></div>').appendTo('body')
      $.get $('#macro-module-options-url').html(), {'module': $(@).parent().siblings('td.fullname').html(), 'id': $('#macro-id').html()}, (responseText, textStatus, xhrRequest) =>
        $dialog.html responseText
        $spinner.hide()
        $dialog.dialog
          title: "Configure Module"
          width: 600
          buttons:
            "Add Action": ->
              $(this).find('form').submit()
      e.preventDefault()

    # Module delete button should confirm deletion and verify that modules have
    # been selected.
    $('#action-delete-submit').multiDeleteConfirm
      tableSelector:    '#action_list'
      pluralObjectName: 'actions'
