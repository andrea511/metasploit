define [
  'base_controller'
  'apps/creds/clone/clone_view'
], ->
  @Pro.module "CredsApp.Clone", (Clone, App) ->
    class Clone.Controller extends App.Controllers.Application

      # @param opts [Hash] the options hash
      # @option opts :cred [Entities.Cred] the new cred being edited
      # @option opts :credsCollection [Entities.CredsCollection] the collection of creds
      #   currently displayed in the table
      # @option opts :regionName [String] the name of the region in which to display
      #   the clone form (set dynamically, since it can appear next to any row
      #   in the creds table)
      initialize: (opts) ->
        { cred, credsCollection, regionName } = opts

        @layout = @getLayoutView cred, credsCollection

        @listenTo @layout, 'show', =>
          @layout.dropContainingEl()
          @publicRegion  cred
          @privateRegion cred
          @realmRegion   cred
          @typeRegion    cred

        @show @layout, region: App[regionName]

      #
      # REGION INITIALIZERS
      #

      #
      # Display the public view.
      #
      # @param cred [Entities.Cred] the new cred being edited
      #
      # @return [Clone.Public] the view for the cred public form
      publicRegion: (cred) ->
        publicView = @getPublicView cred
        @layout.publicRegion.show publicView

      #
      # Display the private view.
      #
      # @param cred [Entities.Cred] the new cred being edited
      #
      # @return [Clone.Private] the view for the cred private form
      privateRegion: (cred) ->
        privateView = @getPrivateView cred
        @layout.privateRegion.show privateView

      #
      # Display the realm view.
      #
      # @param cred [Entities.Cred] the new cred being edited
      #
      # @return [Clone.Public] the view for the cred realm form
      realmRegion: (cred) ->
        realmView = @getRealmView cred
        @layout.realmRegion.show realmView

      #
      # Display the type view.
      #
      # @param cred [Entities.Cred] the new cred being edited
      #
      # @return [Clone.Public] the view for the cred type form
      typeRegion: (cred) ->
        typeView = @getTypeView cred
        @layout.typeRegion.show typeView

      #
      # VIEW ACCESSORS
      #
      getLayoutView: (cred, credsCollection) ->
        new Clone.Layout
          model: cred
          credsCollection: credsCollection

      getPublicView: (cred) ->
        new Clone.Public
          model: cred

      getPrivateView: (cred) ->
        new Clone.Private
          model: cred

      getRealmView: (cred) ->
        new Clone.Realm
          model: cred

      getTypeView: (cred) ->
        new Clone.Type
          model: cred