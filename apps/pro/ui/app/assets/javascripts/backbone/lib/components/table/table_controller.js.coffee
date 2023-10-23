define [
  'jquery'
  'base_controller'
  'lib/concerns/controllers/pro_carpenter'
  'carpenter'
], ($) ->

  @Pro.module "Components.Table", (Table, App) ->
    Marionette.Carpenter.Controller.include('ProCarpenter')

    #
    # Register an Application-wide handler for rendering a table component
    #
    # This uses Carpenter to build tables (https://github.com/rapid7/marionette.carpenter) .
    # Pro-only extensions are in {Concerns.ProCarpenter}
    #
    # See the official Carpenter documentation for options to build table. Below are Pro-specific options.
    #
    # @param [Object] options the option hash
    # @option options :filterOpts [Object] another params object for rendering a filter region.
    #   if this is not present, table will not render a filter region.
    #
    # @example
    #   opts =
    #     region: ...
    #     columns: ...
    #     collection: ...
    #     filterOpts:
    #       region:               new Backbone.Marionette.Region({el: "#filter-region"})
    #       filterValuesEndpoint: Routes.related_hosts_filter_values_workspace_vuln_path WORKSPACE_ID, VULN_ID
    #       helpEndpoint:         Routes.search_operators_workspace_vuln_path WORKSPACE_ID, VULN_ID
    #       keys:                 ['host.address', 'name']
    #   table = App.request "table:component", opts
    #
    App.reqres.setHandler 'table:component', (options={}) ->
      # Can't add default params to the carpenter init method pro concern because the carpenter init gets called first
      options.fetch = false if options.search

      # Default Pro Carpenter Options
      _.defaults options,
        perPageOptions:  [20, 50, 100, 500]

      new Marionette.Carpenter.Controller options