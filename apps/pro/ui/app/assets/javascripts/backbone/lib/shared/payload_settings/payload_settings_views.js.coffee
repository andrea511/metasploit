define [
  'jquery'
  'base_layout'
  'base_compositeview'
  'base_itemview'
  'lib/shared/payload_settings/templates/view'
], ($) ->
  @Pro.module "Shared.PayloadSettings", (PayloadSettings, App, Backbone, Marionette, $, _) ->

    #
    # Targets List Layout
    #
    class PayloadSettings.View extends App.Views.ItemView
      template: @::templatePath "payload_settings/view"

      className: 'payload-settings'

      updateErrors: (response) ->
        $('.error',@el).remove()
        _.each response.errors, (v, k) =>
          $msg = $('<div />', class: 'error').text(v)
          $("[name='payload_settings[#{k}]']", @el).addClass('invalid').after($msg)