(function() {

  jQuery(function($) {
    return $(function() {
      var $notesDataTable, $notesTable, notesCombinedPath;
      notesCombinedPath = $('#notes-combined-path').html();
      $notesTable = $('#notes-table');
      return $notesDataTable = $notesTable.table({
        analysisTab: true,
        controlBarLocation: $('.analysis-control-bar'),
        datatableOptions: {
          "oLanguage": {
            "sEmptyTable": "No notes are associated with this project."
          },
          "sAjaxSource": notesCombinedPath,
          "aaSorting": [[1, 'desc']],
          "aoColumns": [
            {
              "mDataProp": "type"
            }, {
              "mDataProp": "host_count",
              "sWidth": "80px"
            }
          ]
        }
      });
    });
  });

}).call(this);
