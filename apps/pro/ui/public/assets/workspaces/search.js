(function() {

  jQuery(function($) {
    return $(function() {
      var switchButton;
      switchButton = function($button) {
        if ($button.hasClass('expanded')) {
          $button.removeClass('expanded');
          return $button.addClass('collapsed');
        } else {
          $button.removeClass('collapsed');
          return $button.addClass('expanded');
        }
      };
      $(".dashboard-title").live('click', function(e) {
        $(this).parent().find(".step").slideToggle();
        return switchButton($(this).find(".expanded, .collapsed"));
      });
      $(document).ready(function() {
        var $hostsDataTables, $servicesDataTables, $vulnsDataTables;
        $hostsDataTables = $('.hosts-content table').dataTable({
          oLanguage: {
            sProcessing: "Loading...",
            sEmptyTable: "No hosts found."
          },
          aaSorting: [[0, 'desc']],
          bStateSave: false,
          bFilter: false,
          aoColumns: [
            {
              "mDataProp": "address"
            }, {
              "mDataProp": "name"
            }, {
              "mDataProp": "os"
            }, {
              "mDataProp": "version"
            }, {
              "mDataProp": "purpose"
            }
          ]
        });
        $servicesDataTables = $('.services-content table').dataTable({
          oLanguage: {
            sProcessing: "Loading...",
            sEmptyTable: "No services found."
          },
          aaSorting: [[0, 'desc']],
          bStateSave: false,
          bFilter: false,
          aoColumns: [
            {
              "mDataProp": "address"
            }, {
              "mDataProp": "name"
            }, {
              "mDataProp": "port",
              "sWidth": "65px"
            }, {
              "mDataProp": "protocol",
              "sWidth": "65px"
            }, {
              "mDataProp": "info"
            }
          ]
        });
        return $vulnsDataTables = $('.vulns-content table').dataTable({
          oLanguage: {
            sProcessing: "Loading...",
            sEmptyTable: "No services found."
          },
          aaSorting: [[0, 'desc']],
          bStateSave: false,
          bFilter: false
        });
      });
      return $('a.full-ref-map-view').live('click', function(e) {
        var $dialog;
        $dialog = $("<div style='display:hidden'>" + ($(this).closest('table').siblings('.full-ref-map').html()) + "</div>").appendTo('body');
        $dialog.dialog({
          title: "References",
          width: 500,
          maxHeight: 500,
          buttons: {
            "Close": function() {
              return $(this).dialog('close');
            }
          }
        });
        return e.preventDefault();
      });
    });
  });

}).call(this);
