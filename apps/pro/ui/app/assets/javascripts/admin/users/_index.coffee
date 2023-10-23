jQuery ($) ->
  $(document).ready ->
    # Users table should be sortable and searchable.
    $('table#users').table
      searchInputHint:    "Search Users"
      datatableOptions:
        "aaSorting": [[1, 'desc']]
        "aoColumns": [
          {"bSortable": false}
          {}
          {}
          {}
          {}
          {}
        ]
    # User delete button should confirm deletion and verify that users have
    # been selected.
    $('#user-delete-submit').multiDeleteConfirm
      tableSelector:    '#users'
      pluralObjectName: 'users'
