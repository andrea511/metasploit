define [
  'lib/components/table/cell_views'
], ->

  @Pro.module 'TasksApp.Findings', (Findings, App) ->

    hostView = Backbone.Marionette.ItemView.extend
      template: (m) ->
        "<a href='/hosts/#{_.escape m.host_id}'>#{_.escape m.address}</a>"

    publicView = Backbone.Marionette.ItemView.extend
      template: (m) ->
        if m.core_id
          "<a href='/workspaces/#{WORKSPACE_ID}/credentials#creds/#{_.escape m.core_id}' class='underline'>#{_.escape m.public}</a>"
        else
          "#{_.escape m.public}"

    Findings.BruteForceReuse =

      stats:
        [
          {
            title: 'Login Attempts'
            type: 'percentage'
            num: 'logins_attempted'
            total: 'maximum_login_attempts'
          }
          {
            title: 'Validated Credentials'
            type: 'percentage'
            num: 'credentials_validated'
            total: 'credentials_selected'
          }
          {
            title: 'Validated Targets'
            type: 'percentage'
            num: 'services_validated'
            total: 'services_selected'
          }
          {
            title: 'Successful Logins'
            type: 'stat'
            num: 'successful_login_attempts'
            percentage_stroke: '#888'
          }
        ]

      tables:

        validated_credentials:
          columns: [
            {
              label: 'Public/Username'
              attribute: 'public'
              view: publicView
            }
            { label: 'Private/Password', attribute: 'private', class: 'truncate' }
            { label: 'Realm',            attribute: 'realm' }
          ]

        login_attempts:
          defaultSort: 'attempted_at'
          columns: [
            {
              label: 'Host IP'
              attribute: 'address'
              view: hostView
            }
            {
              label: 'Host name'
              attribute: 'host_name'
              class: 'truncate'
            }
            { label: 'Service',          attribute: 'service_name' }
            { label: 'Public/Username',  attribute: 'public', view: publicView }
            { label: 'Private/Password', attribute: 'private', class: 'truncate' }
            { label: 'Realm',            attribute: 'realm' }
            { label: 'Attempted at',     attribute: 'attempted_at', defaultDirection: 'asc' }
            { label: 'Result',           attribute: 'status' }
          ]

        validated_targets:
          columns: [
            { label: 'Service', attribute: 'name' }
            { label: 'Port', attribute: 'port' }
            { label: 'Proto', attribute: 'proto' }
            { label: 'State', attribute: 'state' }
            { label: 'Host IP', attribute: 'address', view: hostView }
            { label: 'Host name', attribute: 'host_name' }
          ]

        successful_logins:
          columns: [
            { label: 'Public/Username',  attribute: 'public', view: publicView }
            { label: 'Private/Password', attribute: 'private', class: 'truncate' }
            { label: 'Host IP',          attribute: 'address', view: hostView }
            { label: 'Host name',        attribute: 'host_name' }
            { label: 'Service',          attribute: 'service_name' }
            { label: 'Realm',            attribute: 'realm' }
            { label: 'Port', attribute: 'port' }
            { label: 'Proto', attribute: 'proto' }
          ]
