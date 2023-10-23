@Pro.module "Regions", (Regions, App, Backbone, Marionette, $, _) ->

  class Regions.Dialog extends Marionette.Region
    onShow: (view) ->
      @setupBindings view

      options = @getDefaultOptions _.result(view, "dialog")

      @openDialog options

    openDialog: (options) ->
      @$el

    setupBindings: (view) ->
      @listenTo view, "dialog:close", @close


    getDefaultOptions: (options = {}) ->
      _.defaults options,
        title: "default title"

    onClose: ->
      @$el.off "closed"
      @stopListening()
