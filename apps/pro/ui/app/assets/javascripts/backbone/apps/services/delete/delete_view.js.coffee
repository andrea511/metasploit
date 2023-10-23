define [
  'base_layout'
  'apps/services/delete/templates/delete_layout'
], () ->
  @Pro.module 'ServicesApp.Delete', (Delete, App) ->
    class Delete.Layout extends App.Views.Layout
      template: @::templatePath 'services/delete/delete_layout'
