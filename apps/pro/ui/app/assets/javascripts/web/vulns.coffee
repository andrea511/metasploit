jQuery ($) ->
  $(document).ready ->
    $('#vulns-table').table
      datatableOptions:
        controlBarLocation: $('.control-bar')
        "oLanguage":
          "sEmptyTable":    "No vulnerabilities are associated with this site. Try running an audit first."
        "aoColumns": [
          {"mDataProp": "checkbox", "bSortable": false}
          {}
          {}
          {}
          {}
          {}
          {}
          {}
          {}
        ]

