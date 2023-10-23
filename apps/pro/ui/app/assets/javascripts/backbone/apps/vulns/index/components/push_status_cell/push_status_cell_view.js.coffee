define [
  'jquery'
  'base_itemview'
], ($) ->
  @Pro.module "Components.PushStatusCell", (PushStatusCell, App, Backbone, Marionette, $, _) ->

    #
    # PushStatusCell View
    #
    class PushStatusCell.View extends App.Views.Layout
      # Generate template with icon/hover text
      #
      # @param [Object] data The data from model
      # @option data :vuln.latest_nexpose_result.icon [String] The icon to be rendered
      # @option data :vuln.latest_nexpose_result.hover_text [String] The hover text
      template: (data)->
        return "<div></div>" unless data.origin_type
        icon = data['vuln.latest_nexpose_result.icon']
        hover_text = data['vuln.latest_nexpose_result.hover_text']
        """
        <img class='nx-push-icon' src="#{icon}" title='#{hover_text}' ></img>
        """

      onRender: ->
        @$el.tooltip()

