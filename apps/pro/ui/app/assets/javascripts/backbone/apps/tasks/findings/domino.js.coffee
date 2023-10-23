define [
  'jquery'
  'lib/shared/creds/cell_views'
  'apps/meta_modules/domino/visualization_controller'
  'lib/components/table/table_controller'
], ($) ->

  Pro.module('TasksApp.Findings').Domino =

    stats:
      [
        {
          title: 'Iterations'
          type: 'stat'
          num: 'iterations'
        }
        {
          title: 'Unique Credentials Captured'
          type: 'stat'
          num: 'creds_captured'
        }
        {
          title: 'Hosts Compromised'
          type: 'stat'
          num: 'hosts_compromised'
          badge: (task) ->
            count = task.get('high_values')
            plural = if (count == 1) then '' else 's'
            if count > 0
              "#{count} Designated High Value Host#{plural}"
            else
              null
        }
      ]

    controllers:
      iterations: Pro.MetaModulesApp.Domino.Controller

    tables:
      unique_credentials_captured:
        columns: [
          {
            label: 'Public'
            attribute: 'public'
            view: Pro.Creds.CellViews.Public
          }
          {
            label: 'Private'
            attribute: 'private'
            class: 'truncate'
            view: Pro.Creds.CellViews.Private
          }
          {
            label: 'Realm'
            attribute: 'realm_key'
            view: Pro.Creds.CellViews.Realm
            hoverView: Pro.Creds.CellViews.RealmHover
            hoverOn: ->
              !_.isEmpty(@model.get('realm'))
          }

          {
            label: 'Captured from'
            attribute: 'captured_from_address'
            view: Pro.Creds.CellViews.HostAddress
            viewOpts:
              attribute: 'captured_from_address'
          }
          {
            label: 'Host name'
            attribute: 'captured_from_name'
          }
          {
            label: 'Compromised Hosts'
            attribute: 'compromised_hosts'
            view: Pro.Creds.CellViews.Count
            viewOpts:
              attribute: 'compromised_hosts'
              subject: 'host'
            hoverView: Pro.Creds.CellViews.CollectionHover.extend(
              attributes:
                width: '300px'
              url: ->
                Routes.task_detail_path(
                  @model.get('workspace_id'),
                  @model.get('task_id')
                ) + "/stats/hosts_compromised_from.json?core_id=#{@model.get('core_id')}"
              title: ->
                "Compromised Hosts (#{@model.get('compromised_hosts')}):"
              columns: [
                { label: 'Host IP', size: 6, attribute: 'host_address' }
                { label: 'Host Name', size: 6, attribute: 'host_name' }
              ]
            )
            hoverOn: ->
              parseInt(@model.get('compromised_hosts'), 10) > 0
          }
        ]

      hosts_compromised:
        onShow: (controller) ->
          $checkbox = $("""
              <label class='high-value-only'>
                <input type='checkbox' /> Show High Value Hosts only
              </label>
            """)
          controller.list.$el.parent().append($checkbox)
          $checkbox.on('change', -> onlyHighValueTargets($checkbox.find('input').is(':checked')))
          collection = controller.collection
          collection.on('reset sync', updateRowHighlights)

          updateRowHighlights = ->
            _.each controller.list.table.find('tbody tr'), (tr, idx) =>
              $(tr).toggleClass('high-value', collection.models[idx]?.get?('high_value') is 'true')

          onlyHighValueTargets = (only) ->
            baseURL = collection.url.replace(/[^\/]+$/, '')
            collection.url = if only
              baseURL + 'high_value_hosts_compromised'
            else
              baseURL + 'hosts_compromised'
            collection.goTo(1)

        columns: [
          {
            label: 'Host IP'
            attribute: 'address'
            view: Pro.Creds.CellViews.HostAddress
          }
          { label: 'Host name', attribute: 'name' }
          { label: 'OS',        attribute: 'os_name' }
          { label: 'Service',   attribute: 'service_name' }
          { label: 'Port',      attribute: 'service_port' }
          {
            label: 'Public',
            attribute: 'public',
            view: Pro.Creds.CellViews.Public
          }
          {
            label: 'Private'
            attribute: 'private'
            view: Pro.Creds.CellViews.Private
          }
          {
            label: 'Realm'
            attribute: 'realm_key'
            view: Pro.Creds.CellViews.Realm
            hoverView: Pro.Creds.CellViews.RealmHover
            hoverOn: ->
              !_.isEmpty(@model.get('realm'))
          }
          { 
            label: 'Credentials Looted'
            attribute: 'captured_creds_count'
            view: Pro.Creds.CellViews.Count
            viewOpts:
              attribute: 'captured_creds_count'
              subject: 'credential'
            hoverView: Pro.Creds.CellViews.CollectionHover.extend(
              url: ->
                Routes.task_detail_path(
                  @model.get('workspace_id'),
                  @model.get('task_id')
                ) + "/stats/creds_captured_from.json?node_id=#{@model.get('node_id')}"
              title: ->
                "Credentials Looted (#{@model.get('captured_creds_count')}):"
              columns: [
                { label: 'Public', size: 4, attribute: 'public' }
                { label: 'Private', size: 5, attribute: 'private' }
                { label: 'Private Type', size: 3, attribute: 'private_type' }
              ]
            )
            hoverOn: ->
              parseInt(@model.get('captured_creds_count'), 10) > 0
          }
          {
            label: 'Sessions'
            attribute: 'sessions_count'
            view: Pro.Creds.CellViews.Count
            viewOpts:
              attribute: 'sessions_count'
              subject: 'session'
              link: (m) ->
                Routes.host_path(m.host_id)+'#sessions'
          }
        ]
