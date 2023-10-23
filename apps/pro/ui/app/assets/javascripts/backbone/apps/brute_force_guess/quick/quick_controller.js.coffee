define [
  'base_controller'
  'apps/brute_force_guess/quick/quick_views'
  'entities/brute_force_guess/target'
  'entities/brute_force_guess/mutation_options'
  'lib/components/modal/modal_controller'
  'lib/shared/payload_settings/payload_settings_controller'
  'lib/components/breadcrumbs/breadcrumbs_controller'
  'lib/components/file_input/file_input_controller'
  'lib/components/tooltip/tooltip_controller'
], ->
  @Pro.module "BruteForceGuessApp.Quick", (Quick, App) ->

    class Quick.Controller extends App.Controllers.Application

      initialize: (options)->
        _.defaults options,
          taskChain:false

        {taskChain, @payloadModel, @mutationModel} = options


        @layout = new Quick.Layout(model: new Backbone.Model(taskChain:taskChain))
        @setMainView(@layout)
        @_listenToMainView()

      restoreUIState: (opts={}) ->
        @targetsView.restoreUIState()
        @credsView.restoreUIState(opts)

      useLastUploaded: (filePath) ->
        fileName = filePath.split('/').pop()
        @credsView.useLastUploaded(fileName)

      _listenToMainView: () =>
        @listenTo @_mainView, 'show', ->
          @_initViews()
          @_listenToTargetsView()
          @_listenToCredsView()
          @_listenToPayloadSettings()
          @_listenToMutationOptions()
          @_listenToTooltips()
          @_initCrumbComponent()
          @_showViews()

        @listenTo @_mainView, 'launch:clicked', ->
          unless localStorage.getItem("Launch Bruteforce") == "false"
            view = new Quick.ConfirmationView(model: new Backbone.Model({
              combo_count: @_getComboCount()
              fuzz: @credsView.isFuzzed()
            }))

            App.execute 'showModal', view,
              modal:
                title: 'Launch Bruteforce'
                description: ''
                width: 400
                height: 220
                showAgainOption: true
              buttons: [
                {name: 'No', class: 'close'}
                {name: 'Yes', class: 'btn primary'}
              ]

            @listenTo view, 'launch', =>
              @_launchBruteForce()
          else
              @_launchBruteForce()


      _launchBruteForce: () ->
        Pro.execute('loadingOverlay:show')
        config = @_configModel()

        csrf_param = $('meta[name=csrf-param]').attr('content');
        csrf_token = $('meta[name=csrf-token]').attr('content');
        values_with_csrf;

        values_with_csrf = _.extend({}, config.toJSON())
        values_with_csrf[csrf_param] = csrf_token

        if @_mainView.credsRegion.currentView.ui.fileInput.val() != ''
          config.save(
            {},
            {
              iframe: true
              files: @_mainView.credsRegion.currentView.ui.fileInput
              data: values_with_csrf
              complete: (data)  =>
                data = $.parseJSON(data.responseText)
                if data.success == true
                  window.location = data.redirect_to
                else
                  Pro.execute('loadingOverlay:hide')
                  @_mainView.showErrors(data.errors)
            }
          )
        else
          config.save(
            {},
            {
              success: (model,response,options)  =>
                window.location = response.redirect_to
              error: (model,response,options) =>
                Pro.execute('loadingOverlay:hide')
                @_mainView.showErrors(response.responseJSON.errors)
            }
          )

      validateBruteForce: (callback) ->
        config = @_configModel()

        config.save(
          {validate_only:true},
          {
            success: (model,response,options) =>
              callback?(model,response,options)
            error: (model,response,options) =>
              callback?(model,response,options)
          }
        )


      _configModel: () =>
        mergedHash = _.extend(
          Backbone.Syphon.serialize(@_mainView,exclude: ["quick_bruteforce[file]"]),
          @payloadModel?.toJSON()
        )

        _.extend(mergedHash,@mutationModel?.toJSON())

        Pro.request "new:brute_force_guess_form:entity", mergedHash


      _initViews: ->
        target = App.request 'bruteForceGuess:target:entities', {}

        @targetsView = new Quick.TargetsView(model: target)
        @credsView = new Quick.CredsView(model: new Backbone.Model({
          workspace_cred_count: gon.workspace_cred_count
          is_task_chain: @_mainView.model.attributes.taskChain
        }))
        @optionsView = new Quick.OptionsView()

      _initCrumbComponent: ->
        @crumbsController = App.request 'crumbs:component', crumbs:
          [
            {title: 'TARGETS', selectable:false},
            {title: 'CREDENTIALS', selectable:false},
            {title: 'OPTIONS', selectable:false}
          ]
        @crumbsCollection = @crumbsController.crumbsCollection

      _listenToTooltips: ->
        @listenTo @optionsView, 'show', ->
          target_addresses_tip = App.request 'tooltip:component' , {
            title: "Target Addresses"
            content: """To specify the target hosts, you can enter a single IP address, an address range, or a
            CIDR notation.You must use a newline to separate each entry.

            For example:

            192.168.1.0/24
            192.169.1.1
            192.169.2.1-255

            If you do not enter any hosts in the Target addresses field, all hosts in the project will
            be selected except for the ones listed in the Excluded addresses field."""
          }
          blacklist_addresses_tip = App.request 'tooltip:component' , {
            title: "Excluded Addresses"
            content: """Enter a single IP address, an address range, or a CIDR notation. Use a new line to
            separate each entry.

            Example:
            10.20.37.60
            10.20.37.0/24"""
          }
          time_tip = App.request 'tooltip:component' , {
            title: 'Interval'
            content: 'Sets the amount of time that Bruteforce should wait between login attempts.'
          }
          service_tip = App.request 'tooltip:component' , {
            title: 'Service Timeout'
            content: 'Sets the timeout, in seconds, for each target.'
          }
          overall_tip = App.request 'tooltip:component' , {
            title: 'Overall Timeout'
            content: """Sets the timeout limit for how long the Bruteforce task can run in its entirety.
                      You can specify the timeout in the following format: HH:MM:SS. To set no timeout
                      limit, leave the fields blank."""
          }
          mutation_tip = App.request 'tooltip:component', {
            title: 'Mutation'
            content: """Mutations can be used to create permutations of a password, which enables you to
                      build a larger wordlist based on a small set of passwords. Mutations can be used to
                      add numbers and special characters to a password, toggle the casing of letters, and
                      control the length of a password."""
          }
          session_tip = App.request 'tooltip:component', {
            title: 'Session'
            content: """If enabled, Bruteforce will attempt to obtain a session when there is a successful
                      login attempt to MSSQL, MySQL, PostgreSQL, SMB, SSH, telnet, WinRM, and HTTP."""
          }

          @show target_addresses_tip, region: @targetsView.targetAddressesTooltipRegion
          @show blacklist_addresses_tip, region: @targetsView.blacklistAddressesTooltipRegion
          @show time_tip, region: @optionsView.timeTooltipRegion
          @show service_tip, region: @optionsView.serviceTimeoutTooltipRegion
          @show overall_tip, region: @optionsView.overallTimeoutTooltipRegion
          @show mutation_tip, region: @optionsView.mutationTooltipRegion
          @show session_tip, region: @optionsView.sessionTooltipRegion

      _listenToTargetsView: ->
        @listenTo @targetsView, 'show', ->
          if gon.host_ips?
            @targetsView.populateAddresses(_.map(gon.host_ips,(host_ip)->host_ip.address))

        @listenTo @targetsView, 'countTargets', ->
          data = Backbone.Syphon.serialize(@_mainView)
          Model = Backbone.Model.extend(
            url:->
              Routes.target_count_workspace_brute_force_guess_runs_path(WORKSPACE_ID)
          )
          model = new Model(data)
          model.save().done(@_updateTargetCount)


        @listenTo @targetsView, 'targetCount:update', =>
          @_toggleLaunch()

      _listenToPayloadSettings: ->
        @listenTo @optionsView, 'payloadSettings:show', (event) ->
          @payloadModel ?= App.request 'shared:payloadSettings:entities', {}

          if event.view.isPayloadSettingsSelected()
            App.execute 'showModal', new Pro.Shared.PayloadSettings.Controller(model:@payloadModel),
              modal:
                title: 'Payload Settings'
                description: ''
                width: 400
                height: 330
              buttons: [
                {name: 'Close', class: 'close'}
                {name: 'OK', class: 'btn primary'}
              ]
              closeCallback: () =>
                unless @payloadModel.get('validated')
                  @optionsView.deselectPayload()
              loading: true

      _listenToMutationOptions: ->
        @listenTo @optionsView, 'mutationOptions:show', (event) ->
          @mutationModel ?= App.request 'mutationOptions:entities', {}

          if event.view.isMutationCheckboxSelected()
            @credsView.showMutationLabel()
            App.execute 'showModal', new Quick.MutationView(model: @mutationModel ),
              modal:
                title: 'Add Mutation Rules'
                description: ''
                width:400
                height:330
              buttons: [
                {name: 'Close', class: 'close'}
                {name :'OK', class: 'btn primary'}
              ]
              loading: false
          else
            @credsView.hideMutationLabel()


      _listenToCredsView: ->
        @listenTo @credsView, 'show', ->
          @file_input = App.request 'file_input:component', {name: 'quick_bruteforce[file]'}

          @listenTo @file_input._mainView, "file:changed", (obj) ->
            @credsView.fileChanged()
            @credsView.showFileCancel(true)

          @listenTo @file_input._mainView, "show", ->
            @credsView.bindUIElements()

          @show @file_input, region: @credsView.fileUploadRegion

        @listenTo @credsView, 'fileInput:clear', ->
          @file_input.clear()
          @credsView.resetFileCount()
          @credsView.showFileCancel(false)


        @listenTo @credsView, 'credCount:update', =>
          @_toggleLaunch()

      _updateTargetCount: (response) =>
        @targetsView.setTargetCount(response.count)

      _getComboCount: ->
        @targetsView.targetCount * @credsView.getComboCount()

      _getFactoryDefaults: ->
        @targetsView.targetCount > 0 and @credsView.factoryDefaultChecked()

      _showViews: () ->
        @show @crumbsController, region: @_mainView.breadcrumbRegion
        @show @targetsView ,region: @_mainView.targetsRegion
        @show @credsView, region: @_mainView.credsRegion
        @show @optionsView, region: @_mainView.optionsRegion

      _toggleLaunch: ->
        if @_getComboCount() > 0 || @_getFactoryDefaults()
          @_mainView.enableLaunch()
        else
          @_mainView.disableLaunch()

