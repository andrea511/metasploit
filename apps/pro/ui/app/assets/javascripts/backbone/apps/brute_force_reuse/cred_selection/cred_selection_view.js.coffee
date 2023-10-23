define [
  'jquery'
  'base_layout'
  'base_view'
  'base_itemview'
  'base_compositeview'
  'entities/cred'
  'entities/cred_group'
  'select2'
  'apps/brute_force_reuse/cred_selection/templates/cred_selection_layout'
  'apps/brute_force_reuse/cred_selection/templates/group'
  'apps/brute_force_reuse/cred_selection/templates/cred_row'
  'apps/brute_force_reuse/cred_selection/templates/group_container'
  'lib/components/lazy_list/lazy_list_controller'
  'lib/concerns/views/right_side_scroll'
], ($) ->

  # Sigh. The verbage in here is all jumbled. Sorry. - joev

  @Pro.module 'BruteForceReuseApp.CredSelection', (CredSelection, App) ->

    #
    # The Layout houses all the various composite views and sub layouts.
    #
    class CredSelection.Layout extends App.Views.Layout

      id: 'credSelection'

      template: @::templatePath('brute_force_reuse/cred_selection/cred_selection_layout')

      regions:
        credsRegion: '.creds-table'
        groupsRegion: '.creds-groups'

      ui:
        rightSide: '.right-side'
        leftSide: '.left-side'
        next: 'a.btn.primary'

      attributes:
        class: 'cred-selection-view'

      triggers:
        'click .add-selection': 'creds:addToCart'

      @include "RightSideScroll"

      toggleNext: (enabled) =>
        @ui.next.toggleClass('disabled', !enabled)

    #
    # Renders a single Cred (public/private/realm)
    #
    class CredSelection.CredRow extends App.Views.ItemView

      tagName: 'li'

      attributes:
        class: 'cred-row'

      template: @::templatePath('brute_force_reuse/cred_selection/cred_row')

      events:
        'click a.delete': 'removeCred'

      # @param opts [Object] the options hash
      # @option opts collection [Backbone.Collection] the collection containing the Cred
      # @option opts model [Backbone.Model] the Cred
      initialize: ({@collection, @model}) =>

      removeCred: =>
        @collection.remove(@model)

    #
    # Contains one Group model instance, which has a "creds" attribute that holds a CredsCollection.
    # When user expands, a request is made to the server to get ALL ids of all creds in the group.
    # If this Group is the "working" group, then no expansion is necessary and the creds are shown.
    # These ids are then passed to a LazyList component, which allows paginated loading.
    #
    class CredSelection.Group extends App.Views.Layout

      tagName: 'li'

      template: @::templatePath('brute_force_reuse/cred_selection/group')

      attributes:
        class: 'group'

      events:
        'click': 'toggleExpansion'
        'click a.delete': 'removeGroup'

      regions:
        list: '.cred-rows'

      childView: CredSelection.CredRow

      # @property parentCollection [Backbone.Collection] the collection that owns this CredGroup
      parentCollection: null

      # @property collection [Backbone.Collection] the collection of CredRows to render
      collection: null

      # @property lazyList [Components.LazyList.Controller] the LazyList component
      lazyList: null

      # @param opts [Object] the options hash
      # @option opts collection [Backbone.Collection] the collection containing the CredGroup
      # @option opts model [Backbone.Model] the CredGroup
      initialize: ({collection, @model}) =>
        @parentCollection = collection
        @collection = @model.get('creds')
        @listenTo @model, 'creds:loaded', @credsLoaded

      toggleExpansion: =>
        return if @model.get('working') # the working set cannot be expanded/minimized

        @model.set(expanded: !@model.get('expanded'))
        @render()

        if @model.get('expanded')
          if @model.get('state') == 'new'
            @model.loadCredIDs()
          else if @model.get('state') == 'loaded'
            @renderLazyList(ids: @model.get('cred_ids'))
        else
          @list.destroy()

      # Called when the group of Creds is successfully loaded
      credsLoaded: (opts) =>
        @renderLazyList(opts)

      renderLazyList: (opts={}) =>
        {ids} = opts
        @lazyList = new App.Components.LazyList.Controller
          collection: @model.get('creds')
          region: @list
          ids: ids
          childView: CredSelection.CredRow

      onShow: =>
        if @model.get('working')
          @renderLazyList()

      # removes the CredGroup from its parent collection
      removeGroup: (e) =>
        @parentCollection.remove(@model)
        e.preventDefault()
        e.stopImmediatePropagation()

    #
    # The GroupsContainer is a composite view that holds a CredGroupsCollection,
    # which contains multiple credential groups that can be independently added or
    # removed to the current selection. The last group in the collection is always
    # expanded.
    #
    class CredSelection.GroupsContainer extends App.Views.CompositeView

      template: @::templatePath('brute_force_reuse/cred_selection/group_container')

      attributes:
        class: 'credential-groups'

      childView: CredSelection.Group

      childViewContainer: 'ul.groups'

      ui:
        dropdown: 'div.dropdown'
        clear: 'a.clear'
        badge: 'span.badge'

      events:
        'change @ui.dropdown': 'dropdownChanged'
        'click @ui.dropdown': 'dropdownClicked'
        'click @ui.clear': 'clearClicked'

      #
      # Public instance properties
      #

      # @property collection [Entities.CredGroupsCollection] the groups we are combining to
      #   build the current collection. the last group in this collection is always expanded.
      collection: null

      # @property groups [Entities.CredGroupsCollection] all the groups in the workspace
      groups: null

      # @property groupsFetched [Boolean] the request to fetch all groups succeeded
      groupsFetched: false

      # @property workspace_id [Number] the id of the current workspace. defaults to global.
      workspace_id: null

      # @property workingGroup [App.Entities.CredGroup]
      workingGroup: null

      # @property workingGroupView [App.CredSelection.Group] the active view for the group
      workingGroupView: null

      #
      # Private instance properties
      #

      # @param opts [Object] the options hash
      # @option opts workspace_id [Number] the workspace we are currently inside
      initialize: (opts={}) ->
        @workspace_id = opts.workspace_id || WORKSPACE_ID
        @workingGroup = opts.workingGroup || new App.Entities.CredGroup(workspace_id: @workspace_id, working: true)
        @collection = new App.Entities.CredGroupsCollection([@workingGroup], workspace_id: @workspace_id)
        @groups = new App.Entities.CredGroupsCollection([], workspace_id: @workspace_id)
        @listenTo @workingGroup.get('creds'), 'add', @selectionUpdated
        @listenTo @workingGroup.get('creds'), 'remove', @selectionUpdated
        @listenTo @workingGroup.get('creds'), 'reset', @selectionUpdated

      onShow: =>
        @_loadGroups()
        _.defer =>
          @selectionUpdated()

      onRender: =>
        @_renderSelect2() if @groupsFetched

      onDestroy: =>
        @_destroySelect2() if @groupsFetched

      serializeData: -> @

      appendHtml: (collectionView, itemView) ->
        @$el.find(collectionView.childViewContainer).prepend(itemView.el)

      # Overriden to allow passing options to the rendered ItemView
      buildChildView: (item, ItemView) =>
        view = new ItemView(model: item, collection: @collection)
        if item is @workingGroup
          @workingGroupView = view
        view

      #
      # Event handlers
      #

      # Called any time the user makes a selecton from the Import Groups dropdown
      dropdownChanged: (e) =>
        @ui.dropdown.select2('val', '') # do nothing!
        newGroup = @groups.get(e.val)
        newGroup?.set(expanded: false)
        @collection.add(newGroup) if newGroup?

      # Called the first time the view is rendered
      onShow: =>
        @ui.clear.tooltip()

      # called any time the working group changes
      selectionUpdated: =>
        @_updateClearState()
        @_updateSelectionCount()

      clearClicked: =>
        result = confirm("Are you sure you want to remove all selected credentials?")
        if result then @workingGroup.get('creds').reset([])

      #
      # Private instance methods
      #`

      # Hides or shows the "clear" button depending on the state of the working group
      _updateClearState: =>
        _.defer =>
          @ui?.clear?.toggle?(@_numSelectedCreds() > 0)

      # Updates the selected badge based on the working group
      _updateSelectionCount: =>
        _.defer =>
          @ui?.badge?.toggle?(@_numSelectedCreds() > 0).text(@_numSelectedCreds())

      # Looks at the working group to get the count of models
      # @return [Number] number of selected creds
      _numSelectedCreds: =>
        @workingGroup.get('creds').ids?.length || 0

      # Renders the select2 jquery plugin to allow dynamic selection of pre-existing groups
      _renderSelect2: =>
        models = _.map @groups.models, (m) ->
          name: m.get('name')
          id: m.id.toString() # stupid select2

        @ui.dropdown.select2
          placeholder: 'Import Existing Group'
          data: { results: models, text: 'name' }
          initSelection: null
          minimumResultsForSearch: 5
          escapeMarkup: _.identity
          formatResult: (m) ->
            "<span>#{_.escape m.name}</span><a class='right' href='javascript:void(0)'>×</a>"

        @ui.dropdown.change(@dropdownChanged)

      # Destroys the bindings added by the jquery select2 plugin to the dom
      _destroySelect2: =>
        @ui.dropdown.select2('destroy')

      # lazily loads the list of all Groups in the current workspace to put in
      # the select2 dropdown
      _loadGroups: =>
        return if @isClosed

        @groups.fetch()
          .done =>
            @groupsFetched = true
            @render()
          .error =>
            _.delay @_loadGroups, 5000

