jQuery ($) ->
  window.renderPortableFileEdit = ->
    $form = $('.ui-tabs-wrap:visible form')
    workspace = WORKSPACE_ID
    fileFormatSearch = null
    modulePath =  $('meta[name=module-path]', $form).attr('content')
    moduleTitle = $('meta[name=module-title]', $form).attr('content')
    moduleInitialConfig = $.parseJSON $('meta[name=module-data]', $form).attr('content')
    $config = $('.exploit-module-config', $form)

    $fileInputs = $('.file li#social_engineering_portable_file_file_generation_type_input input', $form)
    $fileInputs.change (e) ->
      return unless $(@).filter(':checked')
      className = $fileInputs.filter(':checked').last().val()
      $(".file>div", $form).hide()
      $(".file ."+className, $form).css('display', 'block') if className
      
      if className == 'file_format'  # load file format module search
        return unless $(".file .#{className}", $form).is(':visible')
        fileFormatSearch ||= new ModuleSearch $('.file .file_format .load-modules', $form), 
          workspace: workspace,
          hiddenInputContainer: $config,
          fileFormat: true,
          extraQuery: '',
          modulePath: modulePath,
          moduleTitle: moduleTitle,
          moduleConfig: moduleInitialConfig,
          paramWrapName: 'social_engineering_portable_file'
        fileFormatSearch.activate()
        modulePath = moduleTitle = moduleInitialConfig = null
    $fileInputs.change()
