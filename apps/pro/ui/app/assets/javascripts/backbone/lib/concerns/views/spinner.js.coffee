define [], ->
  @Pro.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->

    Concerns.Spinner =
      #
      # Hide any elements in this view with class `spinner-content` and show any elements
      # with class `spinner`.
      #
      # @return [void]
      showSpinner: ->
        @$el.find('.spinner-content').hide()
        @$el.find('.spinner').show()

      #
      # Hide any elements in this view with class `spinner` and show any elements
      # with class `spinner-content`.
      #
      # @return [void]
      hideSpinner: ->
        @$el.find('.spinner-content').show()
        @$el.find('.spinner').hide()
