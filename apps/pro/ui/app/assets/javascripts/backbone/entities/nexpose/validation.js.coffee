define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities.Nexpose", (Nexpose, App) ->

    #
    # ENTITY CLASSES
    #

    class Nexpose.Validation extends App.Entities.Model

      urlRoot: =>
        Routes.workspace_nexpose_result_validations_path(@get('workspace_id'))

    #
    # API
    #

    API =
      getValidation: (id) ->
        new Nexpose.Validation(id: id)


      newValidation: (attributes = {}) ->
        new Nexpose.Validation(attributes)

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "nexpose:validation:entity", (id) ->
      API.getValidation id

    App.reqres.setHandler "new:nexpose:validation:entity", (attributes) ->
      API.newValidation attributes