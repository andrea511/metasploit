(function() {

  jQuery(function($) {
    return window.renderPortableFileEdit = function() {
      var $config, $fileInputs, $form, fileFormatSearch, moduleInitialConfig, modulePath, moduleTitle, workspace;
      $form = $('.ui-tabs-wrap:visible form');
      workspace = WORKSPACE_ID;
      fileFormatSearch = null;
      modulePath = $('meta[name=module-path]', $form).attr('content');
      moduleTitle = $('meta[name=module-title]', $form).attr('content');
      moduleInitialConfig = $.parseJSON($('meta[name=module-data]', $form).attr('content'));
      $config = $('.exploit-module-config', $form);
      $fileInputs = $('.file li#social_engineering_portable_file_file_generation_type_input input', $form);
      $fileInputs.change(function(e) {
        var className;
        if (!$(this).filter(':checked')) {
          return;
        }
        className = $fileInputs.filter(':checked').last().val();
        $(".file>div", $form).hide();
        if (className) {
          $(".file ." + className, $form).css('display', 'block');
        }
        if (className === 'file_format') {
          if (!$(".file ." + className, $form).is(':visible')) {
            return;
          }
          fileFormatSearch || (fileFormatSearch = new ModuleSearch($('.file .file_format .load-modules', $form), {
            workspace: workspace,
            hiddenInputContainer: $config,
            fileFormat: true,
            extraQuery: '',
            modulePath: modulePath,
            moduleTitle: moduleTitle,
            moduleConfig: moduleInitialConfig,
            paramWrapName: 'social_engineering_portable_file'
          }));
          fileFormatSearch.activate();
          return modulePath = moduleTitle = moduleInitialConfig = null;
        }
      });
      return $fileInputs.change();
    };
  });

}).call(this);
