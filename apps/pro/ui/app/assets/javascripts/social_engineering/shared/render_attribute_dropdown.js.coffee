jQuery ($) ->
  # yanked from the jquery-validate plugin
  VALIDATE_URL = /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i
  
  window.renderAttributeDropdown = ->
    # get visible form
    $form = $('.ui-tabs-wrap:visible form,form.social_engineering_email_template,form.social_engineering_web_template')
    $dialog = null
    $modDialog = null
    optInitValue = null
    optInitText = null
    $cachedATags = null

    # http://stackoverflow.com/questions/1482832/how-to-get-all-elements-that-are-highlighted
    rangeIntersectsNode = (range, node) ->
      if range.intersectsNode
        return range.intersectsNode(node)
      else
        nodeRange = node.ownerDocument.createRange()
        try
          nodeRange.selectNode(node)
        catch e
          nodeRange.selectNodeContents(node)
        return range.compareBoundaryPoints(Range.END_TO_START, nodeRange) == -1 &&
            range.compareBoundaryPoints(Range.START_TO_END, nodeRange) == 1

    getSelectedElements = (range) ->
      if range
        containerElement = range.commonAncestorContainer
        if (containerElement.nodeType != 1)
          containerElement = containerElement.parentNode
        d = containerElement.ownerDocument
        treeWalker = d.createTreeWalker(
          containerElement,
          NodeFilter.SHOW_ELEMENT,
          ((node) ->
            return if rangeIntersectsNode(range, node)
              NodeFilter.FILTER_ACCEPT
            else 
              NodeFilter.FILTER_REJECT
          ),
          false
        )
        elmlist = [treeWalker.currentNode]
        elmlist.push(treeWalker.currentNode) while treeWalker.nextNode()
        return elmlist
      else
        return null
        


    findWysiwygATags = ->
      if $('.wysiwyg', $form).is(':visible')
        # first check the wysiwygRange attribute
        wysiwygRange = $form.triggerHandler('getWysiwygRange')
        $aTags = []
        if wysiwygRange
          $aTags = $(getSelectedElements(wysiwygRange)).filter('a')
        $aTags
      else
        null

    findCodeMirrorATags = ->
      if $('.CodeMirror', $form).is(':visible')
        html = $form.triggerHandler('getMirrorContent')
        range = $form.triggerHandler('getMirrorSelectionRange')
        lm = new LinkManipulator(html)
        lm.matchTagsInSelection('a', range.start, range.end)
      else
        null

    # show popup modal for custom insertions
    showOptionDialog = (opts) ->
      if $('.CodeMirror-scroll', $form).is(':visible')
        mirrorSelection = $form.triggerHandler('getMirrorSelection')
      else
        mirrorSelection = $form.triggerHandler('getWysiwygSelection')
      mirrorSelection ||= ''
      $dialog ||= $('div.dialog.link-popup', $form).dialog
        title: 'Insert Campaign Link'
        width: 400
        height: 230
        modal: true
        autoOpen: false
        closeOnEscape: false
        buttons:
          "Cancel": ->
            $(this).dialog("close")
          "Insert": ->
            txt = $('input[name=campaign-link-name]', $dialog).val()
            opt = $('select[name=webpage] option:selected', $dialog).val().replace('/', '')
            cmd = '<a href="{% campaign_href \''+opt+'\' %}">' + txt + '</a>'
            #cmd = '{% campaign_web_link \''+txt+'\', '+opt+' %}'
            $form.triggerHandler('replaceMirrorSelection', cmd)
            $form.triggerHandler('replaceWysiwygSelection', cmd)
            $(this).dialog("close")
        close: (ev, ui) ->
          $dialog.find(':input').val('')
      $dialog.dialog('open')
      $('input[name=campaign-link-name]', $dialog).val mirrorSelection

    showStaticPageDialog = (pageName) ->
      if $('.CodeMirror-scroll', $form).is(':visible')
        mirrorSelection = $form.triggerHandler('getMirrorSelection')
      else
        mirrorSelection = $form.triggerHandler('getWysiwygSelection')

      mirrorSelection ||= ''
      $dialog ||= $('div.dialog.landing-popup', $form).dialog
        title: 'Insert Link to Landing Page'
        width: 390
        height: 250
        modal: true
        autoOpen: false
        closeOnEscape: false
        buttons:
          "Cancel": ->
            $(this).dialog("close")
          "Insert": ->
            txt = $('input[name=campaign-link-name]', $dialog).val()
            title = $('input[name=hover-text]', $dialog).val() || ''
            spoofChecked = $('input[name=spoof-hover]', $dialog).is(':checked')
            if spoofChecked
              cmd = '<a href="{% campaign_href \''+pageName+'\' %}" title="' + title + '">' + txt + '</a>'
            else
              cmd = '<a href="{% campaign_href \''+pageName+'\' %}">' + txt + '</a>'
            $form.triggerHandler('replaceMirrorSelection', cmd)
            $form.triggerHandler('replaceWysiwygSelection', cmd)
            $(this).dialog("close")
        close: (ev, ui) ->
          $dialog.find(':input').val('')
          $dialog.find('[type=checkbox]').removeAttr('checked')
      $dialog.dialog('open')
      $('input[name=campaign-link-name]', $dialog).val mirrorSelection

    showModifyLinkDialog = (linkType) ->
      $aTags = findWysiwygATags() || findCodeMirrorATags()
      $aTags = $cachedATags if $aTags.length == 0
      
      title = 'Redirect Link to Campaign Web Page'
      title = "Redirect #{$aTags.length} Links to Campaign Web Page" if $aTags.length > 1
      $modDialog ||= $('div.dialog.modify-link-popup', $form).dialog
        title: title
        width: 390
        height: 250
        modal: true
        autoOpen: false
        closeOnEscape: false
        buttons:
          "Cancel": ->
            $(this).dialog("close")
          "Update": ->
            $aTags = findWysiwygATags() || findCodeMirrorATags()
            # ie deselects when the dropdown is opened, so $aTags may return empty
            # we will cache matches for now
            $aTags = $cachedATags if $aTags.length == 0 
            $cachedATags = null
            $opt = $('select option:selected', $modDialog)
            spoofLinkTitle = $('.spoof input[type=text]', $modDialog).val()
            shouldSpoofLinkTitle = $('.spoof input[type=checkbox]', $modDialog).is(':checked')
            shouldSpoofLinkTitle &= spoofLinkTitle && spoofLinkTitle.length > 0
            if optInitValue == 'campaign_link'
              href = "{% campaign_href '#{$opt.val()}' %}"
            else
              href = "{% campaign_href '#{$opt.text()}' %}"
            if $('.CodeMirror-scroll', $form).is(':visible')
              html = $form.triggerHandler('getMirrorContent')
              range = $form.triggerHandler('getMirrorSelectionRange')
              lm = new LinkManipulator(html)
              newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', href, range.start, range.end)
              if shouldSpoofLinkTitle
                lm2 = new LinkManipulator(newHTML)
                newHTML = lm2.replacePropertyOfTagsInSelection('title', 'a', spoofLinkTitle, range.start, range.end)
              $form.triggerHandler('setMirrorContent', content: newHTML)
            else
              $($aTags).attr('href', href)
              if shouldSpoofLinkTitle
                $($aTags).attr('title', spoofLinkTitle)

            $(this).dialog("close")
        close: (ev, ui) ->
          $modDialog.find(':input').val('')
      $modDialog.dialog('open')
      $modDialog.dialog(title: title)
      validHref = _.find($aTags, (a) -> 
        href = a.getAttribute("href")
        href && href.length>0 && !href.match(/^\{\%/) && href.match VALIDATE_URL
      )
      validHref = if validHref then validHref.getAttribute('href') else validHref
      validTitleURL = _.find $aTags, (a) -> a.title && a.title.length>0 && a.title.match VALIDATE_URL
      validTitleURL = if validTitleURL then validTitleURL.title else validTitleURL
      $('[name=spoof-hover]', $modDialog).attr('checked', 'checked')
      if validTitleURL
        # if one ofthe titles is a link
        $('input[name=hover-text]', $modDialog).val(validTitleURL)
      else if validHref
        # if there is a valid href
        $('input[name=hover-text]', $modDialog).val(validHref)
      else
        $('[name=spoof-hover]', $modDialog).removeAttr('checked')
      true


    $opt = $("select.dropdown-menu option", $form).filter(-> 
      $.inArray($(this).val(), ["campaign_link", "campaign_landing_link", "modify_link"]) > -1
    )
    optInitValue = $opt.val() # can be campaign_link or campaign_landing_link
    optInitText = $opt.text()

    # conditionally display dropdow actions
    $("select.dropdown-menu", $form).bind 'open', (e) ->
      # conditionally display "Add link to Web Page" or
      # "Change link to point to Web Page"
      $aTags = findWysiwygATags() || findCodeMirrorATags()
      $cachedATags = $aTags

      $opt = $("select.dropdown-menu option", $form).filter(-> 
        $.inArray($(this).val(), ["campaign_link", "campaign_landing_link", "modify_link"]) > -1
      )

      if $aTags.length > 1 # we have a reference <a> tag, ONLY showl that option
        # if more than one link in container
        $opt.text("Redirect #{$aTags.length} links to a Campaign Web Page")
        $opt.val('modify_link')
      else if $aTags.length == 1
        $opt.text('Redirect link to a Campaign Web Page')
        $opt.val('modify_link')
      else
        $opt.val(optInitValue)
        $opt.text(optInitText)

    $("select.dropdown-menu", $form).change (e) ->
      # if user selected an <option> besides the first one
      selVal = $('option:selected', this).val()
      # $('option', this).eq(0).attr('selected', 'selected')
      $(e.target).select2('val', '')
      if selVal == 'campaign_link'
        showOptionDialog()
      else if selVal == 'campaign_landing_link'
        showStaticPageDialog('Landing Page')
      else if selVal == 'modify_link'
        showModifyLinkDialog()
      else if selVal != ''
        $form.triggerHandler('replaceMirrorSelection', selVal)
        $form.triggerHandler('replaceWysiwygSelection', selVal)
