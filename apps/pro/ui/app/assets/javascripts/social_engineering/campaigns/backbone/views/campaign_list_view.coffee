jQueryInWindow ($) ->
  # no need to export the CampaignSummaryList ?
  class CampaignSummaryList extends Backbone.Collection
    model: CampaignSummary
    url: "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns.json"

  class @CampaignListView extends SingleTabPageView
    @DISABLE_CLICK_FN: (e) -> # add as a click handler to prevent future clicks
      e.preventDefault()
      e.stopPropagation()
      e.stopImmediatePropagation()
      false

    @MAX_CAMPAIGNS_RUNNING: 1
    @CAMPAIGN_RUN_LIMIT_MSG: "Cannot run more than #{@MAX_CAMPAIGNS_RUNNING} campaign at a time."

    # opts: { campaign: , success: ->, error: -> }
    @checkForInitializationErrors = (opts) ->
      url = "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns/" + 
            "#{opts.campaign.id}/check_for_configuration_errors"
      $.ajax(
        url: url
        success: opts['success'] || ->
        error: opts['error'] || ->
      )

    initialize: ->
      _.bindAll(this, 'render', 'testClicked', 'findingsClicked', 'editClicked', 'previewClicked',
                'deleteClicked', 'renderIfVisible', 'willDisplay')
      jsonBlob = $.parseJSON($('meta[name=campaign-summaries-init]').attr('content'))
      $('meta[name=campaign-summaries-init]').remove() # get that sh!t out of my dom
      models = _.map(jsonBlob, (modelAttrs) ->
        new CampaignSummary(modelAttrs)
      )
      @disabledRows = {}
      @collection = new CampaignSummaryList(models)
      @collection.bind 'change', @renderIfVisible
      @poller = new Poller(@collection)
      @loadingModal = $('<div class="loading">').dialog(
        modal: true, 
        title: 'Loading... ',
        closeOnEscape: false,
        autoOpen: false
      )
      super

    willDisplay: ->
      @visible = true
      @poller.start()
      @render() # fuck it, render every time. its cheap.

    willHide: ->
      @visible = false
      @poller.stop() if @poller

    renderIfVisible: (e) ->
      @render() if @visible

    tblTemplate:
      _.template($('#campaign-list').html())

    ajaxAlertOnError: (opts) ->
      $.ajax(
        url: opts['url']
        data: opts['data'] || {}
        dataType: opts['dataType'] || 'json'
        type: opts['type'] || 'get'
        success: opts['success']
        error: (e) ->
          fail = $.parseJSON(e.responseText)
          alert(fail['error']) if (fail && fail['error'])
          opts['error'].call(this) if opts['error']
      )

    events:
      'click .row' : 'editClicked'
      'click .row .actions' : 'stopPropagation'
      'click .row a.start' : 'stopPropagation'
      'click .row .cell .actions a.test': 'testClicked'
      'click .row .cell .actions a.findings': 'findingsClicked'
      'click .row .cell .actions a.edit': 'editClicked'
      'click .row .cell .actions a.delete': 'deleteClicked'
      'click .row .cell .actions a.reset': 'resetClicked'
      'click .row .cell .actions a.preview': 'previewClicked'
      'click .row .cell a.start': 'startClicked'
      'click .row .cell a.stop-campaign': 'stopClicked'
      'click .new-action .btn a.new': 'newCampaignClicked',
      'click .row .cell .actions a.download-portable-file': 'showPortableFileDownloads'

    stopPropagation: (e) ->
      e.stopPropagation()

    flashCampaign: (id) ->
      return unless id 
      _.delay((=>
        $row = $("div.row[campaign-id=#{id}]", @el)
        $('html,body').animate({
          scrollTop: $row.offset().top-0.35*($(window).height())
        }, 200);
        $row.stop().css("background-color", "#DFF0D8").animate({ backgroundColor: "#F8F8F8"}, 1600)
      ), 100)

    rowForClickTarget: (e) ->
      $row = $(e.target).parents('.row').first()
      $row = $(e.target) unless $row.size() > 0
      $row = $(e.target) if $(e.target).hasClass('row')
      $row

    rowIndexForClickTarget: (e) -> # returns index of parent .row
      $row = @rowForClickTarget(e)
      $row.first().prevAll().size() # count of elements before current

    testClicked: (e) ->
      idx = @rowIndexForClickTarget(e)
      e.preventDefault()

    findingsClicked: (e) ->
      idx = @rowIndexForClickTarget(e)
      facts = new CampaignFactsRollupModalView(
        campaignSummary: @collection.models[idx]
      )
      facts.open()
      e.preventDefault()

    showPortableFileDownloads: (e) ->
      idx = @rowIndexForClickTarget(e)
      campaign = @collection.models[idx]
      url = "#{@baseURL()}/#{campaign.id}/portable_file_downloads"
      @loadingModal.dialog('open')
      $.ajax(
        url: url,
        success: (data) =>
          @loadingModal.dialog('close')
          newModal = $('<div></div>').html(data).dialog(
            modal: true, 
            title: 'Portable File Downloads'
          )
        error: =>
          @loadingModal.dialog('close')
      )
      e.preventDefault()

    editClicked: (e) ->
      e.preventDefault()
      idx      = @rowIndexForClickTarget(e)  
      campaign = @collection.models[idx] # grab the CampaignSummary from the collection
      unless campaign.running() || campaign.preparing()
        $row = @rowForClickTarget(e)
        return if $row.hasClass('ui-disabled') || $(e.target).hasClass('ui-disabled')     
        return unless @rowIsEnabled(campaign.id)
        $(document).trigger('editCampaign', campaign)

    newCampaignClicked: ->
      campaign = new CampaignSummary
      $(document).trigger('editCampaign', campaign)

    deleteClicked: (e) ->
      return if $(e.target).hasClass('ui-disabled')
      return unless confirm(
        'Are you sure you want to delete this campaign? ' +
        'All associated campaign data will also be deleted.'
      )
      idx      = @rowIndexForClickTarget(e)
      campaign = @collection.models[idx]
      return unless @rowIsEnabled(campaign.id)
      url = "#{@baseURL()}/#{campaign.id}"
      @ajaxAlertOnError(
        url: url
        type: 'post'
        data: { _method: 'delete' }
        success: (resp) =>
          $row = $("div.row[campaign-id=#{campaign.id}]", @el)
          $row.fadeOut(200)
          $('a', $row).addClass('ui-disabled').click(CampaignListView.DISABLE_CLICK_FN)
          _.delay((=>
            @collection.remove(campaign)
            @render()
          ), 200)
      )
      e.preventDefault()

    baseURL: ->
      "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns"

    toggleLaunchButtons: (id, enabled=false) ->
      $row = $("div.row[campaign-id=#{id}]", @el)
      $('div.launch a', $row).toggleClass('ui-disabled', !enabled)


    startClicked: (e) ->
      e.preventDefault()
      return if $(e.target).hasClass('ui-disabled')
      idx      = @rowIndexForClickTarget(e)
      campaign = @collection.models[idx]
      return unless @rowIsEnabled(campaign.id)
      @toggleLaunchButtons(campaign.id, false)
      $(document).trigger('launchCampaign', 
        campaign: campaign
        error: =>
          @toggleLaunchButtons(campaign.id, true)
      )

    stopClicked: (e) ->
      e.preventDefault()
      return if $(e.target).hasClass('ui-disabled')
      idx = @rowIndexForClickTarget(e)
      campaign = @collection.models[idx]
      return unless @rowIsEnabled(campaign.id)
      @toggleLaunchButtons(campaign.id, false)
      url = "#{@baseURL()}/#{campaign.id}/execute"
      $.ajax
        url: url
        type: 'POST'
        dataType: 'json'
        success: (data) ->
          campaign.set(data)

    resetClicked: (e) ->
      e.preventDefault()
      return if $(e.target).hasClass('ui-disabled')
      $row = @rowForClickTarget(e)
      idx = @rowIndexForClickTarget(e)
      campaign = @collection.models[idx]
      return unless @rowIsEnabled(campaign.id)
      return unless confirm('Are you sure you want to reset your campaign? This will ' +
        'clear all findings and data discovered by the campaign.')
      @disableRow(campaign.id)
      newCampaign = new CampaignSummary # stuff the defaults into our reset campaign
      campaign.set('campaign_facts', newCampaign.get('campaign_facts'))
      $.ajax(
        type: "POST"
        url: "#{@baseURL()}/#{campaign.id}/reset"
        success: =>
          # reset row findings
          @enableRow(campaign.id) # row will be accessible by next render
        error: =>
          @enableRow(campaign.id)
      )

    previewClicked: (e) ->
      e.preventDefault()
      idx = @rowIndexForClickTarget(e)
      modal = new CampaignPreviewModal(
        campaignSummary: @collection.models[idx]
      )
      modal.open()

    disableRow: (id, doUpdate=true) ->
      @disabledRows[id+''] = true
      @update() unless doUpdate

    enableRow: (id, doUpdate=true) ->
      delete @disabledRows[id+'']
      @update() unless doUpdate

    rowIsEnabled: (id) ->
      !@disabledRows[id+'']

    update: ->
      for own key, val of @disabledRows
        $(".row[campaign-id=#{key}]", @el).addClass('ui-disabled')

    render: ->
      @dom ||= super
      @tblDom.remove() if @tblDom
      @tblDom = $($.parseHTML(@tblTemplate(this))).appendTo(@dom)
      $('.campaign-list .row', @el).last().addClass('last')
      $('.campaign-list .row', @el).first().addClass('first')
      $('.campaign-list .row', @el).parents('.cell').first().css('padding-top': '0', 'padding-bottom': '0')
      @update()
