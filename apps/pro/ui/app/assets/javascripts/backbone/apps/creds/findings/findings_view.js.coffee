define [
  'base_layout'
  'base_view'
  'base_itemview'
  'apps/creds/findings/templates/private_cell'
  'apps/creds/findings/templates/private_cell_disclosure_dialog'
  'apps/creds/findings/templates/realm_cell'
  'apps/creds/findings/templates/logins_hover'
  'lib/concerns/views/hover_timeout'
  'apps/creds/findings/templates/realm_hover'
  'apps/creds/findings/templates/sessions_hover'
], () ->
  @Pro.module 'CredsApp.Findings', (Findings, App, Backbone, Marionette, $, _) ->

    class Findings.PrivateCellDisclosureDialog extends App.Views.ItemView
      template: @::templatePath 'creds/findings/private_cell_disclosure_dialog'


    class Findings.Private extends App.Views.ItemView
      template: @::templatePath 'creds/findings/private_cell'

      events:
        'click a' : '_showPrivateModal'


      _showPrivateModal: () ->
        dialogView = new Findings.PrivateCellDisclosureDialog model: @model

        App.execute 'showModal', dialogView,
          modal:
            title: 'Private Data'
            description: ''
            width: 600
            height: 400
          buttons: [
            { name: 'Close', class: 'close'}
          ]


    class Findings.Realm extends App.Views.Layout
      template: @::templatePath 'creds/findings/realm_cell'

      regions:
        hoverRegion: '.hover-region'

      @include "HoverTimeout"


    class Findings.RealmHover extends App.Views.ItemView
      template: @::templatePath 'creds/findings/realm_hover'

      className: 'realm-hover'


    class Findings.SuccessfulLogins extends App.Views.ItemView
      template: (m) ->
        subject = 'credential'
        numHosts = parseInt(m.successful_logins, 10)
        subject += 's' if numHosts isnt 1
        phrase = _.escape "#{_.escape m.successful_logins} #{subject}"
        if numHosts > 0
          "<a href='javascript:void(0)'>#{phrase}</a>"
        else
          phrase

    class Findings.Sessions extends App.Views.ItemView
      template: (m) ->
        subject = 'session'
        numHosts = parseInt(m.session_count, 10)
        subject += 's' if numHosts isnt 1
        phrase = _.escape "#{_.escape m.session_count} #{subject}"
        if numHosts > 0
          "<a href='javascript:void(0)'>#{phrase}</a>"
        else
          phrase

    class Findings.LoginsHover extends Pro.Views.CompositeView
      className: 'hover-square'
      template: @::templatePath('creds/findings/logins_hover')
      ui:
        scrollie: '.scrollie'
      onShow: ->
        @timeout = setTimeout(@sync, 500)
      onDestroy: ->
        clearTimeout(@timeout)
      sync: =>
        url = Routes.task_detail_path(
          WORKSPACE_ID,
          TASK_ID
        ) + "/stats/successful_logins_hover.json?service_id=#{@model.get('id')}"

        $.getJSON(url).done (data) =>
          @model.set(rowData: data)
          @render() if @el?.parentNode?


    class Findings.SessionsHover extends Pro.Views.CompositeView
      className: 'hover-square session'
      template: @::templatePath('creds/findings/sessions_hover')

      ui:
        scrollie: '.scrollie'

      onShow: ->
        @timeout = setTimeout(@sync,500)

      onDestroy: ->
        clearTimeout(@timeout)

      sync: =>
        url = Routes.task_detail_path(
          WORKSPACE_ID,
          TASK_ID
        ) + "/stats/sessions_hover.json?service_id=#{@model.get('attempt_ids')}"

        $.getJSON(url).done (data) =>
          @model.set(rowData: data)
          @render() if @el?.parentNode?
