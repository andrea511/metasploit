define [
  'base_layout'
  'apps/loots/delete/templates/delete_layout'
], () ->
  @Pro.module 'LootsApp.Delete', (Delete, App) ->
    class Delete.Layout extends App.Views.Layout
      template: @::templatePath 'loots/delete/delete_layout'
