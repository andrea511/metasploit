(function() {

  jQuery(function($) {
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
      return window.moduleLinksInit($("meta[name='msp:module_run_path']").attr('content'));
    });
  });

}).call(this);
