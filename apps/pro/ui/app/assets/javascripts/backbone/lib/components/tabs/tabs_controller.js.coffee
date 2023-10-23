define [
  'base_controller'
  'base_model'
  'lib/entities/abstract/tab'
  'lib/components/tabs/tabs_view'
], () ->
  @Pro.module "Components.Tabs", (Tabs, App, Backbone, Marionette, $, _) ->

    class Tabs.TabsController extends App.Controllers.Application


      # Hash of default options for controller
      # @option opts crumbs      [Object] the default options
      #
      defaults: ->
        tabs: []
        destroy: true


      # Create a new instance of the TabsController and adds it to the specified region
      #
      # @param [Array] tabsArr array of option hashes containing tab name, view and model per tab
      #
      #
      initialize: (opts={}) ->
        #Set default key/values if key not defined in options hash
        @config = _.defaults opts, @_getDefaults()

        @setMainView(new Tabs.Layout())

        #Creates an array of backbone models from Array Hash
        models = _.map(@config.tabs, (tab)->
          App.request 'component:tab:entity', tab
        )
        #The collection of tab models
        @collection = App.request 'component:tab:entities', models

        #When the tab container is shown, show tabs collection and tab content region
        @listenTo @_mainView, 'show', () =>
          #Show View/Region representing the individual tabs
          collectionView = new Tabs.TabCollection(collection:@collection)
          @show collectionView, region: @_mainView.tabs

          #Select the first tab and show corresponding region
          @collection.at(0).choose()

        if @config.destroy
          @initTabSwap()
        else
          @initTabSwapSimple()

      #
      # Default tab swapping behavior. Views are destroyed on tab
      #
      initTabSwap: ->
        #When model is selected update content view
        @listenTo @collection, "collection:chose:one", (chosen) ->
          View = chosen.get('view')
          view = new View(model: chosen.get('model'), options: chosen.get('options'))

          @show view, region: @_mainView.tabContent


      #
      # Simple tab swapping behavior. Views are hidden on tab
      #
      initTabSwapSimple: ->
        #When model is selected update content view
        @listenTo @collection, "collection:chose:one", (chosen) ->
          # If not cached initialize view instance and cache it
          unless chosen.get('cachedView')
            View = chosen.get('view')
            view = new View(model: chosen.get('model'), options: chosen.get('options'))
            chosen.set('cachedView', view)
            @_showView(view)
          # else use cached version
          else
            view = chosen.get('cachedView')
            @_showView(view)

      #
      # Show/Hide views
      #
      # @param [Backbone.View] the view that needs to be shown
      #
      _showView: (view) ->
        id = view.cid
        # If region already exists, hide all other regions and show chosen one
        if @_mainView.getRegion(id)
          $('>div',this._mainView.ui.tabContent).hide()
          @_mainView.getRegion(id).$el.show()
        # Create chosen region and show view, hide all other regions
        else
          @_mainView.ui.tabContent.append("<div class='#{id}'></div>")
          @_mainView.addRegion(id,".#{id}")
          @show view, region: @_mainView.getRegion(id)
          $('>div',this._mainView.ui.tabContent).hide()
          @_mainView.getRegion(id).$el.show()


      # Mark tabs as with content containing form validations
      #
      # @param [Array] tabIdx array of tab indexes to indicate which tabs to mark as invalid (form validation)
      #
      setInvalidTabs: (tabIdx=[]) ->
        for tabId in tabIdx
          @collection.at(tabId).set('valid', false)

      # Clear validation errors on the tabs themselves
      #
      resetValidTabs: () ->
        @collection.each (tab) ->
          tab.set('valid',true)


    #Reqres Handler to create the Tab Component Controller
    App.reqres.setHandler 'tabs:component', (opts={}) ->
      new Tabs.TabsController opts
