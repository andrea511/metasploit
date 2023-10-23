# TODO: determine if this file is used anywhere

jQuery ($) ->
  $ ->
    servicesCombinedPath = $('#services-combined-path').html()
    $servicesTable = $('#services-table')

    # Enable DataTable for the services list.
    $servicesDataTable = $servicesTable.table
      analysisTab: true
      searchInputHint:   "Search Services"
      datatableOptions:
        "oLanguage":
          "sEmptyTable":    "No services are associated with this project."
        "aaSorting":        [[4, 'desc']]
        "sAjaxSource":      servicesCombinedPath
        "aoColumns": [
          {"mDataProp": "name", "sWidth": "125px"},
          {"mDataProp": "protocol", "sWidth": "60px"},
          {"mDataProp": "port", "sWidth": "50px"},
          {"mDataProp": "info", "fnRender": (o) -> _.escapeHTML(_.unescapeHTML(o.aData)) },
          {"mDataProp": "host_count", "sWidth": "150px"}
        ]
