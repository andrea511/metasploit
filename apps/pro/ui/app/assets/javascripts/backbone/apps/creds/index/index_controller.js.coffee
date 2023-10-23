define [
  'base_controller'
  'apps/creds/index/index_view'
  'entities/cred'
  'lib/concerns/controllers/render_cores_table'
  'lib/components/filter/filter_controller'
], ->
  @Pro.module "CredsApp.Index", (Index, App) ->
    class Index.Controller extends App.Controllers.Application

      #Mixin for the table of cores
      @include 'RenderCoresTable'

      # Create a new instance of the IndexController and adds it to the region if show is true
      # @param opts [Object] the options hash
      # @options options show        [Boolean] show view on initialization
      # @options options filterAttrs [Object] the initial state to set the filter to
      #
      initialize: (options) ->
        _.defaults options,
          show: true

        { show, filterAttrs, search } = options

        @layout = new Index.Layout
        @setMainView(@layout)
        creds = App.request 'creds:entities', window?.gon?.related_logins

        @listenTo @_mainView, 'show', =>
          @table = @renderCoresTable creds, @layout.credsRegion,
            search: search
            htmlID: 'manage-creds'
            filterOpts:
              filterValuesEndpoint: window.gon.filter_values_workspace_metasploit_credential_cores_path
              keys: ['logins.status'
                     'private.data'
                     'private.type'
                     'public.username'
                     'realm.key'
                     'realm.value'
                     'tags.name']

              staticFacets:
                'private.type': [
                  {
                    value: 'SSH key'
                    label: 'SSH Key'
                  }
                  {
                    value: 'NTLM hash'
                    label: 'NTLM Hash'
                  }
                  {
                    value: 'Nonreplayable hash',
                    label: 'Nonreplayable Hash'
                  }
                  {
                    value: 'Password'
                    label: 'Password'
                  }
                ]
                'realm.key'    : Pro.Entities.Cred.Realms.ALL.map (name)-> { value: name, label: name }
                'logins.status': Pro.Entities.Login.Status.ALL.map (name)-> { value: name, label: name }
              filterRegion: @layout.filterRegion
          @_mainView.setCarpenterChannel(@table.channel())

        @show @layout, region: @region, loading: { loadingType: 'overlay' } if show
