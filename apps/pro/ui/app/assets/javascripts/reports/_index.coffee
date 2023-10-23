jQuery ($) ->
  $(document).ready ->
    $container = $('div#saved_reports')
    $table = $container.find('table#reports')

    $table.table
      searchInputHint:    "Search Reports"
      datatableOptions:
        bServerSide: true,
        aaSorting: [[5, 'desc']],
        bProcessing: true,
        sAjaxSource: "/workspaces/#{WORKSPACE_ID}/reports.json"
        oLanguage:
          sEmptyTable: "No reports have been generated for this project."
        aoColumns: [
          {
            mDataProp:"id", bSortable: false,
            fnRender: (row) =>
              row.aData.report_id = row.aData.id
              "<input type='checkbox' name='report_ids[]' value='#{_.escape(row.aData.report_id)}' />"
          }
          {
            mDataProp:"name",
            fnRender: (row) =>
                "<a class='report_view' href='/workspaces/#{WORKSPACE_ID}/reports/#{_.escape(row.aData.report_id)}'>#{row.aData.name}</a>"
          }
          { mDataProp:"report_type" }
          { bSortable: false, mDataProp:"file_formats" }
          { mDataProp:"created_by" }
          {
            mDataProp:"created_at",
            fnRender: (row) =>
              moment(row.aData.created_at).format('MMMM DD, YYYY h:mm a')
          }
          {
            mDataProp:"updated_at",
            fnRender: (row) =>
              moment(row.aData.updated_at).format('MMMM DD, YYYY h:mm a')
          }
          {
            sType: "title-numeric", bSortable: false,
            fnRender: (row) =>
                "<a class='report_view' href='/workspaces/#{WORKSPACE_ID}/reports/#{_.escape(row.aData.report_id)}'>View</a> | <a class='report_clone' href='/workspaces/#{WORKSPACE_ID}/reports/#{_.escape(row.aData.report_id)}/clone'>Clone</a>"
          }
        ]

    $table.on "reload-datatable", (e) -> $table.dataTable().fnReloadAjax()

    # Poll to refresh table content.
    setInterval((=> $table.trigger('reload-datatable')), 15000)

    # Report delete button should confirm deletion and verify that reports have
    # been selected.
    $container.find('#user-delete-submit').on 'click', (e) ->
      e.preventDefault()
      e.stopPropagation()
      return unless confirm($(@).attr('data-confirm'))
      formData = $table.find(':input:checked').serializeArray()
      formData.push({name: '_method', value: 'DELETE'})
      $.ajax
        url: $(@).attr('href')
        type: 'POST'
        data: formData
        success: => $table.trigger('reload-datatable')
        error: => alert('Unable to delete report')
