jQueryInWindow ($) ->
  class @CampaignSummary extends Backbone.Model
    defaults: # h8 this
      name: ''
      config_type: 'wizard'
      web_host: ''
      web_port: 80
      notification_enabled: false
      notification_email_address: ''
      notification_email_subject: ''
      notification_email_message: ''
      id: null
      campaign_facts:
        emails_sent: 
          visible: false
          count: ''
        emails_opened:
          visible: false
          count: ''
        links_clicked:
          visible: false
          count: ''
        forms_started:
          visible: false
          count: ''
        forms_submitted:
          visible: false 
          count: ''
        prone_to_bap:
          visible: false
          count: ''
        sessions_opened:
          visible: false
          count: ''
      campaign_details:
        current_status: ''
        email_count: ''
        web_page_count: ''
        portable_file_count: ''
        email_targets_count: ''
        started_at: ''
        evidence_collected: ''
        name: ''
      campaign_components: []
      campaign_configuration:
        web_config:
          configured: false
        smtp_config:
          configured: false
    webPages: ->
      components = @get('campaign_components')
      _.filter(components, (c) -> c.type == 'web_page')
    emails: ->
      components = @get('campaign_components')
      _.filter(components, (c) -> c.type == 'email')
    hasWebPagesOrEmails: ->
      cd = @get('campaign_details')
      cd.email_count + cd.web_page_count > 0
    hasBeenLaunched: ->
      @get('campaign_details').started_at.toLowerCase() != 'not started'
    running: ->
      @get('campaign_details').current_status.toLowerCase() == 'running'
    preparing: ->
      @get('campaign_details').current_status.toLowerCase() == 'preparing'
    launchable: ->
      @get('campaign_details').startable
    usesWizard: ->
      @get('config_type') == 'wizard'
    save: (opts={}) -> # saves the name and config_type attributes to db
      url = "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns/#{@id}.json"
      paramNames = ['config_type', 'name', 'notification_enabled', 
              'notification_email_message', 'notification_email_address', 'notification_email_subject']
      params = []
      params.push { name: "social_engineering_campaign[#{name}]", value: @get(name) } for name in paramNames
      params.push { name: '_method', value: 'PUT' }
      $.ajax(
        url: url
        data: params
        type: 'POST'
        success: opts['success']
        error: opts['success']
      )
