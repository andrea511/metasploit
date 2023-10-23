jQueryInWindow ($) ->
  # generic, reusable TabView class
  # tv = new TabView({ 
  #   tabs: [ new Backbone.View ]
  # })
  # tv.setTabIndex(5)
  class @TabView extends Backbone.View
    initialize:(opts) ->
      @touchEnabled = false
      @index = JUMP_TO_COMPONENT ? opts['index'] ? 0
      @tabs ||= []
      @size ||= @tabs.length
      @render()
      pageWrap = $($.parseHTML($('#tab-pages').html())).appendTo(@el)
      @tabs.each (tab) -> # pre-render and set root element for all pages
        tab.setElement $('.pages', pageWrap)
        tab.render()
      @enableTouchAfter(0.2)

    template: _.template($('#tab-header', @el).html())

    enableTouchAfter: (seconds) ->
      _.delay((=>@touchEnabled=true), seconds*1000) # give tabs 200ms to load

    disableTouch: ->
      @touchEnabled = false

    # 3 tabs are indexed left--> right as 0,1,2
    setTabIndex: (index) ->
      return if index < 0 || index >= @tabs.length
      window.clearTimeout(@oldDelay) if @oldDelay
      oldIndex = @index
      @index = index
      $(@tabs[oldIndex]).trigger('willHide')
      $(@tabs[@index]).trigger('willDisplay')
      $('.tab-header>.cell', @el).removeClass('selected')
      $('.tab-header>.cell', @el).eq(index).addClass('selected')
      $allPages = $('.slider .pages>.cell', @el)
      $page = $('.slider .pages>.cell', @el).eq(index)
      $allPages.css(height: 'auto')
      @oldDelay = _.delay (=>
          @oldDelay = null
          $('.slider .pages>.cell', @el).not(':eq('+index+')')
            .css(height: '1px', overflow: 'hidden', visibility: 'hidden')
        ), 200
      $page.css(height: 'auto', overflow: 'visible', visibility: 'visible')
      $('.slider .pages', @el).css('left', (index*-100)+'%')
      
      if index == 0
        $page.removeClass('loading') if $page.hasClass('loading')
      else if $page.hasClass('loading')
        if @animatable
          _.delay ( => 
            $page.removeClass('loading')
          ), 300
        else
          $page.removeClass('loading')
    
    events:
      'click .tab-header>.cell': 'tabClicked'

    tabClicked: (e) ->
      $target = $(e.target).parentsUntil('.tab-header', '.cell')
      $target = $(e.target) unless $target.length
      if $target
        idx = $('.tab-header>.cell', @el).index($target)
        @userClickedTab(idx)

    userClickedTab: (idx) -> # for overriding
      return if !@touchEnabled
      return if @index == idx
      @disableTouch()
      @enableTouchAfter(0.2)
      @setTabIndex idx

    render: (opts) ->
      @dom.remove() if @dom
      @dom = $($.parseHTML(@template(this))[1]).prependTo $(@el)
      _.delay((=>
        @setTabIndex(@index)
        return if @animatable
        _.defer(=>
          @animatable = true
          $('.slider .pages', @el).addClass('animatable')
        ) # need to wait for previous animation queue to close, before adding this class
      ), 0) # let DOM render before sliding, otherwise dragons
