(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var $container, $table,
        _this = this;
      $container = $('div#saved_reports');
      $table = $container.find('table#reports');
      $table.table({
        searchInputHint: "Search Reports",
        datatableOptions: {
          bServerSide: true,
          aaSorting: [[5, 'desc']],
          bProcessing: true,
          sAjaxSource: "/workspaces/" + WORKSPACE_ID + "/reports.json",
          oLanguage: {
            sEmptyTable: "No reports have been generated for this project."
          },
          aoColumns: [
            {
              mDataProp: "id",
              bSortable: false,
              fnRender: function(row) {
                row.aData.report_id = row.aData.id;
                return "<input type='checkbox' name='report_ids[]' value='" + (_.escape(row.aData.report_id)) + "' />";
              }
            }, {
              mDataProp: "name",
              fnRender: function(row) {
                return "<a class='report_view' href='/workspaces/" + WORKSPACE_ID + "/reports/" + (_.escape(row.aData.report_id)) + "'>" + row.aData.name + "</a>";
              }
            }, {
              mDataProp: "report_type"
            }, {
              bSortable: false,
              mDataProp: "file_formats"
            }, {
              mDataProp: "created_by"
            }, {
              mDataProp: "created_at",
              fnRender: function(row) {
                return moment(row.aData.created_at).format('MMMM DD, YYYY h:mm a');
              }
            }, {
              mDataProp: "updated_at",
              fnRender: function(row) {
                return moment(row.aData.updated_at).format('MMMM DD, YYYY h:mm a');
              }
            }, {
              sType: "title-numeric",
              bSortable: false,
              fnRender: function(row) {
                return "<a class='report_view' href='/workspaces/" + WORKSPACE_ID + "/reports/" + (_.escape(row.aData.report_id)) + "'>View</a> | <a class='report_clone' href='/workspaces/" + WORKSPACE_ID + "/reports/" + (_.escape(row.aData.report_id)) + "/clone'>Clone</a>";
              }
            }
          ]
        }
      });
      $table.on("reload-datatable", function(e) {
        return $table.dataTable().fnReloadAjax();
      });
      setInterval((function() {
        return $table.trigger('reload-datatable');
      }), 15000);
      return $container.find('#user-delete-submit').on('click', function(e) {
        var formData,
          _this = this;
        e.preventDefault();
        e.stopPropagation();
        if (!confirm($(this).attr('data-confirm'))) {
          return;
        }
        formData = $table.find(':input:checked').serializeArray();
        formData.push({
          name: '_method',
          value: 'DELETE'
        });
        return $.ajax({
          url: $(this).attr('href'),
          type: 'POST',
          data: formData,
          success: function() {
            return $table.trigger('reload-datatable');
          },
          error: function() {
            return alert('Unable to delete report');
          }
        });
      });
    });
  });

}).call(this);
