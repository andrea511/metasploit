jQuery ($) ->
  $ ->
    $(document).ready ->
      t= $("#visits-table").table
        searchable:         false
        controlBarLocation: $('.analysis-control-bar')
        datatableOptions:
          "oLanguage":
            "sEmptyTable":    "No visits associated with this campaign yet"
          "aaSorting":      [[1, 'asc']]
          "bFilter": false
          "aoColumns": [
            {},
            {},
            {}
          ]

