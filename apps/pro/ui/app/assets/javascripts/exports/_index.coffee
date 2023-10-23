jQuery ($) ->
  $(document).ready ->
    $container = $('div#saved_exports')
    $table = $container.find('table#exports')

    $table.table
      searchInputHint:    "Search Exports"
      datatableOptions:
        bServerSide: true,
        bProcessing: true,
        aaSorting: [[5, 'desc']],
        sAjaxSource: "/workspaces/#{WORKSPACE_ID}/exports.json"
        oLanguage:
          sEmptyTable: "No exports have been generated for this project."
        aoColumns: [
          {
            mDataProp:"id", bSortable: false,
            fnRender: (row) =>
              row.aData.export_id = row.aData.id
              "<input type='checkbox' name='export_ids[]' value='#{_.escape(row.aData.export_id)}' />"
          }
          { mDataProp:"file_path" }
          { bSortable: false, mDataProp:"etype" }
          { mDataProp:"created_by" }
          {
            mDataProp:"state",
            fnRender: (row) => _.str.capitalize(row.aData.state)
          }
          {
            mDataProp:"created_at",
            fnRender: (row) =>
              moment(row.aData.created_at).format('MMMM DD, YYYY h:mm a')
          }
          {
            sType: "title-numeric", bSortable: false,
            fnRender: (row) =>
              if row.aData['state'] == 'Complete'
                "<a class='export_download' href='/workspaces/#{WORKSPACE_ID}/exports/#{_.escape(row.aData.export_id)}/download'>Download</a>"
              else
                ''
          }
        ]

    $table.on "reload-datatable", (e) -> $table.dataTable().fnReloadAjax()

    # Poll to refresh table content.
    setInterval((=> $table.trigger('reload-datatable')), 15000)

    # Export delete button should confirm deletion and verify that exports have
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
        error: => alert('Unable to delete export')