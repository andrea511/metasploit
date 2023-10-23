define [
  'jquery'
  'base_layout'
  'base_compositeview'
  'base_itemview'
  'lib/shared/target_list/templates/layout'
], ($) ->
  @Pro.module "Shared.TargetList", (TargetList, App, Backbone, Marionette, $, _) ->

    #
    # Targets List Layout
    #
    class TargetList.Layout extends App.Views.Layout
      template: @::templatePath "target_list/layout"

      ui:
        clear: 'a.clear'
        badge: 'span.badge'

      regions:
        targetListRegion: '.target-list'

      triggers:
        'click a.clear': 'removeTargets'

      # Hides or shows the "clear" button depending on the state of the working group
      updateClearState: (collection) =>
        _.defer =>
          @ui.clear?.toggle(@_numSelectedCreds(collection) > 0)

      # Updates the selected badge based on the working group
      updateSelectionCount: (collection) =>
        _.defer =>
          @ui.badge?.toggle(@_numSelectedCreds(collection) > 0).text(@_numSelectedCreds(collection))

      # Looks at the working group to get the count of models
      # @return [Number] number of selected creds
      _numSelectedCreds: (collection) =>
        collection.ids?.length || 0
