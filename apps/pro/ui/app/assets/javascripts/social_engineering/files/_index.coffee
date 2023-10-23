jQuery ($) ->
  $(document).ready ->
    $("table#files").table
      searchable:         false
      controlBarLocation: $('.control-bar')
      datatableOptions:
        "oLanguage":
          "sEmptyTable":    "No files have been added.  Click 'Add new file' above to add a new one."
        "aaSorting":      [[0, 'asc']]
        "aoColumns": [
          {"bSortable": false}
          {}
          {}
          {}
        ]

    # Add an input hint to the search input
    $('#search').inputHint
      fadeOutSpeed: 300
      padding: '2px'
      paddingLeft: '5px'
