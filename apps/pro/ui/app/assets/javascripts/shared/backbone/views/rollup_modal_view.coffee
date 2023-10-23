# RollupModalView will present its @content in a rollup modal
# Usage: new RollupModalView(content: 'blah').open()
#   @close()
#   @close(-> console.log 'close animation ended')
#   @content
#   @load('/blah/url')
#   @load('/blah/url', callback: -> console.log('loaded'),
#                      confirm: 'Are you sure?')
#   @open()

$ = jQuery

class @RollupModalView extends Backbone.View

  initialize: (opts) ->
    @options = opts
    @content ||= @options['content'] || ''
    @buttons ||= @options['buttons'] || []
    _.bindAll(@, 'load', 'closeClicked', 'close')
    @opened = false
    @$el.addClass('rollup-modal')
    # override window.confirm to allow custom ESC behavior
    window.origConfirm ||= window.confirm
    @render()

  stubCustomConfirm: ->
    window.confirm = =>
      if @opened
        @escEnabled = false
        _.delay (=> @escEnabled = true), 300
        origConfirm.apply(window, arguments)
      else
        origConfirm.apply(window, arguments)

  open: -> 
    return if @opened
    return if $('#modals>div').size()
    $('#modals').removeClass('empty')
    @opened = true
    @openingDelayComplete = false
    @stubCustomConfirm()
    $('#modals').appendTo($('body')) unless $('#modals').parent('body').size()
    @$el.appendTo($('#modals'))
    _.defer(=> @$el.addClass('up') && @onOpen())
    _.delay((=>
      $('body').css(height: '100%', 'overflow-y': 'hidden')
      $('div.rollup-modal.up').click (e) =>
        return unless $(e.target).hasClass('rollup-modal')
        e.preventDefault()
        @close()
      @initScroll = [window.scrollX, window.scrollY]
      @escEnabled = true
      #$(window).scroll => window.scrollTo(@initScroll[0], @initScroll[1])
      $(window).on 'keyup.rollup_modal_esc', (e) => 
        if e.keyCode == 27 && @escEnabled # user pressed escape
          # check if there is a jquery Dialog above us
          $dialog = $('.ui-dialog:visible')
          if $dialog.size() > 0
            unless $('.loading:visible', $dialog).size() > 0
              $('.ui-dialog-content', $dialog).dialog('close')
            return
          # check if there is a select2 dropdown that is active:
          # $dropdowns = $('.select2-drop-active:visible')
          # if $dropdowns.size() > 0
          #   sel2 = $dropdowns.data("select2")
          #   sel2.close() if sel2
          #   return
          # otherwise, attempt to close
          @close() 
      @openingDelayComplete = true
    ), 300)

  close: (opts={}) ->  # opts: { confirm: 'Are you sure..'}
    return unless @opened
    # opts: { callback: -> console.log('closed.') }
    opts['confirm'] ?= @options['confirm']
    if opts['confirm'] && !confirm(opts['confirm'])        
      return false
    @escEnabled = true
    @opened = false
    @$el.removeClass('up')
    @onClose()
    $('body').css(height: 'auto', 'overflow-y': 'auto')
    _.delay((->
      $('#modals').html('')
      opts['callback'].call(this) if opts['callback']
    ), 320)
    $(window).unbind('keyup.rollup_modal_esc')
    $('body').css(height: 'auto', 'overflow-y': 'auto')
    _.delay((->
      $('#modals').html('')
      $('#modals').addClass('empty')
      opts['callback'].call(this) if opts['callback']
    ), 320)

  events: 
    'click a.close': 'closeClicked'
  closeClicked: (e) ->
    @close()
    false

  template: _.template($('#rollup-modal').html())

  load: (url, cb=->) -> #x loads html from a given URL and drops it in
    $content = $('.content', @$el).addClass('loading')
    $content.html('')
    @open()
    $.ajax
      url: url
      dataType: "html"
      success: (data) =>
        loadit = =>
          $content.removeClass('loading')
          $content.html(data)
          cb.apply(this, arguments)
          @onLoad.call(this) if @onLoad

        if !@openingDelayComplete
          _.delay loadit, 300
        else
          loadit.call(this, data)

  onClose: ->
    @options['onClose'].call(this) if @options['onClose']

  onOpen: ->
    @options['onOpen'].call(this) if @options['onOpen']

  onLoad: ->
    @options['onLoad'].call(this) if @options['onLoad']

  render: =>
    super
    @$el.html(@template(@))
    $btn = null
    _.each @buttons || [], (btn) =>
      $span = $('<span />', class: 'btn')
      $span.addClass(btn.class) if btn.class?
      $btn = $('<a />', class: 'btn')
      $btn.text(btn.name)
      $btn.addClass(btn.class) if btn.class?
      $span.append($btn)
      _.defer => $('div.actions', @el).append($span)
    @el


