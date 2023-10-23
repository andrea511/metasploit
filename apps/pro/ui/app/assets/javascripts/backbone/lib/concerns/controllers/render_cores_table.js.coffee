define [
  'lib/components/table/table_controller'
  'entities/cred'
  'entities/origin'
  'lib/components/modal/modal_controller'
  'apps/creds/shared/cred_shared_views'
  'lib/components/tags/index/index_controller'
  'apps/creds/new/new_controller'
  'lib/components/tags/new/new_controller'
], ->
  @Pro.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->

    Concerns.RenderCoresTable =

      # @param collection [Marionette.Collection] the collection to show inside the table
      # @param region [Marionette.Region] the region to render into
      # @param opts [Object] the options hash
      # @option opts htmlID [String] the html id of the table element
      # @option opts extraColumns [Array<Object>] extra column definitions that are tacked on
      # @option opts showClone [Boolean] show the clone column (true)
      # @option opts disableCredLinks [Boolean] disable link event triggering when clicking the public.username
      renderCoresTable: (collection, region, opts={}) ->
        extraColumns = opts.extraColumns || []
        showClone = if opts.showClone? then opts.showClone else true

        if showClone
          extraColumns.unshift
            class: 'clone'
            sortable: false
            attribute: 'clone'
            view: App.request('creds:shared:coresTableCloneCell')

        columns = _.union([
          {
            label: 'Logins'
            attribute: 'logins_count'
            # TODO: This doesn't work, for the moment.
            sortable: false
          }
          {
            attribute: 'public.username'
            label: 'Public'
            defaultDirection: 'asc'
            view: App.request 'creds:shared:coresTablePublicCell'
            viewOpts:
              disableCredLinks: opts.disableCredLinks
          }
          {
            label: 'Private'
            class: 'truncate'
            view: App.request 'creds:shared:coresTablePrivateCell'
            attribute: 'private.data'
          }
          {
            label: 'Type'
            attribute: 'pretty_type'
            sortAttribute: 'private.type'
          }
          {
            label: 'Realm'
            attribute: 'pretty_realm'
            class: 'truncate'
            sortAttribute: 'realm.value'
          }
          {
            label: "Origin"
            attribute: 'origin_type'
            view: App.request 'creds:shared:coresTableOriginCell'
          }
          {
            attribute: 'validation'
            sortable: false
          }
          {
            attribute: 'tags'
            sortable: false
            view: App.request 'tags:index:component'
          }
        ], extraColumns)

        if opts.withoutColumns?
          columns = _.reject(columns, (col) -> _.contains(opts.withoutColumns, col.attribute))

        tableController = App.request "table:component", _.extend {
          region:             region
          taggable:           true
          selectable:         true
          static:             false
          collection:         collection
          htmlID:             opts.htmlID
          perPage:            20
          defaultSort:        'public.username'
          actionButtons: [
            {
              label: 'Export'
              click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
                controller = App.request 'creds:export',
                  {
                    selectAllState
                    selectedIDs
                    deselectedIDs
                    selectedVisibleCollection
                    tableCollection
                  }
                App.execute "showModal", controller, {
                  modal:
                    title: 'Export'
                    description: ''
                    height: 280
                    width: 520
                  buttons: [
                    { name: 'Cancel', class: 'close' }
                    { name: 'OK', class: 'btn primary' }
                  ]
                }
            }
            {
              label: 'Delete'
              activateOn: 'any'
              click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
                controller = App.request 'creds:delete',
                  {
                    selectAllState
                    selectedIDs
                    deselectedIDs
                    selectedVisibleCollection
                    tableCollection
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
              click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
                controller = App.request 'creds:new', { tableCollection }
                App.execute "showModal", controller,
                  modal:
                    title: 'Add Credential(s)'
                    description: ''
                    height: 390
                    width: 620
                  buttons: [
                    { name: 'Cancel', class: 'close' }
                    { name: 'OK', class: 'btn primary' }
                  ]
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
                url = "/workspaces/#{WORKSPACE_ID}/metasploit/credential/cores/quick_multi_tag.json"

                controller = App.request 'tags:new:component', collection,
                  {
                    selectAllState
                    selectedIDs
                    deselectedIDs
                    q: query
                    url: url
                    serverAPI: tableCollection.server_api
                    ids_only: true,
                    content: App.request('new:cred:entity').get('taggingModalHelpContent')
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
                    App.vent.trigger 'core:tag:added', tableCollection
            }
          ]
          columns: columns

        }, opts