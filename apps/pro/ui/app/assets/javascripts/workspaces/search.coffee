jQuery ($) ->
  $ ->
    # Switch between expanded/collapsed view for buttons.
    switchButton= ($button) ->
      if $button.hasClass 'expanded'
        $button.removeClass 'expanded'
        $button.addClass 'collapsed'
      else
        $button.removeClass 'collapsed'
        $button.addClass 'expanded'

    # Expand/collapse sections on arrow button click.
    $(".dashboard-title").live 'click', (e) ->
      $(this).parent().find(".step").slideToggle()
      switchButton($(this).find(".expanded, .collapsed"))


    $(document).ready ->
      # Convert <table>'s into datatables
      $hostsDataTables = $('.hosts-content table').dataTable
        oLanguage:
          sProcessing:    "Loading..."
          sEmptyTable:    "No hosts found."
        aaSorting:      [[0, 'desc']]
        bStateSave:    false
        bFilter: false
        aoColumns: [
          {"mDataProp": "address"}
          {"mDataProp": "name"}
          {"mDataProp": "os"}
          {"mDataProp": "version"}
          {"mDataProp": "purpose"}
        ]
      $servicesDataTables = $('.services-content table').dataTable
        oLanguage:
          sProcessing:    "Loading..."
          sEmptyTable:    "No services found."
        aaSorting:      [[0, 'desc']]
        bStateSave:    false
        bFilter: false
        aoColumns: [
          {"mDataProp": "address"}
          {"mDataProp": "name"}
          {"mDataProp": "port", "sWidth": "65px"}
          {"mDataProp": "protocol", "sWidth": "65px"}
          {"mDataProp": "info"}
        ]

      $vulnsDataTables = $('.vulns-content table').dataTable
        oLanguage:
          sProcessing:    "Loading..."
          sEmptyTable:    "No services found."
        aaSorting:      [[0, 'desc']]
        bStateSave:    false
        bFilter: false


    # View ref data in a dialog.
    $('a.full-ref-map-view').live 'click', (e) ->
      $dialog = $("<div style='display:hidden'>#{$(this).closest('table').siblings('.full-ref-map').html()}</div>").appendTo('body')
      $dialog.dialog
        title: "References"
        width: 500
        maxHeight: 500
        buttons:
          "Close": -> 
            $(this).dialog('close')
      e.preventDefault()

