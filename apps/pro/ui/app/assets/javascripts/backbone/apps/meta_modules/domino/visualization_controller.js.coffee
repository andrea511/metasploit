define [
  'jquery'
  'apps/meta_modules/domino/visualization_views'
  'base_controller'
], ($) ->

  @Pro.module 'MetaModulesApp.Domino', (Domino, App) ->

    class Domino.Controller extends App.Controllers.Application

      # @property [@Pro.MetaModulesApp.Domino.Views.Layout] layout
      layout: null

      # @property [@Pro.Entities.Task] the running Task
      task: null

      # Create a new instance of the VisualizationController
      # @param [Object] opts the options hash
      # @option opts :task [Task] a model of the Task
      initialize: (opts={}) ->
        # merge in any specified overrides
        @task = opts.task

        # Crappy little mixin pattern
        # Must be attached to Task because it has to keep running even
        # when the user is in a different findings tab and this Controller
        # has been destroyed
        @task.updateGraph ?= (->
          @get('allNodes') || @set(allNodes: [])
          @get('allEdges') || @set(allEdges: [])
          unless @get('nodes').consumed
            @get('nodes').consumed = true
            @set allNodes: @get('allNodes').concat(@get('nodes')||[])
          unless @get('edges').consumed
            @get('edges').consumed = true
            @set allEdges: @get('allEdges').concat(@get('edges')||[])
        ).bind(@task)
        @task.updateGraph()

        # It's a self-referential binding so we don't worry about cleanup, just duplication
        @task.off('change:nodes change:edges', @task.updateGraph)
        @task.on('change:nodes change:edges', @task.updateGraph)

        @layout = new Domino.Views.Layout(@)
        @setMainView(@layout)

        @d3View = new Domino.Views.D3(task: @task)
        @nodeInfoView = new Domino.Views.NodeInfo()
        @listenTo @layout, 'show', =>
          @show @d3View, region: @layout.d3
          @show @nodeInfoView, region: @layout.nodeInfo

        @listenTo @layout, 'orientation:changed', =>
          orientation = @layout.selectedOrientation()
          if orientation is Domino.Views.D3.LAYOUTS.RADIAL_TREE
            @d3View.layout = Domino.Views.D3.LAYOUTS.RADIAL_TREE
            @d3View.orientation = Domino.Views.D3.ORIENTATIONS.VERTICAL
          else
            @d3View.layout = Domino.Views.D3.LAYOUTS.TREE
            @d3View.orientation = orientation
          @d3View.updateD3()

        @listenTo @layout, 'layout:changed', =>
          @d3View.layout = @layout.selectedLayout()
          @d3View.updateD3()

        @listenTo @layout, 'sizetofit:resized', =>
          @d3View.updateD3()

        @listenTo @layout, 'fullscreen:changed', =>
          @d3View.toggleFullscreen(@layout.selectedFullscreen())

        @listenTo @d3View, 'node:mouseover', (nodeData) =>
          @nodeInfoView.$el.show()
          @nodeInfoView.setNodeData(nodeData)

          url = Routes.task_detail_path(
            WORKSPACE_ID,
            @task.id
          ) + "/stats/node.json?node_id=#{nodeData.data.id}"

          $.getJSON(url).done (data) =>
            nodeData.data.captured_creds_count = parseInt(data[0].captured_creds_count)
            nodeData.data.address = data[0].address
            if @nodeInfoView._isShown
              @nodeInfoView.setNodeData(nodeData)

        @listenTo @d3View, 'node:mouseout', (nodeData) =>
          @nodeInfoView.$el.hide()

        @listenTo @task, 'change:nodes change:edges', _.debounce((=>
          return if @task.get('nodes').graphConsumed
          return if @task.get('nodes').length < 1 and @task.get('edges').length < 1
          @task.get('nodes').graphConsumed = true
          @d3View.updateGraph(@task.get('nodes'), @task.get('edges'))
        ), 100)

        @show @getMainView(), region: opts.region

      tabClicked: (idx) =>
        if idx == 0
          @d3View.updateD3()
