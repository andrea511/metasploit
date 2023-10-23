#Begin Plugin
jQuery ($) -> $(document).ready(->
  $.fn.dataTableExt.oApi.fnInitEditRow = ->

    oSettings  = @fnSettings()

    #Plugin vars
    EDIT_BUTTON = "<div class='edit-table-row'><a class='pencil' href='javascript:void(0)'></a><a href='javascript:void(0)' class='garbage'></a></span></div>"
    EDIT_COLUMN = "<div class='edit-table-row'><a href='javascript:void(0)' class='save'> Save </a><a href='javascript:void(0)' class='cancel'> Cancel </a></div>"
    EDIT_RENDER_COLUMN = EDIT_BUTTON

    #Datatable vars
    aoColumns = oSettings.aoColumns
    oApi = oSettings.oApi
    editableOpts = oSettings.editableOpts

    cachedRows = []

    selectOptions = {}

    _generate_options_html = ($col,colId) =>
      str = "<select>"
      for option in editableOpts[colId].options
        selected = if $col.html()==option.content then "selected='selected'" else ""
        str = str+"<option value='#{option.value}' #{selected}>#{option.content}</option>"
      str = str+"</select>"

    _show_edit_column_options = ($col) =>
      $col.html(EDIT_COLUMN)

    _show_edit_column = ($col, colId) =>
      switch editableOpts[colId].type
        when "select"
          html = _generate_options_html($col,colId)
          $col.html(html)
        when "field"
          idValue = ''
          unless editableOpts[colId].id == undefined
            idValue = "id='#{editableOpts[colId].id}'"
          safe_html = _.escapeHTML(_.unescapeHTML($col.html()))
          $col.html("<input type='text' #{idValue} value='#{safe_html}'/>")

    _bind_close_event = =>
      $('.edit-table-row .cancel', oSettings.nTable).on('click',(e)=>
        $row = $(e.currentTarget).closest('tr')
        rowId = @fnGetPosition($row[0])

        if $('.error').size()>0
          oSettings.aoData = cachedRows
        else
          cachedRows = _cacheRows()

        for col in [0...oSettings.aoColumns.length]
          propName = aoColumns[col].mDataProp
          @fnUpdate(oSettings.aoData[rowId]._aData[propName],rowId,col, false)

        _display_edit_columns()
      )

    _reset_rows = =>
      for row in [0...oSettings.aoData.length]
        for col in [0...oSettings.aoColumns.length]
          propName = aoColumns[col].mDataProp
          @fnUpdate(oSettings.aoData[row]._aData[propName],row,col, false)


    _bind_edit_event = =>
      #Change row to Edit Mode
      $(oSettings.nTable).off('click', '.edit-table-row .pencil')
      $(oSettings.nTable).on('click','.edit-table-row .pencil',(e) =>
        $row = $(e.currentTarget).closest('tr')
        rowId = @fnGetPosition($row[0])
        if $('.error').size()>0
          oSettings.aoData = cachedRows
        else
          cachedRows = _cacheRows()
        _reset_rows()
        _display_edit_columns()
        _enable_row_edit($row)
      )

    _ajax_delete_row = (data) =>
      data = {aaData:data}
      $.ajax(
        type: "DELETE"
        url: oSettings.sAjaxDelete
        data: data
      )


    _ajax_post_row = (data, $row) ->
      data = {aaData:data}
      opts = {data:data, $row: $row}
      $.ajax(
        context: opts
        type: "PATCH"
        url: oSettings.sAjaxDestination
        data: data
        success: () ->
          _reset_rows()
          $(oSettings.nTable).trigger('rowAdded', oSettings.fnRecordsTotal())
          _display_edit_columns()
        error: (e)->
          $('.error').remove()
          response = $.parseJSON(e.responseText)
          _.each(response.error, (val,key)->
            for col in [0...oSettings.aoColumns.length]
              if oSettings.aoColumns[col].mDataProp==key
                cols = $row.find('td')
                $col = $(cols[col])
                $msg = $('<div />', class: 'error').text(val[0])
                $('input', $col).addClass('invalid').after($msg)
          ,this)
      )

    _ensure_aData_hash = (aData) ->
      aDataHash = {}
      if aData.constructor == Array
        for col in [0...oSettings.aoColumns.length]
          mDataProp = oSettings.aoColumns[col].mDataProp
          if editableOpts[col].type != "none" and editableOpts[col].type != "control" || mDataProp == "id"
            if editableOpts[col].type== "select"
              aDataHash[mDataProp] = selectOptions[mDataProp]
            else
              aDataHash[mDataProp] = aData[mDataProp]
        aDataHash
      else
        aData


    _parse_row_data = ($row,rowId) =>
      $cols = $row.find('td')

      for col in [0...oSettings.aoColumns.length]
        colName = oSettings.aoColumns[col].mDataProp
        switch editableOpts[col].type
          when "select"
            $elem = $("select :selected",$cols[col])
            html  = $elem.text()
            oSettings.aoData[rowId]._aData[colName] = $elem.html()
            selectOptions[colName] = $elem.val()

          when "field"
            html  = $("input",$cols[col]).val()
            oSettings.aoData[rowId]._aData[colName] = html

    _bind_save_event = =>
      $('.edit-table-row .save', oSettings.nTable).on('click', (e) =>
        $row = $(e.currentTarget).closest('tr')
        rowId = @fnGetPosition($row[0])
        _parse_row_data($row,rowId)
        data = _ensure_aData_hash(oSettings.aoData[rowId]._aData)
        _ajax_post_row(data, $row)
      )

    _bind_delete_event = =>
      $(oSettings.nTable).off('click', '.edit-table-row .garbage')
      $(oSettings.nTable).on('click','.edit-table-row .garbage', (e)=>
        if window.confirm("Are you sure you want to delete item?")
          $row = $(e.currentTarget).closest('tr')
          rowId = @fnGetPosition($row[0])
          _reset_rows()
          _display_edit_columns()
          data = _ensure_aData_hash(oSettings.aoData[rowId]._aData)
          _ajax_delete_row(data)
          records_total = oSettings.fnRecordsTotal()
          count =  if records_total>0 then records_total-1 else 0
          @fnDeleteRow(rowId, 0, true)
          $(oSettings.nTable).trigger('rowDeleted', count)
      )

    _enable_row_edit = ($row) =>
      rowId = @fnGetPosition($row[0])
      $cols = $row.find('td')
      for col in [0...oSettings.aoColumns.length]
        unless(editableOpts[col].type=="control" || editableOpts[col].type=="none")
          _show_edit_column($($cols[col]),col)
        if editableOpts[col].type=="control"
          _show_edit_column_options($($cols[col]))
      _bind_save_event()
      _bind_close_event()


    _display_edit_columns = =>
      #Render Control for Columns
      $.map(editableOpts, (val,colId) =>
        if editableOpts[colId].type == "control"
          aoColumns[colId].fnRender = -> EDIT_RENDER_COLUMN
          for row in [0...oSettings.aoData.length]
            @fnUpdate("",row,colId, false)
          _bind_edit_event()
          _bind_delete_event()
      )

    _cacheRows = ->
      opts = {cachedRows: cachedRows}
      cachedRows = []
      _.each(oSettings.aoData, (row)->
        cachedRows.push($.extend(true,{}, row ))
      ,opts)
      cachedRows

    _edit_row_init = =>
      #Infinite Recursion otherwise. We want to only run this on the first draw
      oSettings.aoDrawCallback.pop()
      #Render Control for Columns
      _display_edit_columns()
      _cacheRows()

    init_plugin = =>
      #Init Plugin
      oSettings.aoDrawCallback.push
        fn: _edit_row_init
        sName: "edit_row"

    init_plugin()
)


