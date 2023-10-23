define [
  'base_layout'
  'apps/notes/delete/templates/delete_layout'
], () ->
  @Pro.module 'NotesApp.Delete', (Delete, App) ->
    class Delete.Layout extends App.Views.Layout
      template: @::templatePath 'notes/delete/delete_layout'
