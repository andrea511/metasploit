jQuery ($) ->
  window.renderEmailEdit = ->
    $form = $('.ui-tabs-wrap:visible form')
    $inputs = $('select[name="social_engineering_email[attack_type]"]', $form)
    workspace = WORKSPACE_ID
    fileFormatSearch = null
    modulePath =  $('meta[name=module-path]', $form).attr('content')
    moduleTitle = $('meta[name=module-title]', $form).attr('content')
    moduleInitialConfig = $.parseJSON $('meta[name=module-data]', $form).attr('content') || "null"
    $config = $('.exploit-module-config', $form)

    $inputs.change (e) ->
      newVal = $('option', $inputs).filter(':selected').val()
      $('.attack-box-options>div', $form).hide()
      if newVal == 'none'
        $('.shadow-arrow', $form).hide()
        $('.attack-box-options', $form).hide()
      else
        $('.attack-box-options', $form).show()
        $('.shadow-arrow', $form).show().css(left: '49%', top: '-1px')
        $('.attack-box-options .'+newVal, $form).show()
    $inputs.first().change()

    $fileInputs = $('.file li.choice input', $form)
    $fileInputs.change (e) ->
      return unless $(this).filter(':checked')
      className = $('input', $(this).parents('fieldset')).filter(':checked').val()
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
          paramWrapName: 'social_engineering_email'
        fileFormatSearch.activate()
        modulePath = moduleTitle = moduleInitialConfig = null

    $fileInputs.change()

    $('.origin-box input[type=radio]', $form).click (e) ->
      $('.origin-box .config>div', $form).hide()
      $('.origin-box .config>div.'+$(this).val(), $form).show()

    sel = $('.white-box.origin-box li.radio input:checked', $form).val()
    $('.white-box.origin-box .config>div.'+sel, $form).show()

    $textareaCodeMirror = $('.to-code-mirror', $form)
    $textareaWysiwyg = $textareaCodeMirror.clone().attr('id', 'social_engineering_email_content_wysiwyg')
                                  .attr('name', 'ignore')
    $textareaWysiwyg.addClass('to-wysiwyg').removeClass('to-code-mirror')
    $textareaCodeMirror.after($textareaWysiwyg)


    wysiwyg = $textareaWysiwyg.wysiwyg
      controls:
        insertImage: { visible: false },
        code: { visible: false },
        table: { visible: false },
        insertTable: {visible: false},
        createLink: {visible: false},
        unLink: {visible: false}
      iFrameClass: "wysiwyg-input"

    cellHeight = $('.wysiwyg', $form).parents('.content').first().height()
    $('.wysiwyg iframe', $form).height(cellHeight-200)

    $('.wysiwyg', $form).hide()
    $('.editor-box input[type=radio]', $form).change (e) ->
      return unless $(e.target).filter(':checked').size()
      val = $(e.target).val()
      if val == 'rich_text' # rte is selected
        $('.CodeMirror', $form).hide()
        $('.preview', $form).hide()
        $('.wysiwyg', $form).show()
        $('.custom-attribute', $form).show()
        $textareaWysiwyg.attr('name', 'social_engineering_email[content]')
        $textareaCodeMirror.attr('name', 'ignore')
        $(wysiwyg).wysiwyg('setContent', $form.triggerHandler('getMirrorContent'))
        $(wysiwyg).data('wysiwyg').editorDoc.body.focus()
      else if val == 'preview'
        content = $form.triggerHandler('getEditorContent')
        $('.CodeMirror', $form).hide()
        $('.wysiwyg', $form).hide()
        $('.custom-attribute', $form).hide()
        $(wysiwyg).wysiwyg('setContent', content)
        $form.triggerHandler('setMirrorContent', content: content)
        $preview = $('.preview', $form)
        $iframe = $preview.find('iframe')
        $iframe.contents().find('html').html('')
        $iframe.css(width: '100%', border: '0')
        tmpl = $('li#social_engineering_email_template_input select option:selected', $form).val()
        url = $('meta[name=preview-url]', $form).attr('content')
        $preview.addClass('ui-loading').height(cellHeight-200).show()
                .css(overflow: 'scroll', border: '1px solid #ddd')
        $.ajax(
          url: url,
          type: 'post',
          data:
            content: content
            template_id: tmpl
          success: (data) ->
            $preview.show().removeClass('ui-loading')
            $iframe.contents().find('html').html(data)
            h = $('html', $iframe.contents()).height()
            $iframe.height(h)
            $('.blocker', $form).height(h)
        )
      else
        $('.CodeMirror', $form).show()
        $('.wysiwyg', $form).hide()
        $('.preview', $form).hide()
        $('.custom-attribute', $form).show()
        $textareaWysiwyg.attr('name', 'ignore')
        $textareaCodeMirror.attr('name', 'social_engineering_email[content]')
        content = $(wysiwyg).wysiwyg('getContent')
        $form.triggerHandler('setMirrorContent', {content:content, autoformat:true})

    $('li#social_engineering_email_template_input select').change ->
      if $('.preview', $form).is(':visible')
        $('.editor-box input[type=radio]', $form).change() # trigger redraw

    $form.bind 'replaceWysiwygSelection', (e, str) ->
      $(wysiwyg).data('wysiwyg').insertHtml(str)

    $form.bind 'getWysiwygSelection', (e, str) ->
      sel = $(wysiwyg).data('wysiwyg').getRangeText()
      if $('.wysiwyg').is(':visible')
        return sel || '' #, str) if $('.wysiwyg').is(':visible')
      return null

    $form.bind 'getWysiwygHTMLSelection', (e, str) ->
      range = $(wysiwyg).data('wysiwyg').getInternalRange()
      docFrag = range.cloneContents()
      div = document.createElement('div')
      div.appendChild(docFrag)
      html = $(div).html() # the actual html
      if $('.wysiwyg').is(':visible')
        return html || '' #, str) if $('.wysiwyg').is(':visible')
      return null

    $form.bind 'getWysiwygRange', (e, str) ->
      if $('.wysiwyg:visible', $form).length > 0
        range = $(wysiwyg).data('wysiwyg').getInternalRange()
      else
        null

    $form.bind 'syncWysiwyg', ->
      $(wysiwyg).data('wysiwyg').saveContent()

    $form.bind 'getEditorSelection', ->
      if $('.wysiwyg:visible', $form).length > 0
        $form.triggerHandler('getWysiwygHTMLSelection')
      else
        $form.triggerHandler('getMirrorSelection')
    
    $form.bind 'getEditorContent', ->
      if $('.wysiwyg', $form).is(':visible')
        $(wysiwyg).wysiwyg('getContent')
      else
        $form.triggerHandler('getMirrorContent')


    $form.bind 'setEditorContent', (e, content) ->
      if $('.wysiwyg:visible', $form).length > 0
        $(wysiwyg).setContent(content)
      else
        $form.triggerHandler('setMirrorContent', content: content)


    $form.bind 'setWysiwygContent', (e, content) ->
      $(wysiwyg).data('wysiwyg').setContent(content)

    $form.bind 'setWysiwygSelectionRange', (e, selRange) ->
      $(wysiwyg).data('wysiwyg').setInternalSelection(selRange.start, selRange.end)

    $form.bind 'getWysiwygSelectionRange', (e, selRange) ->
      $(wysiwyg).data('wysiwyg').getInternalRange(selRange.start, selRange.end)


    $form.bind 'getEditorCursorPosition', (e, content) ->
      if $('.wysiwyg:visible', $form).length > 0
        $(wysiwyg).data('wysiwyg').getInternalRange().startOffset
      else
        $form.triggerHandler('getMirrorCursorPosition')

    $form.bind 'getWysiwygCursorContainer', (e, content) ->
      #if $('.wysiwyg:visible', $form).length > 0
      $(wysiwyg).data('wysiwyg').getInternalRange()


    $form.bind 'getEditorSelectionRange', (e, content) ->
      if $('.wysiwyg:visible', $form).length > 0
        $form.triggerHandler('getWysiwygSelectionRange')
      else
        $form.triggerHandler('getMirrorSelectionRange')

    # if we call this immediately, chrome runs into some scrollng bugs
    # instead, we call this when to modal scrolls to page1 (see EmailFormView#page)
    #$('.editor-box input[type=radio]', $form).change()
