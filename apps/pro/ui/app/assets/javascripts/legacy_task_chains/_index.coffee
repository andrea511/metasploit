jQuery ($) ->
  $(document).ready ->
    $("#task-chains").table
      searchable:         true
      controlBarLocation: $('.analysis-control-bar')
      searchInputHint:   'Search Task Chains'
      datatableOptions:
        "oLanguage":
          "sEmptyTable":    "No task chains are associated with this project. Click 'Create Chain' above to create a new one."
        "aaSorting":      [[0, 'asc']]
        "aoColumns": [
          {"bSortable": false}
          {}
          {}
          {}
          {}
          {}
          {}
          {}
        ]

