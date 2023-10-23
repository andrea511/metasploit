define [
  'jquery'
  'config/sync'
], ($) ->

  @Pro.module "Utilities", (Utilities, App) ->

    App.commands.setHandler "when:fetched", (entities, callback) ->
      xhrs = _.chain([entities]).flatten().pluck("_fetch").value()

      $.when(xhrs...).done ->
        callback()
  , $