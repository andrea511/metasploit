define [
  'base_layout'
  'apps/creds/delete/templates/delete_layout'
], () ->
  @Pro.module 'CredsApp.Delete', (Delete, App) ->
    class Delete.Layout extends App.Views.Layout
      template: @::templatePath 'creds/delete/delete_layout'
