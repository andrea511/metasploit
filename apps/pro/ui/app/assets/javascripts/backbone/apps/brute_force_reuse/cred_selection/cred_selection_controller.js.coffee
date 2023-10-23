define [
  'base_controller'
  'entities/cred'
  'entities/cred_group'
  'apps/brute_force_reuse/cred_selection/cred_selection_view'
  'lib/concerns/controllers/render_cores_table'
  'lib/components/filter/filter_controller'
], ->

  @Pro.module 'BruteForceReuseApp.CredSelection', (CredSelection, App) ->

    # The BruteForceReuseApp.CredSelectionController class is responsible for displaying
    # the credential selection portion of the Credential Reuse workflow.
    # It renders a Table component containing all Cores in the workspace and
    # allows the user to filter and select specific cores to use.
    class CredSelection.Controller extends App.Controllers.Application

      # Mixes in the logic for rendering a table of Metasploit::Credential::Cores
      @include 'RenderCoresTable'

      # @property workspace_id [Number] the id of the workspace to look for creds in
      workspace_id: null

      # @property table [App.Components.Table.Controller] the selection table controller
      table: null

      # @property group [App.BruteForceReuseApp.CredSelection.GroupsContainer] the group
      #   selection CompositeView, for displaying selected groups
      group: null

      # @property layout [App.BruteForceReuseApp.CredSelection.Layout] the primary layout
      #   for this controller
      layout: null

      # @param opts [Object] the options hash
      # @option opts workingGroup [Entities.CredGroup] a group of manually chosen creds
      # @option workspace_id [Number] @see CredSelection.Controller#workspace_id
      # @option show [Boolean] show the views immediately
      initialize: (opts={}) ->
        @workspace_id = opts.workspace_id || WORKSPACE_ID

        _.defaults(opts, show: true)

        creds = App.request 'creds:entities'
          workspace_id: @workspace_id

        @layout = new CredSelection.Layout
        @setMainView(@layout)

        @groups = new CredSelection.GroupsContainer(_.pick(opts, 'workingGroup'))

        @listenTo @layout, 'show', =>
          @show @groups, region: @getMainView().groupsRegion

          @table = @renderCoresTable creds, @layout.credsRegion,
            htmlID: 'reuse-creds'
            withoutColumns: ['clone', 'type', 'logins_count', 'validation', 'origin_type', 'pretty_realm']
            actionButtons:  []
            disableCredLinks: true
            filterOpts:
              filterValuesEndpoint: window.gon.filter_values_workspace_metasploit_credential_cores_path
              keys: ['logins.status'
                     'private.data'
                     'private.type'
                     'public.username'
                     'realm.key'
                     'realm.value'
                     'tags.name']

              staticFacets:
                'private.type': [
                  {
                    value: 'SSH key'
                    label: 'SSH Key'
                  }
                  {
                    value: 'NTLM hash'
                    label: 'NTLM Hash'
                  }
                  {
                    value: 'Nonreplayable hash',
                    label: 'Hash'
                  }
                  {
                    value: 'Password'
                    label: 'Plain-text Password'
                  }
                ]
                'realm.key'    : Pro.Entities.Cred.Realms.ALL.map (name)-> { value: name, label: name }
                'logins.status': Pro.Entities.Login.Status.ALL.map (name)-> { value: name, label: name }

          @listenTo @table.collection, 'all', _.debounce((=>
            @getMainView().adjustSize()
            @groups.workingGroupView.lazyList.resize()
          ), 50)

          @listenTo @groups.workingGroupView.lazyList.collection, 'all',
            _.debounce(@refreshNextButton, 50)

        @listenTo @layout, 'creds:addToCart', =>
          if @table.tableSelections.selectAllState
            @table.collection.fetchIDs(@table.tableSelections)
              .done (ids) =>
                ids = _.difference(ids, _.keys(@table.tableSelections.deselectedIDs))
                @groups.workingGroupView.lazyList.addIDs(ids)
                @refreshNextButton()
          else
            @groups.workingGroupView.lazyList.addIDs(_.keys @table.tableSelections.selectedIDs)
            @refreshNextButton()

        _.defer =>
          @groups.selectionUpdated()
          @refreshNextButton()

        @show @layout, @region if opts.show

      refreshNextButton: =>
        @layout.toggleNext(!_.isEmpty(@groups.workingGroupView.lazyList.collection.ids))

      addCred: (core_id) =>
        @groups.workingGroupView.lazyList.addIDs([core_id])
