jQueryInWindow ($) ->
  class @CampaignConfigurationView extends Backbone.View
    initialize: (opts) ->
      @campaignSummary = opts['campaignSummary']
      _.bindAll(this, 'render', 'update', 'radioChanged')
      @campaignSummary.bind('change', @update)
      @loadingModal = $('<div class="loading">').dialog(
        modal: true, 
        title: 'Submitting... ',
        autoOpen: false,
        closeOnEscape: false
      )

    template: _.template($('#campaign-configuration').html())

    events: 
      'keydown [name^=\'social_engineering_campaign\']': 'nameChanged',
      'keydown input[type=radio]': 'radioKeyPress'
      'change input[type=radio]': 'radioChanged'

    nameChanged: (e) ->
      $('~p.inline-errors', e.target).remove()
      if e.keyCode == 9 || e.which == 9 # pressed tab
        unless $('input[type=radio]', @el).first().attr('disabled')
          $('input[type=radio]', @el).first().focus()
        e.preventDefault()
        e.stopImmediatePropagation()
        e.stopPropagation()
        return false

    radioKeyPress: (e) ->
      if e.keyCode == 9 || e.which == 9 # pressed tab
        return if e.shiftKey
        e.preventDefault()

    radioChanged: (e) ->
      configType = $('[name="social_engineering_campaign[config_type]"]:checked', @el).val()
      return if configType == @campaignSummary.get('config_type') #nothing has changed
      name = $("[name='social_engineering_campaign[name]']", @el).val()
      if @campaignSummary.get('id') == null
        @campaignSummary.set(config_type: configType, name: name)
      else
        components = @campaignSummary.get('campaign_components')
        confirmMsg = "Are you sure you want to switch this campaign to #{configType} mode? " +
          "This will destroy any web pages, emails, or portable files that " +
          "are currently associated with the campaign."
        if components.length > 0 && !confirm(confirmMsg)
          $('[name="social_engineering_campaign[config_type]"]:not(:checked)', @el).attr('checked', 'checked')
          return
        @campaignSummary.set(config_type: configType, campaign_components: [])
        @loadingModal.dialog('open')
        @campaignSummary.save(
          success: => @loadingModal.dialog('close')
          error: => @loadingModal.dialog('close')
        )

    update: ->
      name = @campaignSummary.get('name')
      $("[name='social_engineering_campaign[name]']", @el).val(name)
        .nextAll('p.inline-errors').fadeOut().delay(200).remove()
      # set radio button for campaign config type
      radioIdx = if @campaignSummary.usesWizard() then 0 else 1
      $radioBtns = $("input[name='social_engineering_campaign[config_type]']")
      $radioBtns.prop('checked', false)
      $radioBtns.eq(radioIdx).prop('checked', true)

    render: ->
      @dom.remove() if @dom
      @campaignConfig = @campaignSummary.get('campaign_configuration')
      @dom = $($.parseHTML(@template(this))[1]).appendTo $(@el)
