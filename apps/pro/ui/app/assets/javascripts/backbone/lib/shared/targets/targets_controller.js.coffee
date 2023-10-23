define [
  'base_controller'
  'lib/shared/targets/targets_views'
  'lib/shared/target_list/target_list_controller'
  'entities/target'
  'lib/components/table/cell_views'
  'lib/components/filter/filter_controller'
], ->
  @Pro.module "Shared.Targets" , (Targets, App) ->

    #
    # Contains the Targets
    #
    class Targets.Controller extends App.Controllers.Application

      # Create a new instance of the Target Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      initialize: (options = {}) ->
        @workspace_id = options.workspace_id || WORKSPACE_ID
        #Set default key/values if key not defined in options hash
        config = _.defaults options, @_getDefaults()

        targets = App.request 'targets:entities', [],
          workspace_id: @workspace_id

        @targetListCollection ||= options.collection

        # Get Model and View and set as controller's view
        targetsView = new Targets.Layout()

        @setMainView(targetsView)

        @listenTo @getMainView(), 'show', =>
          @targetList = new App.Shared.TargetList.Controller(targetListCollection: @targetListCollection )
          @show @targetList, region: @_mainView.targetListRegion
          @table = @renderTargetsTable targets, @_mainView.targetsRegion,
            filterOpts:
              filterValuesEndpoint: window.gon.filter_values_workspace_brute_force_reuse_targets_path
              keys: [
                     'host.name'
                     'host.address'
                     'host.os_name'
                     { value: 'name',  label: 'service.name'  }
                     { value: 'info',  label: 'service.info'  }
                     { value: 'port',  label: 'service.port'  }
                     { value: 'proto', label: 'service.proto' }]
              staticFacets:
                'proto'    : Pro.Entities.Service.PROTOS.map (name)-> { value: name, label: name }

          @listenTo @table.collection, 'all', _.debounce((=>
            @_mainView.adjustSize()
            @targetList.lazyList.resize()
          ), 50)

          @listenTo @targetList.lazyList.collection, 'all',
            _.debounce(@refreshNextButton, 50)

        @listenTo @getMainView(), 'resized', =>
          @targetList.lazyList.resize()

        @listenTo @getMainView(), 'targets:addToCart', =>
          if @table.tableSelections.selectAllState
            @table.collection.fetchIDs(@table.tableSelections)
              .done (ids) =>
                ids = _.difference(ids, _.keys(@table.tableSelections.deselectedIds))
                @targetList.lazyList.addIDs(ids)
          else
            @targetList.lazyList.addIDs(_.keys @table.tableSelections.selectedIDs)

        @listenTo @getMainView(), 'filter:query:new', (query) ->
          @table.applyCustomFilter(query)

        _.defer => @refreshNextButton()

      refreshNextButton: =>
        @_mainView.toggleNext(!_.isEmpty(@targetList.lazyList.collection.ids))

      # @param collection [Marionette.Collection] the collection to show inside the table
      # @param region [Marionette.Region] the region to render into
      # @param opts [Object] the options hash
      # @option opts extraColumns [Array<Object>] extra column definitions that are tacked on
      # @option opts showClone [Boolean] show the clone column (true)
      renderTargetsTable: (collection, region, opts={}) ->
        extraColumns = opts.extraColumns || []

        columns = _.union([
          {
            label: 'Host'
            attribute: 'host.name'
            sortable: true
            view: Targets.HostnameCellView
          },
          {
            label: 'IP'
            attribute: 'host.address'
            sortable: true
          },
          {
            label: 'OS'
            attribute: 'host.os_name'
            view: Backbone.Marionette.ItemView.extend
              template: (model) ->
                _.escape((model['host.os_name'] || '').replace('Microsoft ', ''))
            sortable: true
          },
          {
            label: 'Service'
            attribute: 'name'
            sortable: true
          },
          {
            label: 'Port'
            attribute: 'port'
            sortable: true
          },
          {
            label: 'Proto'
            attribute: 'proto'
            sortable: true
          },
          {
            label: 'Info'
            attribute: 'info'
            sortable: true
            view: Pro.Components.Table.CellViews.TruncateView(max:14, attribute: 'info')
          }
        ], extraColumns)

        if opts.withoutColumns?
          columns = _.reject(columns, (col) -> _.contains(opts.withoutColumns, col.attribute))

        tableController = App.request "table:component", _.extend {
          htmlID: 'targets'
          region:     region
          taggable:   true
          selectable: true
          static:     false
          collection: collection
          perPage: 20
          columns: columns
        }, opts

    # Reqres Handler to create the Targets Controller
    App.reqres.setHandler "targets:shared", (options={}) ->
      new Targets.Controller options
