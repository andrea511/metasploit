define [
  'base_controller'
  'entities/module_detail'
  'entities/related_modules'
  'lib/components/modal/modal_controller'
  'lib/shared/cve_cell/cve_cell_views'
  'css!css/shared/cve_cell'
], () ->
  @Pro.module "Shared.CveCell", (CveCell, App) ->

    #
    # Contains the CveCell
    #
    class CveCell.Controller extends App.Controllers.Application

      # Hash of default options for controller
      defaults: ->
        {}

      # Create a new instance of the CveCell Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      initialize: (options = {}) ->
        config = _.defaults options, @_getDefaults()
        @model = new Backbone.Model(config).get('model')

        view = new CveCell.View(model: @model)

        @setMainView(view)

        @listenTo @_mainView, 'refs:clicked', =>
          if @model.constructor == App.Entities.Vuln
            refModel = @model
          else if @model.constructor == App.Entities.RelatedModules
            refModel = App.request 'module:detail:entity', {id:@model.id,refsOnly:true}
          else if @model.constructor == App.Entities.WorkspaceRelatedModules
            refModel = App.request 'module:detail:entity', {id:@model.id,refsOnly:true}
          else
            throw "Model for CveCell.Controller must be a Vuln or RelatedModules"

          dialogView = new CveCell.ModalView(model: refModel)

          # pass refsOnly as additional param on fetch
          # the processData flag allows us to do this
          # see http://stackoverflow.com/questions/6659283/backbone-js-fetch-with-parameters
          refModel.fetch(data: {refsOnly: true}, processData: true)

          App.execute 'showModal', dialogView,
            modal:
              title: 'References'
              description: ''
              width: 260
              height: 300
            buttons: [
              { name: 'Close', class: 'close'}
            ]
            loading:true


    # Register an Application-wide handler for a tooltip controller
    App.reqres.setHandler 'cveCell:component', (options={})->
      new CveCell.Controller options