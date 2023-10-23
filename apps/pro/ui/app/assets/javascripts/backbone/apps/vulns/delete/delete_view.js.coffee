define [
  'base_layout'
  'apps/vulns/delete/templates/delete_layout'
], () ->
  @Pro.module 'VulnsApp.Delete', (Delete, App) ->
    class Delete.Layout extends App.Views.Layout
      template: @::templatePath 'vulns/delete/delete_layout'
