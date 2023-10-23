define [
  'base_layout'
  'apps/logins/delete/templates/delete_layout'
], () ->
  @Pro.module 'LoginsApp.Delete', (Delete, App) ->
    class Delete.Layout extends App.Views.Layout
      template: @::templatePath 'logins/delete/delete_layout'
