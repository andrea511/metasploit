jQueryInWindow ($) ->
  # CampaignConfigurationTabPageView is the FIRST TAB parent view that contains the
  #   CampaignConfigurationView, CampaignComponentsView, and CampaignServerConfigurationsView
  CREATE_URL = "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns.js"

  class @CampaignConfigurationTabPageView extends SingleTabPageView
    initialize: ->
      @campaign = new CampaignSummary
      _.bindAll(this, 'setCampaign', 'createCampaignEvent', 'updateButtons', 'launchCampaignEvent')
      $(document).bind('createCampaign', @createCampaignEvent)
      $(document).bind('launchCampaign', @launchCampaignEvent)
      # Listen for event from CampaignListView
      $(document).bind('editCampaign', @setCampaign)
      @campaign.bind('change', @updateButtons)
      opts = { el: @el, campaignSummary: @campaign }
      @serverConfigView = new CampaignServerConfigurationsView(opts)
      @campaignStatusStrip = new CampaignStatusStrip(opts)
      @campaignComponentsView = new CampaignComponentsView(opts)
      @campaignConfigView = new CampaignConfigurationView(opts)
      @campaignNotificationView = new CampaignNotificationView(opts)
      @loadingModal = $('<div class="loading">').dialog(
        modal: true, 
        title: 'Creating campaign... ',
        autoOpen: false,
        closeOnEscape: false
      )
      super

    events:
      'click .save-campaign': 'saveCampaignClicked'
      'click .cancel-campaign': 'cancelCampaignClicked'
      'click .launch-campaign': 'launchCampaignClicked'

    btnsTemplate: _.template($('#edit-buttons').html())

    willDisplay: -> # wait for @render() to effect browser, then focus
      _.defer => $('form input[type=text]', @el).first().focus()

    createCampaignEvent: (e, opts) -> # used for binding to jquery events
      @createCampaign(opts['data'], opts['callback']) 

    createCampaign: (data, callback) -> # campaign creation logic
      return if @creatingCampaign
      $("[name^='social_engineering_campaign']~p.inline-errors").remove()
      @creatingCampaign = true
      @loadingModal.dialog('open')

      $.ajax(
        type: 'POST', 
        url: CREATE_URL, 
        data: data,
        dataType: 'json', 
        async: false
        success: (data) =>
          @creatingCampaign = false
          @loadingModal.dialog('close')
          if @campaign.usesWizard()
            # toggle webserver cnfig to be configured by default
            @campaign.get('campaign_configuration')['web_config']['configured'] = true
          @campaign.set(data)
          @updateButtons()
          @campaignConfigView.update()
          @campaignNotificationView.update()

          callback.call(this)
        error: (err) =>
          # display errors in form
          @creatingCampaign = false
          @loadingModal.dialog('close')
          errHash = $.parseJSON(err.responseText)['error']
          return unless errHash
          for own key, msgArray of errHash
            $input = $("[name='social_engineering_campaign[#{key}]']").focus()
            $("<p class='inline-errors'>#{msgArray[0]}</p>").insertAfter($input)
              .hide().slideDown().fadeIn()
      )

    baseURL: ->
      "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns"

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

    launchCampaignEvent: (e, opts) ->
      @launchCampaign(opts['campaign'], opts) # for triggering the document.launchCampaign event

    # opts: { campaign: [CampaignSummary], success: ->, error: -> }
    checkForInitializationErrors: (opts) ->
      url = "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns/" + 
            "#{opts.campaign.id}/check_for_configuration_errors"
      $.ajax(
        url: url
        success: opts['success'] || ->
        error: opts['error'] || ->
      )

    # Logic for launching a campaign
    launchCampaign: (campaign, opts={}) ->
      @checkForInitializationErrors
        campaign: campaign
        error: (e) =>
          data = $.parseJSON(e.responseText)
          alert(data['error'])
          opts['error'].call(this) if opts['error']
        success: =>
          numTargets = campaign.get('campaign_details').email_targets_count
          firstEmail = _.find(campaign.get('campaign_components'), ((comp) -> comp.type == 'email'))
          if numTargets > 0 && firstEmail
            emailsText = if numTargets == 1 then 'e-mail' else 'e-mails'
            listName = firstEmail.target_list_name
            unless confirm("You are about to send #{numTargets} #{emailsText} to the '#{listName}' target list.  Are you sure?")
              opts['error'].call(this) if opts['error']
              return

          url = "#{@baseURL()}/#{campaign.id}/execute"
          @ajaxAlertOnError(
            type: 'POST'
            url: url
            success: (data) ->
              # grab the actual campaign?
              listView = CampaignTabView.activeView.tabs[1]
              newCampaign = _.find(listView.collection.models, (c) -> c.id == campaign.id)
              unless newCampaign
                listView.collection.unshift(campaign)
                newCampaign = campaign
              newCampaign.set(data)
              facts = new CampaignFactsRollupModalView(
                campaignSummary: newCampaign
              )
              facts.open()
              opts['success'].call(this) if opts['success']
            error: opts['error'] || ->
          )

    saveCampaignClicked: (e) ->
      if @campaign.id == null # new campaign, try to create it
        @loadingModal.dialog('open')
        data = $('form.social_engineering_campaign', @el).serialize()
        @createCampaign data, =>
          CampaignTabView.activeView.setTabIndex(1)
          listView = CampaignTabView.activeView.tabs[1] # flash our id
          listView.flashCampaign(@campaign.id)
      else # we already save everything, just tab over
        name = $("[name='social_engineering_campaign[name]']", @el).val()
        if name != @campaign.get('name') # save
          @campaign.set('name', name)
          @campaign.save()
        CampaignTabView.activeView.setTabIndex(1)
        listView = CampaignTabView.activeView.tabs[1] # flash our id
        listView.flashCampaign(@campaign.id)
      e.preventDefault()

    cancelCampaignClicked: (e) ->
      e.preventDefault()
      CampaignTabView.activeView.setTabIndex(1)
      listView = CampaignTabView.activeView.tabs[1] # flash our id
      listView.flashCampaign(@campaign.id)
      @setCampaign(null, new CampaignSummary(CampaignSummary.defaults), false)

    launchCampaignClicked: (e) ->
      $launchBtn = $('a.launch-campaign', @el)
      return if $launchBtn.hasClass('ui-disabled')
      $launchBtn.addClass('ui-disabled').parent('span').addClass('ui-disabled')
      @launchCampaign(@campaign,
        success: (data) =>
          CampaignTabView.activeView.setTabIndex(1)
          listView = CampaignTabView.activeView.tabs[1] # flash our id
          listView.flashCampaign(@campaign.id)
        error: =>
          $('a.launch-campaign', @el).removeClass('ui-disabled')
            .parent('span').removeClass('ui-disabled')
      )
      e.preventDefault()

    # Fires when you select a campaign from the list screen
    setCampaign: (e, newCampaign, slide=true) ->
      CampaignTabView.activeView.setTabIndex(0) if slide
      @campaign.set(newCampaign.attributes)
      @campaignComponentsView.render()
      @campaignComponentsView.setEditing(false)
      @campaignConfigView.update()
      @campaignStatusStrip.setInitialCampaign(newCampaign)
      @campaignStatusStrip.render()
      @campaignNotificationView.update(@campaign)
      @updateButtons()

    updateButtons: ->
      actionBtn = 'Save'
      btnsHtml = @btnsTemplate(actionBtnTitle: actionBtn)
      $('.buttons-go-here', @el).html(btnsHtml)

    render: ->
      el = super
      _.each [ @campaignStatusStrip,
               @campaignConfigView,
               @campaignComponentsView,
               @serverConfigView,
               @campaignNotificationView ], (view) ->
        view.setElement(el)
        view.render()
      # add the buttons
      $('<div class="buttons-go-here">').appendTo(el)
      @updateButtons()
