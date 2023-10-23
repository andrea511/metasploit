define [
  'base_controller'
  'entities/cred'
  'apps/brute_force_reuse/index/index_views'
  'lib/components/content_container/content_container_controller'
  'apps/brute_force_reuse/header/header_controller'
  'lib/shared/targets/targets_controller'
  'apps/brute_force_reuse/review/review_controller'
  'entities/target'
  'entities/brute_force_run'
  'entities/abstract/brute_force_reuse_options'
], ->

  @Pro.module 'BruteForceReuseApp.Index', (Index, App) ->

    class Index.Controller extends App.Controllers.Application

      initialize: (options) ->
        @core_id = options.core_id
        @workspace_id = options.workspace_id || WORKSPACE_ID
        @layout = new Index.Layout
        @setMainView(@layout)

        # Targets Controller containing targets pane
        @targetListCollection ||= App.request 'targets:entities',[],
          workspace_id: @workspace_id

        @workingGroup ||= new App.Entities.CredGroup(workspace_id: @workspace_id, working: true)

        @listenTo @getMainView(), 'show', =>
          # Controller containing header with label and breadcrumbs
          @headerController = App.request "header:bruteForceReuseApp", {targetListCollection:@targetListCollection, workingGroup: @workingGroup}

          # content container
          @contentContainer = App.request 'contentContainer:component',
            headerView: @headerController

          # when content container is shown
          @listenTo @contentContainer._mainView, "show", ->
            @setTargetTab()
            @headerController.crumbsCollection.choose(@headerController.crumbsCollection.at(0))

          @show @contentContainer, region: @layout.content

          prevChoice = @headerController.crumbsCollection.at(0)
          @listenTo @headerController.crumbsCollection, "collection:chose:one", (chosen) ->
            return if chosen is prevChoice
            reset = false
            switch chosen.get('title')
              when 'TARGETS'
                @setTargetTab()
              when 'CREDENTIALS'
                if prevChoice.get('title') isnt 'TARGETS' or !_.isEmpty(@targetListCollection.ids)
                  @setCredentialsTab()
                else
                  reset = true
                  @showError "You must add at least 1 target to the list."
              when 'REVIEW'
                if (prevChoice.get('title') isnt 'CREDENTIALS' and
                    prevChoice.get('title') isnt 'TARGETS') or
                    !_.isEmpty(@workingGroup.get('creds').ids)
                  @setReviewTab()
                else
                  reset = true
                  @showError "You must add at least 1 credential to the list."
              when 'LAUNCH'
                if _.isEmpty(@workingGroup.get('creds').ids)
                  @showError "You must have selected at least 1 credential to launch the Bruteforce."
                  reset = true
                else if _.isEmpty(@targetListCollection.ids)
                  @showError "You must have selected at least 1 target to launch the Bruteforce."
                  reset = true
                else
                  @setLaunchTab()

            if reset
              chosen.unchoose()
              prevChoice.choose()
            else
              prevChoice = chosen

          @listenTo @_mainView, 'tab:credentials', ->
            #Tab to Credentials when next is clicked from Targets Page
            @headerController.crumbsCollection.choose(@headerController.crumbsCollection.at(1))

          @listenTo @_mainView, 'tab:review', ->
            #Tab to Review when next is clicked from Targets Page
            @headerController.crumbsCollection.choose(@headerController.crumbsCollection.at(2))

          @listenTo @_mainView, 'tab:launch', ->
            @headerController.crumbsCollection.choose(@headerController.crumbsCollection.at(3))

          App.vent.on 'crumb:credentials', =>
            @headerController.crumbsCollection.choose(@headerController.crumbsCollection.at(1))

          App.vent.on 'crumb:targets', =>
            @headerController.crumbsCollection.choose(@headerController.crumbsCollection.at(0))

        @show @layout, region: @region

      showError: (msg) =>
        App.execute 'flash:display',
          title: 'Error'
          style: 'error'
          message: msg
          duration: 3000

      setTargetTab: ->
        @targetsController = App.request 'targets:shared', collection: @targetListCollection
        @contentContainer.showContentRegion(@targetsController)

      setCredentialsTab: ->
        @reuseCredController = new App.BruteForceReuseApp.CredSelection.Controller(show: false, workingGroup: @workingGroup)

        #Add Cred to lazy list
        @listenTo @reuseCredController._mainView, 'show', =>
          if @core_id? then @reuseCredController.addCred(@core_id)

        @contentContainer.showContentRegion(@reuseCredController)

      setReviewTab:() ->
        #Creds Controller containing creds pane
        @workingGroup ||= new App.Entities.CredGroup(workspace_id: @workspace_id, working: true)
        @reuseOptions ||= App.request 'new:brute_force_reuse_options:entity'

        reviewController = new App.BruteForceReuseApp.Review.Controller(
          show: false
          targetListCollection: @targetListCollection
          workingGroup: @workingGroup
          reuseOptions: @reuseOptions
        )
        @contentContainer.showContentRegion(reviewController)

      setLaunchTab: =>
        brute_force_run = App.request 'new:brute_force_run:entity',
          service_ids: @targetListCollection.ids
          core_ids: @workingGroup.get('creds').ids
          config: @reuseOptions.toJSON()
          workspace_id: @workspace_id

        #TODO: Call brute_force_run.save() and navigate to results screen
        App.execute 'loadingOverlay:show'
        brute_force_run.save().done (data) =>
          if data.success
            window.location = data.redirect_to
          else
            App.execute 'loadingOverlay:hide'

