define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    class Entities.Note extends App.Entities.Model
      url: =>
        Routes.workspace_notes_path(@get('workspace_id'))


    class Entities.NoteCollection extends App.Entities.Collection
      url: =>
        Routes.workspace_notes_path WORKSPACE_ID

      model: Entities.Note

    #
    # API
    #

    API =
      getNotes: (opts = {}) ->
        new Entities.NoteCollection [], opts

      getNote: (id) ->
        new Entities.Note(id: id)


      newNote: (attributes = {}) ->
        new Entities.Note(attributes)

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "note:entity", (id) ->
      API.getNote id

    App.reqres.setHandler "notes:entities", (opts={}) ->
      API.getNotes(opts)

    App.reqres.setHandler "new:note:entity", (attributes) ->
      API.newNote attributes