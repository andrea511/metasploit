define [
], ->
  class @RunStats extends Backbone.Model
    constructor: (workspaceId, taskId) ->
      @workspaceId = workspaceId
      @taskId = taskId

    url: ->
      "/workspaces/#{@workspaceId}/run_stats/#{@taskId}"

