define [
  'base_layout'
  'apps/hosts/delete/templates/delete_layout'
], () ->
  @Pro.module 'HostsApp.Delete', (Delete, App) ->
    class Delete.Layout extends App.Views.Layout
      template: @::templatePath 'hosts/delete/delete_layout'
