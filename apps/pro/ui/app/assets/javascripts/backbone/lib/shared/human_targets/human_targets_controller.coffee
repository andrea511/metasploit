define [
  'base_controller'
  'lib/shared/human_targets/human_targets_views'
  'entities/social_engineering/human_target'
  'lib/components/table/table_controller'
  'lib/components/flash/flash_controller'
], ->
  @Pro.module "Shared.HumanTargets", (HumanTargets, App, Backbone, Marionette, $) ->
    class HumanTargets.Controller extends App.Controllers.Application
      # Create a new instance of the HumanTargetsController and adds it to the region if show is true
      # @param opts [Object] the options hash
      # @options options show        [Boolean] show view on initialization
      #
      initialize: (options) ->
        _.defaults options,
          show: true

        { show, targetListId } = options

        @layout = new HumanTargets.Layout
        @setMainView(@layout)
        humanTargets = App.request 'socialEngineering:humanTarget:entities', targetListId: targetListId

        @listenTo @_mainView, 'show', =>
          @table = @renderTargetsTable humanTargets, @layout.targetsRegion,
            htmlID: 'target-list'

        @loadingModal = $('<div class="loading"></div>').dialog(
          modal: true,
          title: 'Submitting...',
          autoOpen: false,
          closeOnEscape: false
        )

        @show @layout, region: @region, loading: { loadingType: 'overlay' } if show



      renderTargetsTable: (humanTargets, region) ->
        columns = [
          {
            label: 'Email Address'
            attribute: 'email_address'
            sortable: true
            defaultDirection: 'asc'
          },
          {
            label: 'First Name'
            attribute: 'first_name'
            sortable: true
          },
          {
            label: 'Last Name'
            attribute: 'last_name'
            sortable: true
          }
        ]

        tableController = App.request "table:component",
          htmlID: 'human-targets'
          region:     region
          taggable:   true
          selectable: true
          static:     false
          collection: humanTargets
          perPage: 20
          columns: columns
          actionButtons: [{
            label: 'Remove'
            activateOn: 'any'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) =>
              @loadingModal.dialog('open')
              tableController.postTableState(method:'DELETE').complete (r) =>
                @loadingModal.dialog('close')
                if r.responseJSON.success
                  tableCollection.removeMultiple selectedVisibleCollection
                  App.execute 'flash:display',
                    title:    'Targets removed'
                    message:  'The targets have been successfully removed.'
                else
                  App.execute 'flash:display',
                    title:    'An error occurred'
                    style:   'error'
                    message:  'There was an error while removing targets from this list.'
          }]
