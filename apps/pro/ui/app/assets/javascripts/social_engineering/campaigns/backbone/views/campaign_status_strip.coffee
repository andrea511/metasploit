jQueryInWindow ($) ->
  class @CampaignStatusStrip extends Backbone.View
    initialize: (opts) ->
      @campaignSummary = opts['campaignSummary']
      _.bindAll(this, 'render', 'updateStatusStrip')
      @campaignSummary.bind('change', @updateStatusStrip)
      @prevId = null
      super

    template: _.template($('#campaign-status').html())

    setInitialCampaign: (campaign) ->
      @prevId = campaign.id

    updateStatusStrip: ->
      @render() unless @prevId == null

    render: ->
      campaignDetails = @campaignSummary.get('campaign_details')
      persisted = @campaignSummary.id != null
      context = { campaignDetails: campaignDetails, persisted: persisted }
      $next = @dom.next().first() if @dom
      @dom.remove() if @dom
      if $next && $next.size()
        @dom = $($.parseHTML(@template(context)))
        @dom.insertBefore $next
      else
        @dom = $($.parseHTML(@template(context)))
        @dom.appendTo $(@el)
        $(@el).css(position: 'relative')
