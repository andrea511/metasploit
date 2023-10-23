(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var $container, $table,
        _this = this;
      $container = $('div#saved_exports');
      $table = $container.find('table#exports');
      $table.table({
        searchInputHint: "Search Exports",
        datatableOptions: {
          bServerSide: true,
          bProcessing: true,
          aaSorting: [[5, 'desc']],
          sAjaxSource: "/workspaces/" + WORKSPACE_ID + "/exports.json",
          oLanguage: {
            sEmptyTable: "No exports have been generated for this project."
          },
          aoColumns: [
            {
              mDataProp: "id",
              bSortable: false,
              fnRender: function(row) {
                row.aData.export_id = row.aData.id;
                return "<input type='checkbox' name='export_ids[]' value='" + (_.escape(row.aData.export_id)) + "' />";
              }
            }, {
              mDataProp: "file_path"
            }, {
              bSortable: false,
              mDataProp: "etype"
            }, {
              mDataProp: "created_by"
            }, {
              mDataProp: "state",
              fnRender: function(row) {
                return _.str.capitalize(row.aData.state);
              }
            }, {
              mDataProp: "created_at",
              fnRender: function(row) {
                return moment(row.aData.created_at).format('MMMM DD, YYYY h:mm a');
              }
            }, {
              sType: "title-numeric",
              bSortable: false,
              fnRender: function(row) {
                if (row.aData['state'] === 'Complete') {
                  return "<a class='export_download' href='/workspaces/" + WORKSPACE_ID + "/exports/" + (_.escape(row.aData.export_id)) + "/download'>Download</a>";
                } else {
                  return '';
                }
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
            return alert('Unable to delete export');
          }
        });
      });
    });
  });

}).call(this);
