define [
  'jquery'
  'base_model'
  'base_collection'
], ($) ->

  @Pro.module 'Entities', (Entities, App) ->

    #
    # A group of user-selected Credentials. Has its own name, owner, and list of
    # Credential Core IDs.
    #
    class Entities.CredGroup extends App.Entities.Model

      @STATES: ['new', 'loading', 'loaded']

      defaults:
        name: ''
        id: null
        creds: null
        cred_ids: null
        workspace_id: null
        working: false
        expanded: false
        state: 'new'

      initialize: (opts={}) =>
        @set('creds', new App.Entities.CredsCollection([]))

      loadCredIDs: =>
        @set(state: 'loading')
        $.getJSON(@coresURL())
          .done (ids) =>
            @set(state: 'loaded', cred_ids: ids)
            @trigger('creds:loaded', ids: ids)
          .error =>
            _.delay(@loadCredIDs, 3000)

      url: =>
        "#{@groupURL()}.json"

      coresURL: =>
        "/workspaces/#{@get('workspace_id')}/metasploit/credential/cores.json?ids_only=1&group_id=#{@id}"

      groupURL: =>
        "/workspaces/#{@get('workspace_id')}/brute_force/reuse/groups/#{@id}"

    #
    # A collection of CredGroups, for rendering in the "Selected Credentials"
    # portion of the Credential Reuse UI.
    #
    class Entities.CredGroupsCollection extends App.Entities.Collection

      model: Entities.CredGroup

      # @property workspace_id [Number] the id of the workspace to look for groups in
      workspace_id: null

      # @param opts [Object] the options hash
      # @option opts workspace_id [Number] the id of the host to look up accessing creds on
      initialize: (models, opts={}) ->
        @workspace_id = opts.workspace_id

      # Enforces uniqueness when adding a CredGroup to this collection
      add: (model, opts={}) ->
        super unless @hasId(model.id)

      # @parma id [Number] the id to look for
      # @return [Boolean] the collection contains a Group whose id matches +id+
      hasId: (id) ->
        id = Math.floor(id)
        _.any(@models, (m) -> id is m.id)

      url: =>
        "/workspaces/#{@workspace_id}/brute_force/reuse/groups.json"
