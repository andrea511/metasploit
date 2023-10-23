define [
  'base_layout'
  'base_view'
  'base_itemview'
  'lib/shared/nexpose_sites/templates/view'
  'lib/components/table/table_controller'
  'lib/shared/nexpose_sites/templates/sites_filter'
  'lib/components/filter/filter_controller'
], () ->
  @Pro.module 'Shared.NexposeSites', (NexposeSites, App, Backbone, Marionette, $, _) ->

    class NexposeSites.Layout extends App.Views.Layout
      template: @::templatePath 'nexpose_sites/view'


      regions:
        siteRegion: '.site-region'
        filterRegion: '.filter-region'

      initialize: (opts) ->
        _.defaults opts,
          htmlID: 'nexpose-sites'

        {@collection, @htmlID} = opts

      onShow: ->
        @_renderSitesTable(@collection,@siteRegion,
          filterOpts:
            filterValuesEndpoint: Routes.filter_values_workspace_nexpose_data_sites_path(WORKSPACE_ID)
            helpEndpoint: Routes.search_operators_workspace_nexpose_data_sites_path(WORKSPACE_ID)
            keys: ['name']
            filterRegion: @getRegion('filterRegion')
          htmlID: @htmlID
        )

        @listenTo @, 'filter:query:new', (query) ->
          @table.applyCustomFilter(query)


      _renderSitesTable: (collection,region,opts={}) ->
        extraColumns = opts.extraColumns || []

        columns = _.union([
          {
            label: 'Name'
            attribute: 'name'
          # TODO: This doesn't work, for the moment.
          }
          {
            label: 'Assets'
            attribute: 'summary.assets_count'
            sortable: false
          }
          {
            label: 'Vulns'
            attribute: 'summary.critical_vulnerabilities_count'
            sortable: false
          }
          {
            label: 'Last Scan'
            attribute: 'last_scan_date'
          }
        ], extraColumns)

        @table = App.request "table:component", _.extend {
          region:             region
          taggable:           true
          selectable:         true
          static:             false
          collection:         collection
          htmlID:             opts.htmlID
          perPage:            100
          defaultSort:        'public.username'
          columns: columns
        }, opts

        @trigger 'table:initialized'
        @table