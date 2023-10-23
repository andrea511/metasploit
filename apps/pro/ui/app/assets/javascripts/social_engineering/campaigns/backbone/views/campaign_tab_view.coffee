jQueryInWindow ($) ->
  class @CampaignTabView extends @TabView
    initialize: ->
      CampaignTabView.activeView ||= this

      @tabs = [
        new CampaignConfigurationTabPageView(),
        new CampaignListView(),
        new ReusableCampaignElementsView()
      ]
      super

    userClickedTab: (idx) ->
      if idx == 0 && idx != @index # create new campaign
        $(document).trigger('editCampaign', new CampaignSummary, false)
      super(idx)

    render: ->
      super
