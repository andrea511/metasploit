define [
  'base_controller'
  'apps/vulns/index/index_views'
  'apps/web_vulns/index/index_views'
  'lib/components/table/table_controller'
  'lib/shared/cve_cell/cve_cell_controller'
  'lib/shared/nexpose_push/nexpose_push_views'
  'lib/components/analysis_tab/analysis_tab_view'
  'lib/shared/nexpose_push/nexpose_push_controllers'
  'lib/components/pro_search_filter/filter_controller'
], ->
  @Pro.module "Components.AnalysisTab", (AnalysisTab, App, Backbone, Marionette, $, _) ->
    class AnalysisTab.Controller extends App.Controllers.Application

      # Create a new instance of the AnalysisTabController and add it to the region if show is true
      #
      # @param opts [Object] the options hash
      # @options options show        [Boolean] show view on initialization
      #
      initialize: (options) ->
        @layout = @getLayoutView()
        @setMainView @layout

        @listenTo @_mainView, 'show', =>
          @table = @_renderTable options
          if options.enableNexposePushButton
            # Listen to row selection events and fire
            # Listen to vulns collection events because action buttons currently don't use Radio
            # https://github.com/rapid7/marionette.carpenter/blob/bc13b4e9874ce4ada6dee060f1f4adbd5660ae2c/src/views/action_button.coffee#L33-L36
            @table.collection.on 'select_all_toggled', => @_triggerRowsSelected( @pushButtonRegion() )
            @table.carpenterRadio.on 'table:row:selected', => @_triggerRowsSelected( @pushButtonRegion() )
            @table.carpenterRadio.on 'table:row:deselected', => @_triggerRowsSelected( @pushButtonRegion() )

          # This is a hack to initialize the first PushButtonView on table render
          @table.collection.on 'reset', =>
            @table.collection.trigger 'select_all_toggled'

        return @layout

      onDestroy: () ->
        @table.carpenterRadio.off 'table:rows:selected'
        @table.carpenterRadio.off 'table:rows:deselected'
        @table.carpenterRadio.off 'table:row:selected'
        @table.carpenterRadio.off 'table:row:deselected'
        @table.collection.off 'reset'

      #
      # REGION INITIALIZERS
      #
      pushButtonRegion: ->
        pushButtonView = @getPushButtonView()
        @layout.pushButtonRegion.show pushButtonView
        pushButtonView

      #
      # VIEW ACCESSORS
      #
      getLayoutView: ->
        new AnalysisTab.Layout

      getPushButtonView: ->
        @layout._currentPushButtonView = new Pro.Shared.NexposePush.ButtonView

      #
      # Render the index table.
      #
      # @param collection [Entities.Collection] the records to be displayed
      # @param options [Object] the options to be used for creating the carpenter table
      _renderTable: (options) ->

        tableController = App.request "table:component"
          region: @layout.analysisTabsRegion
          buttonsRegion: @layout.buttonsRegion
          selectable: true
          taggable: true
          static: false
          perPage: 20
          columns: options.columns
          defaultSort: options.defaultSort || null
          actionButtons: options.actionButtons
          collection: options.collection
          filterOpts: options.filterOpts
          emptyView: options.emptyView || AnalysisTab.TableEmptyView

      #
      # Trigger a 'rows selected' method for the Nexpose Push button.
      #
      # @param pushButtonView [App.ItemView] the view for the Nexpose Push button
      _triggerRowsSelected: (pushButtonView) ->
        pushButtonView.triggerMethod 'rowsSelected', @table.tableSelections

      #
      # Post the table's currently selected records to the path, along with the current table
      # selection state.
      #
      # @param path [String] the path to which the table state data should be posted
      # @param tableState [Object] an object representing the current selection state of the table
      postSelections: (path, tableState) ->
        CSRF_TOKEN = $('meta[name=csrf-token]').attr('content')

        # adapted from http://stackoverflow.com/questions/133925/javascript-post-request-like-a-form-submit
        form = $('<form></form>')

        form.attr("method", "post")
        form.attr("action", path)

        # Convert the camelcased table state keys to their underscored counterparts, and add
        # the CSRF token
        finalParams = {
          class:                            'vuln'
          'selections[deselected_ids]':     tableState.deselectedIDs
          'selections[selected_ids]':       tableState.selectedIDs
          'selections[select_all_state]':   tableState.selectAllState
          authenticity_token:               CSRF_TOKEN
        }

        for key, value of finalParams
          field = $('<input></input>')

          field.attr "type", "hidden"
          field.attr "name", key
          field.attr "value", value

          form.append field

        $(document.body).append form
        form.submit()

    # Register an Application-wide handler for rendering an analysis tab
    App.reqres.setHandler 'analysis_tab:component', (options={}) ->
      new AnalysisTab.Controller options

    # Post the table's currently selected records to the path, along with the current table
    # selection state.
    #
    # @param klass [String] the lowercase version of the Ruby class name of objects
    #   being displayed, sans the namespace
    # @param path [String] the path to which the table state data should be posted
    # @param tableState [Object] an object representing the current selection state of the table
    App.commands.setHandler 'analysis_tab:post', (klass, path, tableState) ->
      CSRF_TOKEN = $('meta[name=csrf-token]').attr('content')

      # adapted from http://stackoverflow.com/questions/133925/javascript-post-request-like-a-form-submit
      form = $('<form></form>')

      form.attr("method", "post")
      form.attr("action", path)

      # Convert the camelcased table state keys to their underscored counterparts, and add
      # the CSRF token
      finalParams = {
        class:                            klass
        'selections[deselected_ids]':     tableState.deselectedIDs
        'selections[selected_ids]':       tableState.selectedIDs
        'selections[select_all_state]':   tableState.selectAllState
        authenticity_token:               CSRF_TOKEN
        ignore_pagination:                true
      }

      for key, value of finalParams
        field = $('<input></input>')

        field.attr "type", "hidden"
        field.attr "name", key
        field.attr "value", value

        form.append field

      $(document.body).append form
      form.submit()
