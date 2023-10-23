(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var $container, containerSelector, dependencySelector, flashSelector, reportTypeSelector;
      containerSelector = '#report_container, .generate_report';
      reportTypeSelector = '#report_report_type';
      dependencySelector = '.dependency';
      flashSelector = '#flash_messages';
      $container = $(containerSelector);
      $('body').on("change", "select#report_report_type", function(e) {
        var loading, reportTypesSelectHTML, rtype;
        loading = ".tab-loading";
        rtype = $(e.currentTarget).find("option:selected").val();
        $container = $(containerSelector);
        $container.find(loading).show();
        $container.addClass("disabled");
        reportTypesSelectHTML = $container.find(reportTypeSelector).html();
        return $.ajax({
          url: $('#form-for-report-path').attr('href'),
          data: {
            report: {
              report_type: rtype
            }
          },
          success: function(data) {
            var $dependency, $enabled, $flash, $reportType, oldReportTypeVal;
            $container.find(loading).hide();
            $enabled = $container.children('li').first();
            $container.html(data);
            $dependency = $container.find(dependencySelector);
            $flash = $(document).find(flashSelector);
            if ($dependency.length) {
              $flash.empty();
              $flash.append($dependency.children());
              $dependency.remove();
            } else {
              $flash.empty();
            }
            $container.find('.generate_report').children('li').first().replaceWith($enabled);
            $reportType = $container.find(reportTypeSelector);
            oldReportTypeVal = $reportType.val();
            $(reportTypeSelector).html(reportTypesSelectHTML);
            $reportType.val(oldReportTypeVal);
            $container.removeClass("disabled");
            window.Forms.renderHelpLinks(containerSelector);
            return $(document).trigger('report.loaded');
          },
          error: function(data) {
            return console.log(data);
          }
        });
      });
      return $container.on("submit", "#new_report", function(e) {
        var loading;
        e.preventDefault();
        loading = ".tab-loading";
        $container = $(containerSelector);
        $container.find(loading).show();
        $container.addClass("disabled");
        return $.ajax({
          url: $(e.target).attr("action"),
          data: $(e.target).serialize(),
          type: "POST",
          error: function(xhr) {
            $container.find(loading).hide();
            return $container.removeClass("disabled").html(xhr.responseText);
          },
          success: function(data) {
            return window.location = $('#report-redirect-path').attr('href');
          }
        });
      });
    });
  });

}).call(this);
