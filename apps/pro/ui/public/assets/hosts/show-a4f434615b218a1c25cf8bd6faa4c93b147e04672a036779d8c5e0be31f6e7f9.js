(function() {

  jQuery(function($) {
    var sortAttempts, sortCreds, sortExploits, sortVulns;
    sortCreds = function() {
      return $('#creds-table').table({
        searchInputHint: "Search credentials",
        datatableOptions: {
          "aoColumns": [
            {
              "bSortable": false
            }, null, null, null, null, null, null, null
          ],
          "oLanguage": {
            "sEmptyTable": "No tokens are associated with this host. Click 'New Token' above to add one."
          }
        }
      });
    };
    sortVulns = function() {
      return $("#vulns-table").table({
        searchInputHint: "Search vulnerabilities",
        datatableOptions: {
          "aaSorting": [[2, 'desc']],
          "aoColumns": [
            null, {
              "bSortable": false
            }, null, {
              "bSortable": false
            }, null
          ],
          "oLanguage": {
            "sEmptyTable": "No vulnerabilities are associated with this host. Click 'Add Vulnerability' above to add one."
          }
        }
      });
    };
    sortAttempts = function() {
      return $("#attempts-table").table({
        searchInputHint: "Search exploit attempts",
        datatableOptions: {
          "aaSorting": [[0, 'desc']],
          "aoColumns": [null, null, null, null, null, null, null],
          "oLanguage": {
            "sEmptyTable": "No exploit attempts associated with this host."
          }
        }
      });
    };
    sortExploits = function() {
      return $("#exploits-table").table({
        searchInputHint: "Search available exploits",
        datatableOptions: {
          "aaSorting": [[0, 'desc']],
          "aoColumns": [null, null, null, null],
          "oLanguage": {
            "sEmptyTable": "No exploits have been matched with this host."
          }
        }
      });
    };
    window.moduleLinksInit = function(moduleRunPathFragment) {
      var formId;
      formId = "#new_module_run";
      return $('a.module-name').click(function(event) {
        var modAction, pathPiece, theForm;
        if ($(this).attr('href') !== "#") {
          return true;
        } else {
          pathPiece = $(this).attr('module_fullname');
          modAction = "" + moduleRunPathFragment + "/" + pathPiece;
          theForm = $(formId);
          theForm.attr('action', modAction);
          theForm.submit();
          return false;
        }
      });
    };
    return $(document).ready(function() {
      var $selTab, selIdx;
      $selTab = $('#tabs>ul>li>a').filter(function() {
        return $(this).attr('title') === document.location.hash;
      });
      selIdx = $selTab.parent('li').index();
      if (selIdx < 0) {
        selIdx = 0;
      }
      $("#tabs").tabs({
        active: selIdx,
        spinner: 'Loading...',
        cache: true,
        load: function(e, ui) {
          var href;
          href = ui.tab.find('a').attr('href');
          $(ui.newPanel).find(".tab-loading").remove();
          if (href.indexOf("vulns") > -1) {
            sortVulns();
          }
          if (href.indexOf("creds") > -1) {
            sortCreds();
          }
          if (href.indexOf("attempts") > -1) {
            sortAttempts();
          }
          if (href.indexOf("exploits") > -1) {
            return sortExploits();
          }
        },
        activate: function(e, ui) {
          var $panel;
          $panel = $(ui.newPanel);
          if ($panel.is(":empty")) {
            return $panel.html("<div class='tab-loading'></div>");
          }
        }
      });
      return window.moduleLinksInit($("meta[name='msp:module_run_path']").attr('content'));
    });
  });

}).call(this);
