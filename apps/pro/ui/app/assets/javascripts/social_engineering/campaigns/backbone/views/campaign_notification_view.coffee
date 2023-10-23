jQueryInWindow ($) ->

  DEFAULT_NOTIFICATION_MESSAGE = 'This is to let you know that we are about to launch '+
                                 'a social engineering campaign from Metasploit. '+
                                 'For more information, please contact '+
                                 '[INSERT YOUR CONTACT NAME HERE.]'
  DEFAULT_NOTIFICATION_SUBJECT = 'Launching Metasploit social engineering campaign'

  class @CampaignNotificationView extends Backbone.View
    initialize: (opts) ->
      @campaignSummary = opts['campaignSummary']
      #_.bindAll(this, 'update')
     # @campaignSummary.bind('change', @update)

    createModal: ->
      @modal = $('#notification-dialog').dialog(
        modal: true, 
        title: 'Notification Settings',
        autoOpen: false,
        closeOnEscape: false,
        width: 475,
        buttons: {
          "Cancel": =>
            $(@modal).dialog("close")
            if @formSuccessRequired
              $checkbox = $('input[name=\'social_engineering_campaign[prefs][notifications_enabled]\']', @el)
              $checkbox.removeAttr('checked')
              @notificationsEnabledChanged({target: $checkbox[0]})
          "Save": =>
            @saveNotificationSetup()
        }
      )
      email = @campaignSummary.get('notification_email_address')
      msg = @campaignSummary.get('notification_email_message') || DEFAULT_NOTIFICATION_MESSAGE
      subject = @campaignSummary.get('notification_email_subject') || DEFAULT_NOTIFICATION_SUBJECT
      @setFormValue('notification_email_address', email)
      @setFormValue('notification_email_message', msg)
      @setFormValue('notification_email_subject', subject)

    setModalLoading: (loading=false) ->
      @loadingModal ||= $('<div class="loading">').dialog(
        modal: true, 
        title: 'Loading...',
        autoOpen: false,
        resizable: false,
        closeOnEscape: false,
        width: 300
      )
      if loading
        @modal.dialog('close')
        @loadingModal.dialog('open')
      else
        @modal.dialog('open')
        @loadingModal.dialog('close')

    setFormValue: (name, value) ->
      $("[name='social_engineering_campaign[#{name}]']", @modal).val(value)

    getFormValue: (name) ->
      $("[name='social_engineering_campaign[#{name}]']", @modal).val()

    template: _.template($('#campaign-notification').html())

    events: {
      'change input[name=\'social_engineering_campaign[prefs][notifications_enabled]\']': 'notificationsEnabledChanged'
      'click a.notification-settings': 'showNotificationSetup'
    }

    toggleNotificationsEnabled: (enabled=true) ->
      $checkbox = $('input[name=\'social_engineering_campaign[prefs][notifications_enabled]\']', @el)
      if enabled
        $checkbox.attr('checked', 'checked')
      else
        $checkbox.removeAttr('checked')

    notificationsEnabledChanged: (e) =>
      $checkbox = $(e.target)
      enabled = $checkbox.is(':checked')
      @campaignSummary.set('notification_enabled', enabled)
      $('.notification-settings', @el).toggle(enabled)
      if enabled
        @formSuccessRequired = true
        @showFormModal()
      else
        @setModalLoading(true)
        @campaignSummary.save(
          success: =>
            $(@loadingModal).dialog('close')
          error: =>
            $(@loadingModal).dialog('close')
        )

    showNotificationSetup: (e) ->
      e.preventDefault()
      return if e && e.target && $(e.target).hasClass('ui-disabled')
      @formSuccessRequired = false
      @showFormModal()

    showFormModal: ->
      @createModal()
      $('.errors', @modal).hide()
      @modal.dialog('open')

    saveNotificationSetup: ->
      @setModalLoading(true)
      enabled = $('input[type=checkbox]', @dom).is(':checked')
      oldEmail = @campaignSummary.get('notification_email_address')
      oldMsg = @campaignSummary.get('notification_email_message')
      oldSubject = @campaignSummary.get('notification_email_subject')
      @campaignSummary.set('notification_email_address', @getFormValue('notification_email_address'))
      @campaignSummary.set('notification_email_message', @getFormValue('notification_email_message'))
      @campaignSummary.set('notification_email_subject', @getFormValue('notification_email_subject'))
      @campaignSummary.save(
        success: (data) =>
          @setModalLoading(false)
          if data['success']
            @modal.dialog('close')
          else
            $('.errors', @modal).show().html(data['message'])
            @campaignSummary.set('notification_email_address', oldEmail)
            @campaignSummary.set('notification_email_message', oldMsg)
            @campaignSummary.set('notification_email_subject', oldSubject)
        error: =>
          @setModalLoading(false)
          @modal.dialog('close')
      )

    update: =>
      if @dom
        newDom = $($.parseHTML(@template(this))[1])
        @dom.replaceWith(newDom)
        @dom = newDom
      @dom.toggle(@campaignSummary.id != null) if @dom && @campaignSummary
      enabled = @campaignSummary.get('notification_enabled')
      if enabled
        $('input[type=checkbox]', @dom).attr('checked', 'checked')
      else
        $('input[type=checkbox]', @dom).removeAttr('checked')
      $('.notification-settings', @el).toggle(enabled)

    render: ->
      @dom = $($.parseHTML(@template(this))[1]).appendTo $(@el)
