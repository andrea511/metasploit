jQuery ($) ->
  sortCreds = ->
    $('#creds-table').table
        searchInputHint:      "Search credentials"
        datatableOptions:
          "aoColumns": [
            "bSortable":        false
            #"sType":            "title-numeric"
            null
            null
            null
            null
            null
            null
            null
          ]
          "oLanguage":
            "sEmptyTable":      "No tokens are associated with this host. Click 'New Token' above to add one."

  sortVulns = ->
    # Vulns table should be searchable and sortable.
    $("#vulns-table").table
        searchInputHint:      "Search vulnerabilities"
        datatableOptions:
          "aaSorting":        [[2, 'desc']]
          "aoColumns": [
            null
            "bSortable":        false
            null
            "bSortable":        false
            null
          ]
          "oLanguage":
            "sEmptyTable":      "No vulnerabilities are associated with this host. Click 'Add Vulnerability' above to add one."

  sortAttempts = ->
    # Vulns table should be searchable and sortable.
    $("#attempts-table").table
        searchInputHint:      "Search exploit attempts"
        datatableOptions:
          "aaSorting":        [[0, 'desc']]
          "aoColumns": [
            null
            null
            null
            null
            null
            null
            null
          ]
          "oLanguage":
            "sEmptyTable":      "No exploit attempts associated with this host."

  sortExploits = ->
    # Exploits table should be searchable and sortable.
    $("#exploits-table").table
        searchInputHint:      "Search available exploits"
        datatableOptions:
          "aaSorting":        [[0, 'desc']]
          "aoColumns": [
            null
            null
            null
            null
          ]
          "oLanguage":
            "sEmptyTable":      "No exploits have been matched with this host."


  window.moduleLinksInit=(moduleRunPathFragment) ->
      formId = "#new_module_run"
      $('a.module-name').click (event) ->
        if $(this).attr('href') isnt "#"
          return true
        else
          pathPiece = $(this).attr('module_fullname')
          modAction = "#{moduleRunPathFragment}/#{pathPiece}" # slash is in fragment
          theForm = $(formId)
          theForm.attr('action', modAction)
          theForm.submit()
          return false

  $(document).ready ->
    $selTab = $('#tabs>ul>li>a').filter -> $(this).attr('title') == document.location.hash
    selIdx = $selTab.parent('li').index()
    selIdx = 0 if selIdx < 0

    $("#tabs").tabs
      active: selIdx
      spinner:  'Loading...'
      cache:    true
      load:     (e, ui) ->
        href = ui.tab.find('a').attr('href')
        $(ui.newPanel).find(".tab-loading").remove();
        if href.indexOf("vulns") > -1
          sortVulns()
        if href.indexOf("creds") > -1
          sortCreds()
        if href.indexOf("attempts") > -1
          sortAttempts()
        if href.indexOf("exploits") > -1
          sortExploits()
      activate:   (e, ui) ->
        $panel = $(ui.newPanel)
        if $panel.is(":empty")
          $panel.html("<div class='tab-loading'></div>")

    window.moduleLinksInit($("meta[name='msp:module_run_path']").attr('content'))

