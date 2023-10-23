(function() {

  jQuery(function($) {
    return $(function() {
      var $vulnsDataTable, $vulnsTable, vulnsPath;
      vulnsPath = $('#vulns-path').html();
      $vulnsTable = $('#vulns-table');
      $vulnsDataTable = $vulnsTable.table({
        analysisTab: true,
        searchInputHint: "Search Vulnerabilities",
        datatableOptions: {
          oLanguage: {
            sEmptyTable: "No vulnerabilities are associated with this project."
          },
          sAjaxSource: vulnsPath,
          aaSorting: [[4, 'asc'], [2, 'asc']],
          aoColumns: cols,
          fnServerData: function(sSource, aoData, fnCallback, oSettings) {
            aoData.push({
              name: 'automatic_exploitation_run',
              value: $('option:selected', '#exploitation_run').val()
            });
            return oSettings.jqXHR = $.ajax({
              dataType: 'json',
              type: "GET",
              url: vulnsPath,
              data: aoData,
              success: fnCallback
            });
          }
        }
      });
      return $vulnsTable.addCollapsibleSearch();
    });
  });

}).call(this);
