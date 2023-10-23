jQuery ($) ->
  window.renderWebPageEdit = ->
    $form = $('.ui-tabs-wrap:visible form').first()

    sel = $('.white-box li.radio input:checked', $form).val()
    $('.white-box .config>div.'+sel, $form).show()

    # use jquery to move radio buttons in front of fields under Attack Type: Phishing
    # r1 is the radio button for "enter custom URL" field
    $r1 = $('input[name=\'social_engineering_web_page[phishing_redirect_origin]\']', $form).eq(0)
    $li = $r1.parents('li') # shared parent of $r1 & $r2
    # r2 is the radio button for "select a webpage" dropdown
    $r2 = $('input[name=\'social_engineering_web_page[phishing_redirect_origin]\']', $form).eq(1)
    $r1.css(width: 'auto', 'margin-right': '10px')
    $r2.css(width: 'auto', 'margin-right': '10px')
    # f1 is the "enter custom URL" field
    $f1 = $('input[name=\'social_engineering_web_page[phishing_redirect_specified_url]\']', $form)
    $f1.css('width', '90%').before($r1)
    # f2 is the "select a web page" dropdown
    $f2 = $('select[name=\'social_engineering_web_page[phishing_redirect_web_page_id]\']', $form)
    $f2.css('width', '200px').before($r2)
    $label = $('<span>').text('Choose another attack page to redirect to')
    $label.css('position': 'relative', 'top': '4px', 'padding-right': '10px')
    $f2.before($label)
    $li.remove()

    # add some UI logic to autoselect the radio buttons when focusing on
    # their corresponding inputs. This could be done statically with labels,
    # but then the inputs would also be auto-blurred, which is annoying!
    $f1.focus -> $r1.prop('checked', true) && $r2.prop('checked',false)
    $f2.focus -> $r2.prop('checked', true) && $r1.prop('checked',false)
    $r1.click -> $f1.focus()
    $r2.click -> $f2.focus()
    $label.click -> $f2.focus()
    # clear redirect URL when redirect page is changed
    $('select[name=\'social_engineering_web_page[phishing_redirect_web_page_id]\']', $form).change ->
      $('input[name=\'social_engineering_web_page[phishing_redirect]\']', $form).val('')

    $inputs = $('select[name="social_engineering_web_page[attack_type]"]', $form)
    workspace = WORKSPACE_ID
    exploitSearch = null
    bapSearch = null
    javaSearch = null
    fileFormatSearch = null
    modulePath =  $('meta[name=module-path]', $form).attr('content')
    moduleTitle = $('meta[name=module-title]', $form).attr('content')
    # See https://github.com/jquery/jquery-migrate/blob/master/warnings.md
    moduleInitialConfig = $.parseJSON $('meta[name=module-data]', $form).attr('content') || 'null'
    $config = $('.exploit-module-config', $form)

    $form.on 'click','.white-box input[type=radio]', ->
      $('.white-box .config>div', $form).hide()
      $('.white-box .config>div.'+$(this).val(), $form).show()

    # add dynamic goodness for when user changes Attack Type
    $inputs.change (e) ->
      newVal = $('option', $inputs).filter(':selected').val()
      newVal = 'none' if newVal == ''
      $('.attack-box-options', $form).show()
      $('.attack-box-options>div', $form).hide()
      $('.shadow-arrow,.shadow-arrow-row', $form).show()
      $('.attack-box-options .'+newVal, $form).show()
      # show content area
      $('div.content-box', $form).not('.attack-box').css(opacity: 1, 'pointer-events': 'auto')
      $('.content-disabled-box', $form).hide()
      removeIfNotSaved = (success) ->
        return if @oldHTML || success
        $('option', $inputs).removeAttr('selected')
        $('option', $inputs).first().attr('selected', 'true')
        $inputs.first().change()

      unless newVal == 'none' || newVal == 'phishing'
        # disable the content editor
        $('div.content-box', $form).not('.attack-box').css(opacity: .6, 'pointer-events': 'none')
        $('.content-disabled-box', $form).fadeIn()
        msg = 'Content is disabled when serving '
        if newVal == 'file'
          $('.content-disabled-box', $form).text(msg + 'files.')
        else
          $('.content-disabled-box', $form).text(msg + 'exploits.')

      if newVal == 'exploit'
        $a = $(".attack-box-options .selected>a", $form).filter(':visible')
        # if there's already a name there, shove it in
        modulePath ||= $a.data('modulePath')
        moduleTitle ||= $a.data('moduleTitle')
        exploitSearch ||= new ModuleSearch $('.exploit', $form), 
          workspace: workspace,
          hiddenInputContainer: $config,
          modulePath: modulePath,
          moduleTitle: moduleTitle,
          moduleConfig: moduleInitialConfig
        exploitSearch.activate() # load module config into 'exploit-module-config' now
        modulePath = moduleTitle = moduleInitialConfig = null
        
      else if newVal == 'bap'
        modulePath = 'auxiliary/server/browser_autopwn'
        moduleTitle = 'HTTP Client Automatic Exploiter'
        bapSearch ||= new ModuleSearch $('.bap', $form), 
          workspace: workspace,
          hiddenInputContainer: $config,
          hideSearch: true,
          configSavedCallback: removeIfNotSaved,
          modulePath: modulePath,
          moduleTitle: moduleTitle,
          moduleConfig: moduleInitialConfig
        bapSearch.activate()
        bapSearch.loadModuleModalConfig() unless bapSearch.currentlyLoaded()
        modulePath = moduleTitle = moduleInitialConfig = null

      else if newVal == 'java_signed_applet'
        modulePath = 'exploit/multi/browser/java_signed_applet'
        moduleTitle = 'Java Signed Applet Social Engineering Code Execution'
        javaSearch ||= new ModuleSearch $('.java_signed_applet', $form), 
          workspace: workspace,
          hiddenInputContainer: $config,
          hideSearch: true,
          configSavedCallback: removeIfNotSaved,
          modulePath: modulePath,
          moduleTitle: moduleTitle,
          moduleConfig: moduleInitialConfig
        javaSearch.activate()
        javaSearch.loadModuleModalConfig() unless javaSearch.currentlyLoaded()
        modulePath = moduleTitle = moduleInitialConfig = null

      else if newVal == 'file' # disable content area
        $('div.content-box', $form).not('.attack-box').css(opacity: .6, 'pointer-events': 'none')
        $('.content-disabled-box', $form).fadeIn()
        $fileInputs.change() if $fileInputs

      else if newVal == 'none'
        $('.attack-box-options', $form).hide()
        $('.shadow-arrow,.shadow-arrow-row', $form).hide()

    $inputs.first().change() # load current attack type
    # add dynamic goodness for when user changes File type, after File Format 
    #    has been chosen as the Attack Type
    $fileInputs = $('.file li.choice input', $form)
    $fileInputs.change (e) ->
      return unless $(this).filter(':checked')
      className = $('input', $(this).parents('fieldset')).filter(':checked').last().val()
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
          moduleConfig: moduleInitialConfig
        fileFormatSearch.activate()
        modulePath = moduleTitle = moduleInitialConfig = null
    $fileInputs.change()
