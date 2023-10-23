jQueryInWindow ($) ->
  # PaginatedRollupModalView adds some helpers on top of RollupModalView
  # for handling paginated modals.
  # Usage: new PaginatedRollupModalView(content: 'blah').open()
  #   @PREV_BUTTON # class-level constant for specifying a previous button
  #
  #   @next()
  #   @prev()
  #   @page(3)
  #   @actionButtons: # override this in your subclass
  #     [[@PREV_BUTTON]]
  class @PaginatedRollupModalView extends @RollupModalView
    PREV_BUTTON: ['prev', 'Previous']
    NEXT_BUTTON: ['next', 'Next']
    initialize: ->
      @idx ||= -1
      @length = 1
      _.bindAll(this, 'next', 'prev', 'page', 'resetPaging')
      super
    actionButtons: -> []

    onLoad: ->
      @resetPaging()
      if @initPage
        @page(@initPage)
        @initPage = null
      else
        @page(0)
      super

    resetPaging: ->
      $cells = $('div.content div.row.page>div.cell', @$el)
      @length = $cells.size() || 1
      $('div.content div.page.row', @$el).css('width', 100*@length+'%')
      $cells.css('width', 100/@length+'%').scrollTop(0)

    renderActionButtons: ->
      $actions = $('>div.actions', @$el)
      try
        $actions.html('')
        btns = @actionButtons()
        idx = if @idx < 0 then 0 else @idx
        for btn in btns[idx]
          if btn[0].match /no-span/
            $outerBtn = $("<a href='#' class='#{btn[0]}'>#{btn[1]}</a>")
          else
            $outerBtn = $("<span class='btn #{btn[0]}'></span>")
            $outerBtn.html("<a href='#' class='#{btn[0]}'>#{btn[1]}</a>")
          $outerBtn.appendTo($actions)
      catch e

    page: (idx) ->
      return if idx == @idx || idx >= @length || idx < 0
      @idx = idx
      $cells = $('div.content div.page.row>div.cell', @$el)
      $cells.eq(idx).css(height: 'auto', visibility: 'visible', 'overflow-y': 'visible')
      $('div.content div.page.row', @$el).css('left', -@idx*100+'%')
      _.delay((=>
        $cells = $('div.content div.page.row>div.cell', @$el)
        $cells.not(":eq(#{idx})").css(height: '1px', 'overflow-y': 'hidden', visibility: 'hidden')
      ), 200)
      @renderActionButtons()

    events: _.extend({
      'click .actions a.next': 'next'
      'click .actions a.prev': 'prev'
    }, RollupModalView.prototype.events)
    next: (e) ->
      @page(@idx+1)
      e.preventDefault() if e
    prev: (e) ->
      @page(@idx-1)
      e.preventDefault() if e
