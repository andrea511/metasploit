define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    class Entities.Host extends App.Entities.Model

        url: ->
          "/hosts/#{@id}.json"

    class Entities.HostsCollection extends App.Entities.Collection
      #
      # @param [Object] opts the options hash
      # @option opts :workspace_id                 [String]
      # @option opts :limited                      [Boolean]
      #   whether to return all attributes or just id,name, address
      #
      initialize: (models, opts) ->
        {@workspace_id}  = opts

        @url = ->
          baseUrl = "/workspaces/#{@workspace_id}/hosts"
          if opts.limited
            "#{baseUrl}/json_limited"
          else
            "#{baseUrl}/json"

      model: Entities.Host

    #
    # API
    #

    API =
      # @return [Collection] of all Host objects in a given workspace
      getHosts: (model,opts) ->
        hosts = new Entities.HostsCollection(model,opts)
        hosts

      # @return [Collection] of all Host objects in a given workspace
      #                      with just id, name, address attributes
      getHostsLimited: (model,opts) ->
        opts.limited = true
        API.getHosts(model,opts)

    #
    # Returns Hosts Collection with all attributes
    # @see HostsController#index and HostIndexPresenter
    #
    App.reqres.setHandler "hosts:entities", (model,opts={}) ->
      throw new Error("missing workspace_id") unless opts.workspace_id?
      API.getHosts(model,opts)

    #
    # Returns Hosts Collection with just id, name, address
    # @see HostsController#hosts_collection_json
    #
    App.reqres.setHandler "hosts:entities:limited", (model,opts={}) ->
      throw new Error("missing workspace_id") unless opts.workspace_id?
      API.getHostsLimited(model,opts)