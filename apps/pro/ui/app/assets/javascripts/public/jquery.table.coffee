# table plugin
#
# Adds sorting and other dynamic functions to tables.
jQuery ($) ->
  $.table =
    defaults:
      searchable:        true
      searchInputHint:   'Search'
      sortableClass:     'sortable'
      setFilteringDelay: false
      datatableOptions:
        bStateSave:    true
        oLanguage:
          sSearch:  ""
          sProcessing:    "Loading..."
        fnDrawCallback: ->
          $.table.controlBar.buttons.enable()
        sDom: '<"control-bar"f>t<"list-table-footer clearfix"ip <"sel" l>>r'
        sPaginationType: 'r7Style'
        fnInitComplete: (oSettings, json) ->
           # if old search term saved, display it
          searchTerm = getParameterByName 'search'
          $searchBox = $('#search', $(this).parents().eq(3))

          if searchTerm
            $searchBox.val(searchTerm)
            $searchBox.focus()

          # insert the cancel button to the left of the search box
          $searchBox.before('<a class="cancel-search" href="#"></a>')
          $a = $('.cancel-search')
          table = @
          searchTerm = $searchBox.val()
          searchBox = $searchBox.eq(0)
          $a.hide() if (!searchTerm || searchTerm.length < 1)

          $a.click (e) ->  # called when red X is clicked
            table.fnFilter ''
            $(searchBox).blur()           # blur to trigger filler text
            e.preventDefault()            # Other control code can be found in filteringDelay.js plugin. 

          # bind to fnFilter() calls
          # do this by saving fnFilter to fnFilterOld & overriding
          table['fnFilterOld'] = table.fnFilter
          table.fnFilter = (str) ->
            $('.cancel-search').toggle(str && str.length > 0)
            start = $searchBox[0].selectionStart
            end = $searchBox[0].selectionEnd
            table.fnFilterOld(str)
            $searchBox[0].setSelectionRange(start, end) if $searchBox[0].setSelectionRange?

          if searchTerm? and searchTerm.length
            _.defer -> table.fnFilter(searchTerm)

      analysisTabOptions:
        "aLengthMenu":      [[10, 50, 100, 250, 500, -1], [10, 50, 100, 250, 500, "All"]]
        "iDisplayLength":   100
        "bProcessing":      true
        "bServerSide":      true
        "bSortMulti":       false

    checkboxes:
      bind: ->
        # TODO: This and any other 'table.list' selectors that appear in the plugin
        # code will trigger all sortable tables visible on the page.
       $("table.list thead tr th input[type='checkbox']").on 'click', null, (e) ->
          $table = $(e.currentTarget).parents('table').first()
          return unless $table.data('dataTableObject')?
          $checkboxes = $table.find("input[type='checkbox']", "table.list tbody tr td:nth-child(1)")
          if $(this).prop 'checked'
            $checkboxes.prop 'checked', true
          else
            $checkboxes.prop 'checked', false

    controlBar:
      buttons:
        # Disables/enables buttons based on number of checkboxes selected,
        # and the class name.
        enable: ->
          numChecked = $("tbody tr td input[type='checkbox']", "table.list").filter(':checked').not('.invisible').size()
          disable = ($button) ->
            $button.addClass 'disabled'
            $button.children('input').attr 'disabled', 'disabled'
          enable = ($button) ->
            $button.removeClass 'disabled'
            $button.children('input').removeAttr 'disabled'

          switch numChecked
            when 0
              disable $('span.button.single',  '.control-bar')
              disable $('span.button.multiple','.control-bar')
              disable $('span.button.any',     '.control-bar')
            when 1
              enable  $('span.button.single',  '.control-bar')
              disable $('span.button.multiple','.control-bar')
              enable  $('span.button.any',     '.control-bar')
            else
              disable $('span.button.single',  '.control-bar')
              enable  $('span.button.multiple','.control-bar')
              enable  $('span.button.any',     '.control-bar')

        show:
          bind: ->
            # Show button
            $showButton = $('span.button a.show', '.control-bar')
            if $showButton.length
              $showButton.click (e) ->
                unless $showButton.parent('span').hasClass 'disabled'
                  $("table.list tbody tr td input[type='checkbox']").filter(':checked').not('.invisible')
                  hostHref = $("table.list tbody tr td input[type='checkbox']")
                    .filter(':checked')
                    .parents('tr')
                    .children('td:nth-child(2)')
                    .children('a')
                    .attr('href')
                  window.location = hostHref
                e.preventDefault()

        edit:
          bind: ->
            # Settings button
            $editButton = $('span.button a.edit', '.control-bar')
            if $editButton.length
              $editButton.click (e) ->
                unless $editButton.parent('span').hasClass 'disabled'
                  $("table.list tbody tr td input[type='checkbox']").filter(':checked').not('.invisible')
                  hostHref = $("table.list tbody tr td input[type='checkbox']")
                    .filter(':checked')
                    .parents('tr')
                    .children('td:nth-child(2)')
                    .children('span.settings-url')
                    .html()
                  window.location = hostHref
                e.preventDefault()

        bind: (options) ->
          # Move the buttons into the control bar.
          $('.control-bar').prepend($('.control-bar-items').html())
          $('.control-bar-items').remove()

          # Move the control bar to a new location, if specified.
          if !!options.controlBarLocation
            $('.control-bar').appendTo(options.controlBarLocation)

          this.enable()
          this.show.bind()
          this.edit.bind()

      bind: ($table, options) ->
        this.buttons.bind(options)
        $last_selected_row = null
        $table.on 'click',"input[type='checkbox']", (e) =>
          # Redraw the buttons with each checkbox click.
          this.buttons.enable()
          $checkbox  = $(e.currentTarget)
          $dat_table = $checkbox.parents('table').first()
          $dat_row   = $checkbox.parents('tr').first()
          if e.shiftKey and $last_selected_row? # add some shift-clickiness
            idx1 = $dat_row.index()
            idx2 = $last_selected_row.index()
            if idx2 < idx1
              tmp = idx2
              idx2 = idx1
              idx1 = tmp
            $all_trs = $dat_row.parent().find('tr').slice(idx1, idx2)
            # determine whether to check or uncheck depending on last checkbox state
            checked = $last_selected_row.find('input[type=checkbox]').is(':checked')
            $('input[type=checkbox]', $all_trs).attr('checked', checked)
          $last_selected_row = $dat_row

    searchField:
      # Add an input hint to the search field.
      addInputHint: (options, $table) ->
        if options.searchable
          # if the searchbar is in a control bar, expand selector scope to include control bar
          searchScope = $table.parents().eq(3) if !!options.controlBarLocation
          searchScope ||= $table.parents().eq(2)  # otherwise limit scope to just the table
          $searchInput = $('.dataTables_filter input', searchScope)
          # We'll need this id set for the checkbox functions.
          $searchInput.attr 'id', 'search'
          $searchInput.attr 'placeholder', options.searchInputHint
          $searchInput.inputHint()

    bind: ($table, options) ->
      $tbody = $table.children('tbody')
      dataTable = null
      # Turn the table into a DataTable.
      if $table.hasClass options.sortableClass
        # Don't mess with the search input if there's no control bar.
        unless $('.control-bar-items').length
          options.datatableOptions["sDom"] = '<"list-table-header clearfix"lfr>t<"list-table-footer clearfix"ip>'

        datatableOptions = options.datatableOptions
        # If we're loading under the Analysis tab, then load the standard
        # Analysis tab options.
        if options.analysisTab
          $.extend(datatableOptions, options.analysisTabOptions)
          options.setFilteringDelay = true
          options.controlBarLocation = $('.analysis-control-bar')

        dataTable = $table.dataTable(datatableOptions)
        $table.data('dataTableObject', dataTable)
        dataTable.fnSetFilteringDelay(500) if options.setFilteringDelay

        # If we're loading under the Analysis tab, then load the standard Analysis tab functions.
        if options.analysisTab
          # Gray out the table during loads.
          $("##{$table.attr('id')}_processing").watch 'visibility', ->
            if $(this).css('visibility') == 'visible'
              $table.css opacity: 0.6
            else
              $table.css opacity: 1

          # Checking a host_ids checkbox should also check the invisible related object checkbox.
          $table.on 'change', 'tbody tr td input[type=checkbox].hosts', ->
            $(this).siblings('input[type=checkbox]').prop('checked', $(this).prop('checked'))

        this.checkboxes.bind()
        this.controlBar.bind($table, options)
        # Add an input hint to the search field.
        this.searchField.addInputHint(options, $table)
        # Keep width at 100%.
        $table.css('width', '100%')

  $.fn.table = (options) ->
    settings = $.extend true, {}, $.table.defaults, options
    $table   = $(this)
    return this.each -> $.table.bind($table, settings)

  # adds a collapsible search to the datatable's control bar
  $.fn.addCollapsibleSearch = (options) ->
    $('.button .search').click (e) ->
      $filter = $('.dataTables_filter')
      $input = $('input', $filter)
      if $filter.css('bottom').charAt(0) == '-' # if (css matches -42px)
        # input box is visible, hide it
        # only allow user to hide if there is no search string
        if !$input.val() || $input.val().length < 1
          $filter.css('bottom', '1000px')
      else # input box is invisible, display it
        $filter.css('bottom', '-42px')
        $input.focus()  # auto-focus input
      e.preventDefault()
    searchVal = $('.dataTables_filter input').val()
    $('.button .search').click() if searchVal && searchVal.length > 0
