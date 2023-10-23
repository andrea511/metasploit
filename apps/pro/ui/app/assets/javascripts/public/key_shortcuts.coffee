# install keyboard shortcuts
jQuery(document).ready ($) ->
  INPUT_SEL = 'textarea:focus:visible,input[type=text]:focus:visible,' +
              'input[type=email]:focus:visible,input[type=number]:focus:visible,'+
              'input[type=tel]:focus:visible,input[type=url]:focus:visible,' +
              'input[type=week]:focus:visible,input[type=color]:focus:visible,' +
              'input[type=date]:focus:visible, input[type=password]:focus:visible'
  WORKSPACE_REGEX = /workspaces\/(\d+)/
  CONSOLE_HEIGHT_COOKIE = 'console-height'

  $oldHelp = null
  yankTimeout = null
  if location.href.match(WORKSPACE_REGEX)
    workspaceId = location.href.match(WORKSPACE_REGEX)[1]
  else
    workspaceId = null
  cookieKey = 'session-consoleId'+workspaceId
  consoleId = $.cookie(cookieKey)

  $hider = null
  $console = null
  mousedown = false
  desiredHeight = parseInt($.cookie()[CONSOLE_HEIGHT_COOKIE]) || null
  minHeight = 200
  maxHeight = $(window).height()-30
  $(window).on('resize', -> maxHeight = $(window).height()-30)

  consoleMouseUp = ->
    $('body').unbind('mousemove.console-dragger')
    mousedown = false
    return unless $console?.length && $console?.is(':visible')
    $hider.hide() if $hider?
    consoleHeight = $console.height()
    if desiredHeight != consoleHeight
      # save desired height
      desiredHeight = consoleHeight
      $.removeCookie(CONSOLE_HEIGHT_COOKIE)
      $.cookie(CONSOLE_HEIGHT_COOKIE, consoleHeight)

  toggleConsole = ->
    return if not workspaceId
    $console = $('#console-tray')
    window.clearTimeout(yankTimeout) if yankTimeout?

    if not $console.length
      $console = $('<div />', id: 'console-tray', class: 'hidden-console').appendTo($('body'))
      if desiredHeight? and desiredHeight > minHeight and desiredHeight < maxHeight
        $console.height(desiredHeight)
      $iframe = $('<iframe />', src: 'about:blank', name: 'console').appendTo($console)
      $dragger = $('<div />', class: 'dragger').appendTo($console)
      $hider = $('<div />', class: 'iframe-hider').appendTo($console)

      initPos = null
      initHeight = null

      onMouseMove = (e) ->
        return unless mousedown
        datHeight = initHeight + e.screenY-initPos
        datHeight = minHeight if datHeight < minHeight
        datHeight = maxHeight if datHeight > maxHeight
        $console.height(datHeight)

      $dragger.on 'mousedown', (e) ->
        mousedown = true
        initHeight = $console.height()
        initPos = e.screenY
        $hider.show()
        $('body').bind('mousemove.console-dragger', onMouseMove)

      $('body').bind 'mouseup.console-events, mouseleave.console-events', consoleMouseUp

      if consoleId
        $iframe.attr('src', "/workspaces/#{workspaceId}/consoles/#{consoleId}")
      else # spawn a new console
        $iframe.attr('src', "/workspaces/#{workspaceId}/console")
      window.setTimeout -> $console.removeClass('hidden-console')
    else if $console.hasClass('hidden-console') # show it (slide it down)
      $console.show()
      $('body').bind 'mouseup.console-events, mouseleave.console-events', consoleMouseUp
      $iframe = $console.find('iframe')
      $iframe[0].contentWindow.focus()
      $console.appendTo($('body')) unless $console[0].parentNode?
      window.setTimeout -> $console.removeClass('hidden-console')
    else if not $console.hasClass('hidden-console')
      $iframe = $console.find('iframe')
      $iframe[0].contentWindow.blur()
      $console.addClass 'hidden-console'
      $('body').unbind 'mouseup.console-events, mouseleave.console-events'
      yankTimeout = window.setTimeout (-> $console.remove()), 10000
      window.focus()

  window['toggleConsole'] = toggleConsole # enable access from child frame
  # child frame sends us a message to tell us the console ID
  $(document).bind 'consoleLoad', (e, data) ->
    consoleId = data.id
    # expire this cookie in 5 minutes (consoles are short lived, yo)
    $.removeCookie(cookieKey)
    $.cookie(cookieKey, consoleId, { expires: new Date(+(new Date)+1000*60*5) })

  $(document.body).bind 'keydown', (e) ->
    if e.keyCode == 114 # F3 opens inline help
      $help = $(e.target).parents('li').find('a.help')
      if $help.length < 1 && $oldHelp? && $oldHelp.length > 0
        fieldKey = $oldHelp.data('field')
        if $(".inline-help[data-field='#{fieldKey}']").is(':visible')
          $oldHelp.click()
          $oldHelp = null
          return
      $help.click() if $help && $help.length
      $oldHelp = $help
      e.preventDefault()
      e.stopPropagation()
    else if e.keyCode == 112 # F1 opens community help link
      window.open($('#top-menu a.help-item').first().attr('href'), '_blank')
    else if e.keyCode == 192 & (e.altKey || e.ctrlKey) # slide out console
      toggleConsole.call(@)
      #  /workspaces/1/
