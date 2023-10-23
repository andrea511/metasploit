define [
  'base_controller'
  'entities/cred'
  'apps/brute_force_reuse/header/header_views'
  'lib/components/breadcrumbs/breadcrumbs_controller'
], ->

  @Pro.module 'BruteForceReuseApp.Header', (Header, App) ->

    class Header.Controller extends App.Controllers.Application

      initialize: (options) ->
        @layout = new Header.Layout
        @setMainView(@layout)

        {@workingGroup, @targetListCollection} = options


        @listenTo @targetListCollection, 'reset remove', =>
          @setLaunchCrumb()

        @listenTo @workingGroup.get('creds'), 'reset remove', =>
          @setLaunchCrumb()


        @listenTo @getMainView(), 'show', =>
          @crumbsController = App.request 'crumbs:component', crumbs:
             [
               {title: 'TARGETS'},
               {title: 'CREDENTIALS'},
               {title: 'REVIEW'},
               {title: 'LAUNCH'}
             ]
          @crumbsCollection = @crumbsController.crumbsCollection


          @listenTo @crumbsCollection, "collection:chose:one", (chosen) ->
            switch chosen.get('title')
              when 'REVIEW'
                @setLaunchCrumb()
              else
                @unsetLaunchCrumb()

          @show @crumbsController, region: @layout.crumbs


      setLaunchCrumb:() ->
        reviewCrumb = @crumbsCollection.findWhere(title: "LAUNCH")
        if @targetListCollection?.length>0 and @workingGroup.get('creds').length >0
          reviewCrumb.set('launchable', true)
        else
          @unsetLaunchCrumb()

      unsetLaunchCrumb: () ->
        reviewCrumb = @crumbsCollection.findWhere(title: "LAUNCH")
        reviewCrumb.set('launchable', false)

    App.reqres.setHandler "header:bruteForceReuseApp", (options={}) ->
      new Header.Controller options
