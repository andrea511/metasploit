define [], ->
  @Pro.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->

    Concerns.Chooseable =
      modelEvents:
        "change:chosen" : "changeChosen"

      changeChosen: (model, value, options) ->
        @$el.toggleClass "active", value

      onRender: ->
        @$el.addClass "active" if @model.isChosen()

      choose: (e) ->
        if $(e.target).data('selectable')!=false
          e.preventDefault()
          @model.choose()

      unchoose: (e) ->
        e.preventDefault()
        @model.unchoose()
