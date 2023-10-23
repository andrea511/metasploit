jQuery ($) ->
  $(document).ready ->
    $("table#attack-list").table
      searchable:         false
      controlBarLocation: $('.control-bar')
      datatableOptions:
        "oLanguage":
          "sEmptyTable":    "No target lists are associated with this project. Click 'Create Target List' above to create a new one."
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

    # make the export button work
    $('.button a.export_data').click (e) ->
      id = $("table.list tbody tr td input[type='checkbox']").filter(':checked').attr('value')
      window.location.href += '/' + id + '/export.csv'
      e.preventDefault()
