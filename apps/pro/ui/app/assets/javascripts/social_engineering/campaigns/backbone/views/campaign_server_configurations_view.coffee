jQueryInWindow ($) ->
  class @CampaignServerConfigurationsView extends Backbone.View
    SMTP_CHECK_URL: "email_server_config/check_smtp"

    initialize: (opts) ->
      _.bindAll(this, 'render', 'update', 'webServerConfigClicked', 'emailServerConfigClicked')
      @campaignSummary = opts['campaignSummary']
      @campaignSummary.bind('change', @update)

    events:
      'click ul li a' : 'implicitlyCreateCampaign'
      'click .web-server-config-open-modal' : 'webServerConfigClicked'
      'click .email-server-config-open-modal' : 'emailServerConfigClicked'

    baseURL: ->
      "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns/#{@campaignSummary.id}"

    configModalOpts: ->
      opts = {
        confirm: 'Are you sure you want to close? Your unsaved changes will be lost.'
        save: =>
          $form = $('form', @modal.el).first()
          Placeholders.submitHandler($form[0]) # resolve any placeholder polyfills from being submitted

          #Use iframe transport if we have a file
          if $(':file', $form).size() >0
            data = $(':input', $form[0]).not(':file').serializeArray()

            $.ajax(
              url: $form.attr('action'),
              type: $form.attr('method'),
              data: data
              iframe: true,
              files: $(':file', $form)
              processData: false
              complete: (data)  =>
                data = $.parseJSON(data.responseText)
                if data.success == true
                  @_successCallback(data)
                else
                  @_errorCallback(data.error)
            )
          else
            $.ajax(
              url: $form.attr('action'),
              type: $form.attr('method'),
              data: $form.serialize(),
              success: (data) => # data is the new CampaignSummary object
                @_successCallback(data)
              error: (response) =>
                @_errorCallback(response.responseText)
            )
      }

    _errorCallback: (error) ->
      $('.content-frame>.content', @modal.el).html(error)
      @modal.onLoad()
      @modal.options['onLoad'].call(this) if @modal.options['onLoad']

    _successCallback: (data) ->
      @campaignSummary.set(data)
      @update()
      @modal.close(confirm: false)


    implicitlyCreateCampaign: (e) ->
      # create campaign if it doesnt exist
      if @campaignSummary.id == null
        e.stopImmediatePropagation() # freeze the event chain!!!!
        e.stopPropagation()
        e.preventDefault()
        data = $('form.social_engineering_campaign', @el).serialize()
        $(document).trigger('createCampaign', { data: data, callback: ->
          $(e.target).click() # continue up the event chain
        })

    webServerConfigClicked: (e) ->
      url = "#{@baseURL()}/web_server_config/edit"
      bapExists = _.any(@campaignSummary.get('campaign_components'), (comp) ->
        comp.type == 'web_page' && comp.attack_type.toLowerCase() == 'bap'
      )
      shouldShowBapOptions = (!@campaignSummary.usesWizard() && bapExists)

      opts = @configModalOpts()
      opts['onLoad'] = ->
        # do some shit to the web server config form
        # focus the custom field when you click on the correct radio button
        $("[name='social_engineering_campaign[web_host]']", @el).last().bind 'click focus', =>
          $("input[name='social_engineering_campaign[web_host_custom]']", @el).focus()

        # initially focus on the selected radio button
        $("[name='social_engineering_campaign[web_host]'][checked]", @el).focus()

        # show/hide SSL options
        $sslCheckbox = $("[name='social_engineering_campaign[web_ssl]']", @el)
        $sslCheckbox.change (e) ->
          ssl = $(e.target).is(':checked')
          $('div.ssl-options').toggle(ssl)
          # if port 80, toggle to 443 and vise-versa
          $port = $("[name='social_engineering_campaign[web_port]']", @el)
          $port.val('443') if ssl && $port.val() == '80'
          $port.val('80') if !ssl && $port.val() == '443'

        $sslCheckbox.change() # render initial state

        $customCertCheckbox = $("[name='social_engineering_campaign[web_ssl_use_custom_cert]']", @el)
        $customCertCheckbox.change (e) ->
          checked = $(e.target).is(':checked')
          $tf = $("[name='social_engineering_campaign[web_ssl_cert]']", @el)
          $tf.toggle(checked)

        $customCertCheckbox.change()

        $textField = $("input[name='social_engineering_campaign[web_host_custom]']", @el)
        $("label[for=social_engineering_campaign_web_host_custom_value]", @el).append($textField)
        $('.bap-options', @el).toggle(shouldShowBapOptions)

      saveCallback = opts['save']
      opts['save'] = -> # rewrite some of this shit
        $lastRadio = $("[name='social_engineering_campaign[web_host]']", @el).last()
        if $lastRadio.prop('checked')
          $textField = $("input[name='social_engineering_campaign[web_host_custom]']", @el)
          $lastRadio.val($textField.val())
          $textField.remove()
        Placeholders.submitHandler($('form', @el)[0])
        saveCallback.call(this) if saveCallback

      @modal = new FormView(opts)
      @modal.load(url)

    emailServerConfigClicked: (e) ->
      url = "#{@baseURL()}/email_server_config/edit"
      smtpCheckUrl = "#{@baseURL()}/#{@SMTP_CHECK_URL}"
      opts = @configModalOpts()
      saveCallback = opts['save']
      opts['save'] = -> # this runs in the context of the rollup modal
        # this is a confusing paradigm. this code should be moved
        # into e.g. a SMTPSettingsFormView class
        $form = $('form', @el).first()
        data = $form.serialize()
        $('.validate-box .status', @el).removeClass('bad ok')
          .text('Verifying SMTP settings...').addClass('spinning')
        $('a.save.primary', @el).addClass('ui-disabled')
          .parent('span').addClass('ui-disabled')
        $.ajax(
          url: smtpCheckUrl
          type: 'POST'
          data: data
          success: (resp) =>
            return unless @opened
            $status = $('.validate-box .status', @el)
            $status.removeClass('spinning bad').addClass('ok')
            data = $.parseJSON(resp.responseText)
            $status.text('Connection successful')
            $('a.save.primary', @el).removeClass('ui-disabled')
              .parent('span').removeClass('ui-disabled')
            saveCallback()
          error: (resp) =>
            return unless @opened
            $status = $('.validate-box .status', @el)
            $status.removeClass('spinning ok').addClass('bad')
            data = $.parseJSON(resp.responseText)
            $status.text(data['error_msg'])
            $('a.save.primary', @el).removeClass('ui-disabled')
              .parent('span').removeClass('ui-disabled')
            return unless confirm("We were unable to connect to the provided SMTP server." +
              " Do you want to save anyway?")
            saveCallback()
        )
      opts['onLoad'] = ->
        TAB_KEY_CODE = 9
        $smtpPassField = $("input[name='social_engineering_campaign[smtp_password]']", @el)
        $smtpPassField.keydown (e) ->
          if e.keyCode != TAB_KEY_CODE and !e.shiftKey and $(e.target).val() == PASSWORD_UNCHANGED
            $(e.target).val('')

      @modal = new FormView(opts)
      @modal.load(url)

    template: _.template($('#campaign-server-configurations').html())

    update: ->
      components = @campaignSummary.get('campaign_components')
      configType = @campaignSummary.get('config_type')
      webCount = components.filter((c) -> c.type == 'web_page').length
      emailCount = components.filter((c) -> c.type == 'email').length
      configData = @campaignSummary.get('campaign_configuration')
      if configType != 'wizard' && (!@campaignSummary.id || (webCount + emailCount == 0))
        $('.campaign-server-config-div', @el).addClass('disabled')
      else
        $('.campaign-server-config-div', @el).removeClass('disabled')
        $('ul.campaign-server-config-items>li', @el).hide()
        if configType == 'wizard' || webCount > 0
          $li = $('li.web-server-config-open-modal', @el)
          $li.show().removeClass('unconfigured')
          showWebConfigured = configType == 'wizard' && @campaignSummary.id == null
          $li.addClass('unconfigured') unless showWebConfigured || configData['web_config']['configured']
        if configType == 'wizard' || emailCount > 0
          $li = $('li.email-server-config-open-modal', @el)
          $li.show().removeClass('unconfigured')
          $li.addClass('unconfigured') unless configData['smtp_config']['configured']
    render: ->
      @dom = $($.parseHTML(@template(this))[1]).appendTo $(@el)
      @update()

