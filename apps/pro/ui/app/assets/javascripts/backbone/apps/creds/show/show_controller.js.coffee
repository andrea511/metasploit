define [
  'base_controller'
  'lib/components/table/table_controller'
  'apps/creds/show/show_view'
  'entities/login'
  'lib/components/tags/index/index_controller'
  'apps/creds/shared/templates/origin_cell'
  'apps/creds/shared/templates/origin_cell_disclosure_dialog'
], ->
  @Pro.module "CredsApp.Show", (Show, App) ->
    class Show.Controller extends App.Controllers.Application

      # Create a new instance of the ShowController (Logins Table)
      # @option opts show         [Boolean] show view on initilization
      # @option opts cred         [Entity.Cred] the credential core
      # @option opts workspace_id [Integer] the current workspace
      # @option opts id           [Integer] the id for a credential core
      #
      initialize: (options) ->
        _.defaults options,
          show: true

        { @id, cred, show, @workspace_id } = options

        @cred ||= App.request "cred:entity", @id
        @workspace_id ||= WORKSPACE_ID

        @layout = new Show.Layout(model: @cred)
        @setMainView(@layout)

        # Logins for a given core
        relatedLogins = App.request 'logins:entities'
          core_id: @id
          workspace_id: @workspace_id

        # Show Related Logins Table, Tagging View, Core Data in Header
        @listenTo @layout, 'show', =>
          # Private Cell in Logins Header
          privateCredView = App.request 'creds:shared:coresTablePrivateCell',
            { model: @cred, displayFilterLink: true },
            { instantiate: true }

          # Origin Cell in Header
          originCellView = App.request 'creds:shared:coresTableOriginCell',
            { model: @cred },
            { instantiate: true }

          # Set Tag Count
          @cred.set('tag_count', @cred.get('tags').length)
          tagsView = App.request 'tags:index:component', instantiate:true, model: @cred

          @show privateCredView, region: @_mainView.privateRegion
          @show originCellView, region: @_mainView.originRegion
          @show tagsView , region: @_mainView.tags

          # Related Logins Table
          @relatedLoginsRegion relatedLogins, @id
          # Not using the rainbow chart, at the moment.
          #setTimeout(@layout.animatePercent, 2000)

        #Show Reuse Screen with current core pre-populated
        @listenTo @layout, 'reuse:show', () =>
          App.vent.trigger('quickReuse:show',@id)


        @show @layout, region: @region, loading: { loadingType: 'overlay' } if show

      # @param [Backbone.Collection] relatedLogins similar Cred models
      relatedLoginsRegion: (relatedLogins, core_id) ->
        tableController = App.request "table:component"
          title:      'Related Logins'
          region:     @layout.relatedLoginsRegion
          selectable: true
          taggable:   true
          static:     false
          perPage: 20
          defaultSort: 'created_at'
        # Re-enable this when chained search operators land.
          #renderFilterControls: true
          #filterToggleEvent:      @_mainView.filterToggleEvent
          #filterCustomQueryEvent: @_mainView.filterCustomQueryEvent
          #filterTemplatePath:     'targets/filter'
          actionButtons: [
            {
              label: 'Delete'
              activateOn: 'any'
              click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
                controller = App.request 'logins:delete',
                  {
                    selectAllState
                    selectedIDs
                    deselectedIDs
                    selectedVisibleCollection
                    tableCollection
                    credID: core_id
                  }
                App.execute "showModal", controller,
                  modal:
                    title: 'Are you sure?'
                    description: ''
                    height: 150
                    width:  550
                    hideBorder:true
                  buttons: [
                    { name: 'Cancel', class: 'close' }
                    { name: 'OK', class: 'btn primary' }
                  ]
            }
            {
              label: '+ Add'
              class: 'add'
              click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection) ->

                controller = App.request 'logins:new', core_id
                App.execute "showModal", controller, {
                  modal: {
                    title: 'Add Login'
                    hideBorder:true
                    description:''
                    height: 290
                    width: 460
                  }
                  buttons: [
                    {name: 'Cancel', class: 'close'}
                    {name: 'OK', class: 'btn primary'}
                  ]
                }
            }
            {
              label: 'Tag'
              class: 'tag'
              containerClass: 'right'
              activateOn: 'any'
              click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
                ids = if selectAllState then deselectedIDs else selectedIDs

                # Coerce IDs into a collection of models with only id attributes
                models = _.map(ids, (id)-> new Backbone.Model({id: id}))
                collection = new Backbone.Collection(models)

                # Stub out query string for filtered tags
                query = ""
                url = "/workspaces/#{WORKSPACE_ID}/metasploit/credential/cores/#{_.escape core_id}/logins/quick_multi_tag.json"

                controller = App.request 'tags:new:component', collection,
                {
                  selectAllState
                  selectedIDs
                  deselectedIDs
                  q: query
                  url: url
                  serverAPI: tableCollection.server_api
                  ids_only: true
                  content: App.request('new:login:entity').get('taggingModalHelpContent')
                }

                App.execute "showModal", controller,
                  modal:
                    title: 'Tags'
                    description: ''
                    height: 170
                    width: 400
                    hideBorder: true
                  buttons: [
                    {name: 'Cancel', class: 'close'}
                    {name: 'OK', class: 'btn primary'}
                  ]
                  doneCallback: () ->
                    App.vent.trigger 'login:tag:added', tableCollection
            }
          ]
          columns: [
            {
              attribute: 'service.name'
              label: 'Service'
            }
            {
              attribute: 'service.port'
              label: 'Port'
            }
            {
              attribute: 'service.host.name'
              label: 'Host'
              view: Show.SingleHostFilterLink
            }
            {
              attribute: 'access_level'
              label: 'Access Level'
              view: Show.AccessLevel
            }
            {
              attribute: 'tags'
              sortable: false
              view: App.request 'tags:index:component'
            }
            {
              attribute: 'last_attempted_at'
              label: 'Last Attempted'
              view: Backbone.Marionette.ItemView.extend(
                modelEvents:
                  'change:last_attempted_at': 'render'
                template: (m) -> _.escape m.last_attempted_at
              )
            }
            {
              attribute: 'status'
              label: 'Validation'
              view: Show.Validation
              hoverView: Show.ValidationHover
              hoverOn: -> @model.get('status') isnt Pro.Entities.Login.Status.SUCCESSFUL
            }
            {
              label: 'Validate'
              sortable: false
              class: 'get_session'
              view: Show.ValidateAuthentication
            }
          ]
          collection: relatedLogins
