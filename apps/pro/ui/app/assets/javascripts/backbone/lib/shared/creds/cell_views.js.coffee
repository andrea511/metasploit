define [
  'jquery'
  'base_layout'
  'base_view'
  'base_itemview'
  'lib/components/table/table_view'
  'apps/creds/shared/cred_shared_views'
  'lib/shared/creds/templates/collection_hover'
], ($) ->

  ###
  #
  # Table Cell Views for use with Credentials
  #
  ###

  Pro.module "Creds.CellViews"

  #
  # Displays a single Public table cell
  #
  class Pro.Creds.CellViews.Public extends Pro.Views.ItemView

    initialize: ({ @attribute, @idAttribute, @workspaceIdAttribute }) ->
      @attribute ?= 'public'
      @idAttribute ?= 'core_id'
      @workspaceIdAttribute ?= 'workspace_id'

    template: (m) =>
      id = m[@idAttribute]
      user = _.escape(_.str.truncate(m[@attribute], 18))
      workspaceRoute = _.escape Routes.workspace_credentials_path(
        m[@workspaceIdAttribute]
      )
      "<a href='#{workspaceRoute}#creds/#{_.escape id}'>#{user}</a>"

  #
  # Displays the Address field for a Host with a link to the Host
  #
  class Pro.Creds.CellViews.HostAddress extends Pro.Views.ItemView

    initialize: ({ @attribute, @idAttribute }) ->
      @attribute ?= 'address'
      @idAttribute ?= 'host_id'

    template: (m) =>
      route = _.escape Routes.host_path(m[@idAttribute])
      "<a class='underline' href='#{route}'>#{_.escape m[@attribute]}</a>"

  #
  # Displays a link to the Session page for a specific session
  #
  class Pro.Creds.CellViews.Session extends Pro.Views.ItemView

    initialize: ({ @attribute, @workspaceAttribute }) ->
      @attribute ?= 'session_id'
      @workspaceAttribute ?= 'workspace_id'

    template: (m) =>
      if m[@attribute] && m[@workspaceAttribute]
        route = Routes.session_path(m[@attribute], m[@workspaceAttribute])
        "<a href='#{_.escape route}'>Session #{_.escape m.session_id}</a>"
      else
        ""

  #
  # Displays a count of :attribute next to the English word :subject
  #
  class Pro.Creds.CellViews.Count extends Pro.Views.ItemView

    initialize: ({ @attribute, @subject, @pluralSubject, @link }) ->
      throw new Error("missing :attribute option") unless @attribute?
      throw new Error("missing :subject option") unless @subject?
      @link ?= true
      @pluralSubject ?= @subject + 's'

    template: (m) =>
      count = parseInt(m[@attribute], 10)
      subject = if count == 1 then @subject else @pluralSubject
      phrase = "#{_.escape m[@attribute]} #{subject}"
      if count > 0 and @link is true
        "<a href='javascript:void(0)'>#{phrase}</a>"
      else if @link and typeof @link isnt 'boolean'
        "<a href='#{@link(m)}'>#{phrase}</a>"
      else
        phrase

  #
  # Displays a private credential. For plaintext passwords, this is just a
  # truncated text cell. For SSH keys and hashes, this is a link that can
  # be clicked to bring up a modal where the cred can be copied.
  #
  class Pro.Creds.CellViews.Private extends Pro.Views.ItemView

    events:
      'click a': 'passClicked'

    initialize: ({ @attribute, @typeAttribute }) ->
      @attribute ?= 'private'
      @typeAttribute ?= 'private_type'

    template: (m) =>
      ptype = m[@typeAttribute]?.split('::')[2]
      if ptype is 'Password'
        _.escape(_.str.truncate(m[@attribute], 24))
      else
        "<a href='javascript:void(0)'>#{_.escape ptype}</a>"

    passClicked: =>
      dialogView = new Pro.CredsApp.Shared.CoresTablePrivateCellDisclosureDialog(
        model: new Backbone.Model(
          'private.data': @model.get(@attribute)
        )
      )
      Pro.execute 'showModal', dialogView,
        modal:
          title: 'Private Data'
          description: ''
          width: 600
          height: 400
        buttons: [
          { name: 'Close', class: 'close'}
        ]

  #
  # The CollectionHover view renders a list of related items when you
  # mouseover a table cell.
  #
  # @example
  #   new Pro.Creds.CellViews.CollectionHover
  #     url: '/tasks/1/stats/my_domino_stats.json'
  #     columns: [
  #       { label: 'public', attribute: 'public', size: 4 }
  #       { label: 'private', attribute: 'private', size: 6 }
  #       { label: 'id', attribute: 'id', size: 2 }
  #     ]
  #
  class Pro.Creds.CellViews.CollectionHover extends Pro.Views.CompositeView

    className: 'hover-square'

    # not sure why our @::template() helper is not helpful here
    template: JST['backbone/lib/shared/creds/templates/collection_hover']

    # @param [Object] opts the options hash
    # @option opts :url     [String, Function] the URL route to hit for data
    # @option opts :title   [String, Function] the title to display above the table
    # @option opts :columns [Array<Object>] a list of column schemas for rendering
    #   the embedded table
    initialize: (opts={}) ->
      @url ?= opts.url
      @columns ?= opts.columns
      @title ?= opts.title

    onShow: ->
      @timeout = setTimeout(@sync, 300)

    onDestroy: ->
      clearTimeout(@timeout)

    sync: =>
      $.getJSON(_.result(@, 'url')).done (data) =>
        @data = data
        @render() if @el?.parentNode?

    serializeData: =>
      _.reduce(['data', 'columns', 'title'], (memo={}, propName) =>
        memo[propName] = _.result(@, propName)
        memo
      , {})

  #
  # Displays the "key" of a Realm (usually paired with the `RealmHover` class)
  #
  class Pro.Creds.CellViews.Realm extends Pro.Views.ItemView

    initialize: ({@attribute}) ->
      @attribute ?= 'realm_key'

    template: (m) =>
      key = (m[@attribute] || '').replace(/\sDomain$/, '')
      "<a href='javascript:void(0)'>#{_.escape key}</a>"

  #
  # Displays the "value" of a Realm on hover
  #
  class Pro.Creds.CellViews.RealmHover extends Pro.Views.ItemView

    className: 'hover-square realm'

    initialize: ({@attribute}) ->
      @attribute ?= 'realm'

    template: (m) ->
      "<div>Realm Name</div><div>#{_.escape m.realm}</div>"
