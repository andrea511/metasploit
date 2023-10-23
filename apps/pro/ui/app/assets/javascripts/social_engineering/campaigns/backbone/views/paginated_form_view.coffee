jQueryInWindow ($) ->
  class @PaginatedFormView extends @FormView
    initialize: ->
      super
      _.bindAll(this, 'circleClicked', 'page')
      
    events: _.extend({
      'click .actions a.cancel': 'close'
      'click .actions a.save': 'save'
      'click .page-circles .cell': 'circleClicked'
    }, PaginatedRollupModalView.prototype.events)

    headerTemplate: _.template($('#paginated-rollup-view-header').html())

    circleClicked: (e) ->
      idx = $('.header .page-circles .cell', @el).index($(e.currentTarget))
      @page(idx)

    page: (idx) ->
      super
      $('.header .page-circles .cell', @el).removeClass('selected')
      $('.header .page-circles .cell', @el).eq(idx).addClass('selected')
      if @largeTitles && @largeTitles.length > idx && @largeTitles[idx]
        $('.header h3', @el).text(@largeTitles[idx])

    onLoad: ->
      @renderHeader()
      super
      # if a user tabs to a new input, make sure to slide to whatever
      # page the input happens to be in
      focusFirst = => 
        $('button,input,textarea,select,:input', @el).filter(':visible').first().focus()
      
      # $(@el).keydown (e) =>
      #   if e.keyCode == 9 # tab key
      #     target = $(':focus', @el).first()
      #     e.preventDefault()
      #     if target.size() > 0
      #       $fields = $(target).parents('form:eq(0)')
      #         .find('button,input,textarea,select,:input,a.select2-choice').filter(':visible')
      #       idx = $fields.index(e.target)
      #       if idx > -1 && idx < $fields.size()
      #         $fields.eq(idx+1).focus()
      #       else
      #         focusFirst()
      #     else
      #       focusFirst()

      # focus on the first input element
      _.defer focusFirst

    renderHeader: ->
      @largeTitles = _.map($('div.page.row>div.cell', @el), (item) -> $(item).attr('title-large') )
      @pageNames = _.map($('div.page.row>div.cell', @el), (item) -> $(item).attr('title') )
      @title = $('div.page.row', @el).attr('title')
      hdr = @headerTemplate(this)
      @header ||= $($.parseHTML(hdr)).insertAfter($('.content-frame', @el))
      if @largeTitles && @largeTitles.length > 0 && @largeTitles[0]
        $('.header h3', @el).text(@largeTitles[0])

    actionButtons: ->  [
      [['next primary', 'Next']], 
      [['prev link3 no-span', 'Previous'], ['save primary', 'Save']]
    ]
