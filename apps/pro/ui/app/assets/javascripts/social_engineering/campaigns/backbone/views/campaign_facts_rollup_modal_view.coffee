jQueryInWindow ($) ->
  class @CampaignFactsRollupModalView extends @PaginatedRollupModalView
    initialize: (opts) ->
      _.bindAll(this, 'render')
      @campaignSummary = opts['campaignSummary']

      super
      @length = 1

    render: ->
      super
      $content = $('div.content', @el)
      factsView = new CampaignSlideFactsView(
        el: $content[0], 
        campaignSummary: @campaignSummary
      )
      factsView.render()
      @renderActionButtons()

    events: _.extend({
        'click .actions span.done a': 'close'
      }, PaginatedRollupModalView.prototype.events)

    actionButtons: ->  [[['done primary', 'Done']]]