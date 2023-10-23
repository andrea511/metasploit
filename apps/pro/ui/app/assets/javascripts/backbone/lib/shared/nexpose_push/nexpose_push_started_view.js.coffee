define [
  'base_itemview'
  'lib/shared/nexpose_push/templates/push_started_modal'
], () ->
  @Pro.module 'Shared.NexposePush', (NexposePush, App) ->
    #
    # Expects a Backbone model with a redirectUrl attribute
    #
    class NexposePush.StartedView extends App.Views.ItemView
      template: @::templatePath('nexpose_push/push_started_modal')

      templateHelpers:
        linkToTask: ->
          @redirectUrl || "tasks"