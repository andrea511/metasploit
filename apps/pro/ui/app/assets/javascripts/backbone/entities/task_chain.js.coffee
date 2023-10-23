define [
  'jquery'
  'base_model'
  'base_collection'
], ($) ->
  @Pro.module "Entities", (Entities, App, Backbone, Marionette, jQuery, _) ->

    #
    # ENTITY CLASSES
    #

    class Entities.TaskChain extends App.Entities.Model
      urlRoot: gon.workspace_task_chains_path

    class Entities.TaskChainCollection extends App.Entities.Collection
      model: Entities.TaskChain
      url: gon.workspace_task_chains_path

      sortAttribute: "name",
      sortDirection: 1,

      sortRows: (attr) ->
        @sortAttribute = attr
        @sort()

      comparator: (a, b) ->
        a = a.get(@sortAttribute)
        b = b.get(@sortAttribute)

        return 0 if (a == b)

        if (@sortDirection == 1)
          return a > b ? 1 : -1
        else
          return a < b ? 1 : -1

      # @return [Array<Entities.TaskChain>] the currently selected task chains
      selected: ->
        @where selected: true

      # Destroy the currently selected task chains.
      destroySelected: ->
        selectedTaskChainIDs = @selected().pluck 'id'

        _.each @selected(), (taskChain) =>
          @remove(taskChain)

        $.ajax
          url: gon.destroy_multiple_workspace_task_chains_path
          type: 'DELETE'
          data:
            task_chain_ids: selectedTaskChainIDs

      # Stop the currently selected task chains.
      stopSelected: ->
        selectedTaskChainIDs = @selected().pluck 'id'

        $.ajax
          url: gon.stop_multiple_workspace_task_chains_path
          type: 'POST'
          data:
            task_chain_ids: selectedTaskChainIDs
          success: (data) =>
            @reset data

      # Suspend the currently selected task chains.
      suspendSelected: ->
        selectedTaskChainIDs = @selected().pluck 'id'

        $.ajax
          url: gon.suspend_multiple_workspace_task_chains_path
          type: 'POST'
          data:
            task_chain_ids: selectedTaskChainIDs
          success: (data) =>
            @reset data

      # Suspend the currently selected task chains.
      resumeSelected: ->
        selectedTaskChainIDs = @selected().pluck 'id'

        $.ajax
          url: gon.resume_multiple_workspace_task_chains_path
          type: 'POST'
          data:
            task_chain_ids: selectedTaskChainIDs
          success: (data) =>
            @reset data

      # Suspend the currently selected task chains.
      runSelected: ->
        selectedTaskChainIDs = @selected().pluck 'id'

        $.ajax
          url: gon.start_multiple_workspace_task_chains_path
          type: 'POST'
          data:
            task_chain_ids: selectedTaskChainIDs
          success: (data) =>
            @reset data

    #
    # API
    #

    API =
      getTaskChains: ->
        task_chains = new Entities.TaskChainsCollection
        task_chains.fetch
          reset: true
        task_chains

      getTaskChain: (id) ->
        task_chains = new Entities.TaskChain
          id: id
        task_chains.fetch()
        task_chains

      newTaskChain: (attributes = {}) ->
        new Entities.TaskChain(attributes)

      newTaskChainCollection: (taskChains = []) ->
        taskChainsArray = []
        _.each taskChains, (taskChainAttributes) ->
          taskChainsArray.push API.newTaskChain(taskChainAttributes)

        new Entities.TaskChainCollection(taskChainsArray)

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "task_chains:entities", ->
      API.getTaskChains

    App.reqres.setHandler "task_chains:entity", (id) ->
      API.getTaskChain id

    App.reqres.setHandler "new:task_chains:entity", (attributes) ->
      API.newTaskChain attributes

    App.reqres.setHandler "new:task_chains:collection", (taskChainArray) ->
      API.newTaskChainCollection taskChainArray