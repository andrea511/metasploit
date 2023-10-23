(function() {

  jQuery(function($) {
    return $(function() {
      var $vulnsDataTable, $vulnsTable, cols, run_id, vuln_validation, vulnsPath;
      run_id = window.helpers.urlParam('run_id');
      if (run_id != null) {
        $('#exploitation_run').val(run_id);
      }
      vulnsPath = $('#vulns-path').html();
      $vulnsTable = $('#vulns-table');
      vuln_validation = $('[name=vuln_validation]').attr('content') === 'true';
      if (vuln_validation) {
        cols = [
          {
            mDataProp: "checkbox",
            "bSortable": false
          }, {
            mDataProp: "host",
            "sWidth": "200px"
          }, {
            mDataProp: "service",
            "sWidth": "60px",
            "bSortable": false
          }, {
            mDataProp: "name",
            "sWidth": "400px"
          }, {
            mDataProp: "status",
            "sWidth": "180px",
            "bSortable": false
          }, {
            mDataProp: "refs",
            "bSortable": false
          }
        ];
      } else {
        cols = [
          {
            mDataProp: "checkbox",
            "bSortable": false
          }, {
            mDataProp: "host",
            "sWidth": "200px"
          }, {
            mDataProp: "service",
            "sWidth": "60px",
            "bSortable": false
          }, {
            mDataProp: "name",
            "sWidth": "400px"
          }, {
            mDataProp: "exploits",
            "sWidth": "22px"
          }, {
            mDataProp: "refs",
            "bSortable": false
          }
        ];
      }
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
      $(document).on('click', 'a.full-ref-map-view', function(e) {
        var $dialog;
        $dialog = $("<div style='display:hidden'>" + ($(this).closest('table').siblings('.full-ref-map').html()) + "</div>").appendTo('body');
        $dialog.dialog({
          title: "References",
          width: 600,
          maxHeight: 500,
          buttons: {
            "Close": function() {
              return $(this).dialog('close');
            }
          }
        });
        return e.preventDefault();
      });
      $('.arrow .btn a, .create-exception.dropdown').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        return $('.btns .dropdown-list').toggle();
      });
      $(document).on('click', function() {
        return $('.btns .dropdown-list').hide();
      });
      $('.dropdown-list .all').on('click', function() {
        var get_params;
        run_id = $('#exploitation_run').val();
        $('input[name="host_ids[]"]:checked').each(function(index, elem) {
          return $('input[name="vuln_ids[]"]', $(elem).closest('td')).prop('checked', true);
        });
        get_params = $('input[name="vuln_ids[]"]').serialize();
        get_params = get_params + ("&run_id=" + run_id);
        return window.location = "/workspaces/" + WORKSPACE_ID + "/tasks/new_nexpose_exception_push?" + get_params;
      });
      $('.create-exception .nexpose').on('click', function() {
        var get_params;
        $('div[data-status="exploited"]').each(function(index, elem) {
          return $('input[name="vuln_ids[]"]', $(elem).closest('tr')).prop('checked', true);
        });
        get_params = $('input[name="vuln_ids[]"]').serialize();
        return $.ajax({
          url: "/workspaces/" + WORKSPACE_ID + "/nexpose/result/push_validations",
          data: get_params,
          success: function(json) {
            return window.location = json.redirect_url;
          }
        });
      });
      $('.dropdown-list .non-exploited').on('click', function() {
        var get_params;
        $('div[data-status="not_exploited"]').each(function(index, elem) {
          return $('input[name="vuln_ids[]"]', $(elem).closest('tr')).prop('checked', true);
        });
        run_id = $('#exploitation_run').val();
        get_params = $('input[name="vuln_ids[]"]').serialize();
        get_params = get_params + ("&run_id=" + run_id);
        return window.location = "/workspaces/" + WORKSPACE_ID + "/tasks/new_nexpose_exception_push?" + get_params;
      });
      $('#exploitation_run').on('change', function(e) {
        run_id = $(e.target).val();
        return window.location = "/workspaces/" + WORKSPACE_ID + "/vulns?run_id=" + run_id;
      });
      return $vulnsTable.addCollapsibleSearch();
    });
  });

}).call(this);
