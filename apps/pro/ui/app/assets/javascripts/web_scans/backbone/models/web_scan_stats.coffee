# Created on the Rails side by WebScanPresenter#to_json
class @WebScanStats extends Backbone.Model
  defaults:
    web_pages:
      display: "Web pages"
      value: 0
    web_forms:
      display: "Web forms"
      value: 0
    web_vulns:
      display: "Web vulns"
      value: 0

  initialize: (options) ->
    @workspaceId = options.workspaceId
    @taskId      = options.taskId
    super

  objectsForDisplay: () ->
    [@get('web_pages'), @get('web_forms'), @get('web_vulns')]

  url: ->
    "/workspaces/#{@workspaceId}/web_scans/#{@taskId}.json"

