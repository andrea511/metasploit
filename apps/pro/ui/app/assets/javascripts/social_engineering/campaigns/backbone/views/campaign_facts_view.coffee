jQueryInWindow ($) ->
  class @CampaignFactsView extends Backbone.View
    initialize: (opts) ->
      @actions = [
        'sent_emails',
        'opened_emails',
        'links_clicked',
        'sent_emails', # leave alone for now
        'submitted_forms',
        'opened_sessions',
        'opened_sessions'
      ]
      @attributes = [
        'emails_sent',
        'emails_opened',
        'links_clicked',
        'forms_started',
        'forms_submitted',
        'sessions_opened',
        'sessions_opened',
        'prone_to_bap'  # fix me
      ]
      @campaignSummary = opts['campaignSummary']
      @tabView = opts['tabView']
      _.bindAll(this, 'render', 'circleClicked')
      @campaignSummary.bind 'change', @render
      @prevPercentages = {}
      @canvWidth = 200
      $(window).resize(@resize)

    template: _.template($('#campaign-facts').html())
    circlesTemplate: _.template($('#campaign-facts-circles').html())
    events: 
      'click .large-circles .circle': 'circleClicked'
      'click .campaign-facts-lvl2 .circle' : 'subCircleClicked'

    getClickedCircle: (e) ->
      @tabView.setTabIndex 1
      $circle = $(e.target).parent('.circle')
      $circle = $(e.target) unless $circle.size()
      $circle
    subCircleClicked: (e) ->
      $circle = @getClickedCircle(e)
      idx = 6
      $(@tabView).trigger 'scrollToCircle', [$circle, idx] 

    circleClicked: (e) ->
      $circle = @getClickedCircle(e)
      idx = $circle.parents('.cell').first().prevAll().size()
      $(@tabView).trigger 'scrollToCircle', [$circle, idx]

    addVisibilityClasses: (campaignFacts) ->
      for own factName, fact of campaignFacts
        fact['cellClass'] = if fact.visible then '' else 'hidden-cell'
        fact['cellClass'] += " #{factName}"

    resetCircleClasses: -> # set necessary first/last class for browsers missing :first-child etc.
      $circs = $('.large-circles .cell', @el).not('.hidden-cell').removeClass('first last')
      $circs.first().addClass('first')
      $circs.last().addClass('last')

    visibleCircles: -> $('.large-circles .cell', @el).not('.hidden-cell')

    leftMargin: -> (100-(@visibleCircles().size() * (11.66667 + 5) - 11.6667))/2

    centerCircles: -> # have to do this manually with margins. i am filled with sadness and regret
      $circs = @visibleCircles()
      $circs.removeAttr('style') # reset styles to defaults
      $circs.first().css('margin-left', @leftMargin() + '%')

    anyCirclesVisible: (campaignFacts) -> # returns true if any of the campaignFacts.visible is true
      !!_.find(campaignFacts, (fact) -> return fact.visible) # _.find returns undefined when

    setVisible: (v) ->
      $facts = $('.campaign-facts', @el).toggle(v).prev('h3').toggle(v)

    renderPie: (idx, perc) -> # canvas sh!t. canvas width is always 200px
      unless typeof perc == 'number' # calculate perc
        attr = @attributes[idx]
        campaignFacts = @campaignSummary.get('campaign_facts')
        total = parseInt(campaignFacts['emails_sent'].count) || 0
        return if campaignFacts[attr].count == ''
        perc = campaignFacts[attr].count/total*100
      $canvases = $('canvas', @el)
      return unless $canvases.size() > idx
      c = $canvases[idx].getContext('2d')
      return unless c
      w = @canvWidth
      c.clearRect(0, 0, w, w)
      c.beginPath()
      c.moveTo(w/2, w/2)
      c.arc(w/2, w/2, w/2, -Math.PI/2, Math.PI*perc*2/(w/2)-Math.PI/2, false)
      c.closePath()
      c.fillStyle = '#bbb'
      c.fillStyle = '#FF9327' if idx == @selIdx
      c.fill()

    animatePie: (idx) ->
      $canv = $('canvas', @el).eq(idx)
      $canv.css('font-size', '0')
      attr = @attributes[idx]
      campaignFacts = @campaignSummary.get('campaign_facts')
      percent = campaignFacts[attr].percentage
      
      _.delay (=>
        $canv.parent().css('font-size': @prevPercentages[attr] || 0)
        $canv.parent().animate { 'font-size': percent+'px' },
          duration: 400
          step: (currSize) =>
            dur = parseInt(currSize)
            @renderPie(idx, dur)
          queue: true
        @prevPercentages[attr] = percent
      ), 300

    resize: =>
      @canvWidth = $('.circle:visible', @el).first().width()
      $('canvas', @el).attr('width', @canvWidth).attr('height', @canvWidth)
      @animatePie(i) for i in [0..@actions.length]

    render: ->
      campaignFacts = _.deepClone(@campaignSummary.get('campaign_facts'))
      campaignDetails = _.deepClone(@campaignSummary.get('campaign_details'))
      @addVisibilityClasses(campaignFacts)
      @dom ||= $(@template({ 
        campaignFacts: campaignFacts,
        campaignDetails: campaignDetails
      })).appendTo(@$el)
      $('.circles', @el).html @circlesTemplate(campaignFacts: campaignFacts)
      @resetCircleClasses()
      @centerCircles()
      @animatePie(i) for i in [0..@actions.length]
