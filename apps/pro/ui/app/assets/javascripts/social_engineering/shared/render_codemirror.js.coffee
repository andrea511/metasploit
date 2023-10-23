jQuery ($) ->
  window.renderCodeMirror = (topOffset=180) ->
    # get visible form
    $form = $('.ui-tabs-wrap:visible form,form.social_engineering_email_template,form.social_engineering_web_template')
    textarea = $('textarea.to-code-mirror', $form)[0]
    # render code mirror
    cellHeight = $(textarea).parents('.content').first().height()
    cmHeight = cellHeight-topOffset || 600

    mirror = CodeMirror.fromTextArea textarea,
      lineNumbers: true
      matchBrackets: true
      mode: "htmlmixed"
      tabSize: 2
      indentUnit: 2
      indentWithTabs: true
      enterMode: "keep"
      tabMode: "shift"
      lineWrapping: true
      height: cmHeight + 'px'
    $('.CodeMirror-scroll').css(height: "#{cmHeight}px")

    # the autoFormatRange call makes the page "jump" down, so remove for now
    # mirror.autoFormatRange({ch:0, line:0}, {ch:0, line:mirror.lineCount()})

    # update textarea value on submit (custom event for textarea)
    $(textarea).bind 'loadFromEditor', -> mirror.save()
    selectedText = ''

    # if we need a vhost prefix, insert it before the path field
    $vhostField = $('input[name="social_engineering_web_page[path]"]', $form)
    $file_type = $('input[name="social_engineering_web_page[file_generation_type]"]', $form)
    $file_type.click (e)->
      if $(e.currentTarget).val() == "exe_agent" && $vhostField.val().indexOf('.exe') == -1
        $vhostField.val($vhostField.val()+'.exe')
      else if ($(e.currentTarget).val() != "exe_agent" && $vhostField.val().indexOf('.exe') != -1)
        $vhostField.val($('input[name="social_engineering_web_page[path]"]').val().slice(0,$vhostField.val().indexOf('.exe')))

    # remove initial slash (this is added in a before_save filter on web_page)
    if $vhostField.size()
      $vhostField.val($vhostField.val().replace(/^\//, ''))
      vhostName = $vhostField.attr('data-content')
      $prefix = $('<div class="vhost-prefix"></div>').text('http://'+vhostName+'/')
      $vhostField.before($prefix)

    # bind to a custom event so that we can update the mirror from other places
    $form.bind 'updateMirror', (e, str) ->
      mirror.setValue(str)
      mirror.autoFormatRange({ch:0, line:0}, {ch:0, line:mirror.lineCount()})

    # replaces selected text with str
    $form.bind 'replaceMirrorSelection', (e, str) ->
      mirror.replaceSelection(str) if $('.CodeMirror', $form).is(':visible')

    # returns the current selection.
    $form.bind 'getMirrorSelection', (e) ->
      if $('.CodeMirror', $form).is(':visible') then mirror.getSelection() else null

    # returns the current selection. to use, pass a callback 
    $form.bind 'getMirrorContent', (e) ->
      mirror.getValue()

    # returns the current selection. to use, pass a callback 
    $form.bind 'setMirrorContent', (e, opts) ->
      mirror.setValue(opts['content'])
      mirror.autoFormatRange({ch:0, line:0}, {ch:0, line:mirror.lineCount()}) if opts['autoformat']

    $form.bind 'getMirrorSelectionRange', (e, opts) ->
      if $('.CodeMirror', $form).is(':visible')
        first = { line: 0, ch: 0 }
        selStart = mirror.getCursor(true)
        selEnd =  mirror.getCursor(false)
        { 
          start: mirror.getRange(first, selStart).length, 
          end: mirror.getRange(first, selEnd).length
        }
      else
        null

    $form.bind 'getMirrorCursorPosition', (e) ->
      start = { line: 0, ch: 0 }
      end =  mirror.getCursor(false)
      mirror.getRange(start, end).length
