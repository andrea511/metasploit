define [
  'base_layout'
  'base_view'
  'base_itemview'
  'apps/brute_force_guess/quick/templates/quick_layout'
  'apps/brute_force_guess/quick/templates/mutation_view'
  'apps/brute_force_guess/quick/templates/targets_view'
  'apps/brute_force_guess/quick/templates/creds_view'
  'apps/brute_force_guess/quick/templates/options_view'
  'apps/brute_force_guess/quick/templates/confirmation_view'
  'apps/brute_force_guess/quick/templates/cred_limit_view'
  'lib/concerns/views/text_area_limit'
], () ->

  # REMEMBER TO UPDATE MIGRATION db/migrate/20141210203237_migrate_legacy_bruteforce_chain.rb
  # if form inputs change

  @Pro.module 'BruteForceGuessApp.Quick', (Quick, App, Backbone, Marionette, $, _) ->

    CHUNK_SIZE = 20000

    class Quick.Layout extends App.Views.Layout
      template: @::templatePath 'brute_force_guess/quick/quick_layout'

      ui:
        launch: '.launch-container a'

      regions:
        targetsRegion: '#targets-region'
        credsRegion: "#creds-region"
        optionsRegion: "#options-region"
        breadcrumbRegion: ".row.breadcrumbs"

      triggers:
        'click @ui.launch' : 'launch:clicked'

      enableLaunch:->
        @ui.launch.removeClass('disabled')

      disableLaunch: ->
        @ui.launch.addClass('disabled')

      showErrors: (errors) ->
        $('.error',@el).remove()

        _.each errors, (v,k) =>
          if typeof v =="object"
            @_renderError(v,k)

      _renderError: (obj,key) ->
        _.each obj, (v,k) =>
          if typeof v == "object" and v?
            @_renderError(v,"#{key}[#{k}]")
          else
            if v?
              if typeof k == "number"
                $msg = $('<div />', class: 'error').text(v)
                $("[name='#{key}']", @el).addClass('invalid').after($msg)
                $("[name='#{key}[]']", @el).first().addClass('invalid').after($msg)


    class Quick.TargetsView extends App.Views.Layout
      template: @::templatePath 'brute_force_guess/quick/targets_view'

      ui:
        targetRadio: '[name="quick_bruteforce[targets][type]"]:checked'
        targetText: '#manual-target-entry'
        addresses: '.addresses'
        blacklistTargetText: '#manual-target-entry-blacklist'
        allServices: '.all-services'
        services: '.services input:not(.all-services)'
        serviceInputs: '.services input'
        targetCount: '.target-count'
        enterTargetAddresses: 'input.manual-hosts'

      regions:
        targetAddressesTooltipRegion: '.target-addresses-tooltip-region'
        blacklistAddressesTooltipRegion: '.blacklist-addresses-tooltip-region'

      events:
       'change @ui.targetRadio' : '_showHideTargetText'
       'change @ui.allServices' : '_selectDeselectServices'

      triggers:
       'focusout @ui.targetText': 'countTargets'
       'focusout @ui.blacklistTargetText' : 'countTargets'
       'change @ui.serviceInputs' : 'countTargets'

      initialize: () ->
        @targetCount = 0

      setTargetCount: (count) ->
        @targetCount = count
        @ui.targetCount.html(count)
        @trigger('targetCount:update')

      restoreUIState: ->
        @bindUIElements()
        @ui.targetRadio.trigger('change')

      populateAddresses: (addresses) ->
        _.each(addresses,(address)=>
          @ui.targetText.val(@ui.targetText.val()+address+'\n')
        )
        @ui.enterTargetAddresses.prop('checked','checked')
        @ui.enterTargetAddresses.trigger('change')


      _showHideTargetText: (e) ->
        #Manually trigger since we can't listen to trigger and events hash at same time
        @trigger('countTargets')

        if $(e.target).val() == "all"
          @ui.addresses.hide()
        else
          @ui.addresses.show()

      _selectDeselectServices: (e) ->
        if $(e.target).prop('checked')
          @ui.services.prop('checked',true)
        else
          @ui.services.prop('checked',false)


    class Quick.CredsView extends App.Views.Layout
      template: @::templatePath 'brute_force_guess/quick/creds_view'

      ui:
        import_cred_pairs: '[name="quick_bruteforce[creds][add_import_cred_pairs]"]'
        import_cred_pairs_text: '.manual-cred-pair'
        import_workspace_creds: '[name="quick_bruteforce[creds][import_workspace_creds]"]'
        fileInput: '#file_input'
        textArea: '#manual-cred-pair-entry'
        textAreaCount: '[name="text_area_count"]'
        textAreaDisabled: '[name="text_area_status"]'
        importPairCount: '[name="import_pair_count"]'
        filePairCount: '[name="file_pair_count"]'
        cloneFileWarning: '[name="clone_file_warning"]'
        credCount: '.cred-count'
        countFuzz: '.count .fuzz'
        lastUploaded: '.last-uploaded'
        useLastUploaded: '[name="quick_bruteforce[use_last_uploaded]"]'
        useFileContents: '[name="quick_bruteforce[creds][import_cred_pairs][use_file_contents]"]'
        mutationLabel: '.mutation-label'
        defaultsLabel: '.defaults-label'
        fileCancel: '.cancel.file-input'
        factoryDefault:  '[name="quick_bruteforce[creds][factory_defaults]"]'
        blankAsPassword: '[name="quick_bruteforce[creds][import_cred_pairs][blank_as_password]"]'
        usernameAsPassword: '[name="quick_bruteforce[creds][import_cred_pairs][username_as_password]"]'

      events:
        'change @ui.import_cred_pairs': '_showHideCredText'
        'change @ui.import_workspace_creds' : '_import_workspace_creds'
        'keyup @ui.textArea' : '_credChanged'
        'change @ui.blankAsPassword': '_changeRule'
        'change @ui.usernameAsPassword': '_changeRule'
        'change @ui.factoryDefault' : '_changeFactoryDefault'

      triggers:
        'click @ui.fileCancel' : 'fileInput:clear'

      regions:
        fileUploadRegion: '.file-upload-region'

      @include 'TextAreaLimit'

      initialize: ->
        @file_cred_count = 0
        @text_area_count = 0
        @shown_cred_count = 0
        @workspace_cred_count = 0
        @import_cred_pairs_count = 0
        @restored_import_cred_pairs_count = 0
        @is_task_chain = @model.get('is_task_chain')
        @debouncedChangeEvent =  _.debounce(@_countCreds, 300);

      onShow: () ->
        @_bindTextArea(@ui.textArea,100, Quick.CredLimitView)
        unless @is_task_chain
          $('.cred-file-upload-region').css('display','inline-block')

      onDestroy: () ->
        @_unbindTextArea(@ui.textArea)

      hideMutationLabel: () ->
        @_fuzzComboCount(false)
        @ui.mutationLabel.css('display','none')

      showMutationLabel: () ->
        @_fuzzComboCount()
        @ui.mutationLabel.css('display','inline-block')

      showFactoryDefaultsLabel: ->
        @_fuzzComboCount()
        @ui.defaultsLabel.css('display','inline-block')

      hideFactoryDefaultsLabel: ->
        @_fuzzComboCount(false)
        @ui.defaultsLabel.css('display','none')

      factoryDefaultChecked: ->
        @ui.factoryDefault.prop('checked')

      showFileCancel: (bool=true) ->
        if bool
          @ui.fileCancel.css('visibility','visible')
        else
          @ui.fileCancel.css('visibility','hidden')
          $('.error',@el).remove()


      useLastUploaded: (fileName) ->
        @lastUploaded = fileName

        @ui.lastUploaded.show()
        @ui.lastUploaded.text("Last Uploaded: #{fileName}")
        @ui.useLastUploaded.val(fileName)

      restoreUIState: (opts={}) ->
        if @ui.cloneFileWarning.val() == "true"
          @_showFileWarning()
          @ui.cloneFileWarning.val(false)

        @ui.textArea.trigger('focusout')

        #Kinda dirty but the bruteforce task view isn't too friendly here
        if $('[name="quick_bruteforce[options][mutation]"]').prop("checked")
          @showMutationLabel()

        if @ui.factoryDefault.prop("checked")
          @showFactoryDefaultsLabel()

        @ui.import_cred_pairs.trigger('change')
        @ui.import_workspace_creds.trigger('change')

        if @ui.textAreaDisabled.val() == 'true'
          @_disableTextArea()

        @restoreLastUploaded()

        #If toggling between tasks else an existing task in a task chain
        if opts.restoreFileInput
          @fileChanged()
        else
          @restoreImportCount()

      restoreImportCount: () ->
        @restored_import_cred_pairs_count = parseInt(@ui.importPairCount.val()) || 0
        @file_cred_count = parseInt(@ui.filePairCount.val()) || 0

        @_updateCredCount(@restored_import_cred_pairs_count+@workspace_cred_count)

      restoreLastUploaded: ->
        unless @ui.useLastUploaded.val() == ''
          @useLastUploaded(@ui.useLastUploaded.val())
        else
          @ui.lastUploaded.hide()

      getComboCount: () ->
        parseInt(@ui.credCount.html())

      resetFileCount: () ->
        @file_cred_count=0
        @_countCreds()

      _changeFactoryDefault: (e) ->
        if $(e.target).prop('checked')
          @showFactoryDefaultsLabel()
        else
          @hideFactoryDefaultsLabel()

      isFuzzed: ->
        parseInt(@ui.countFuzz.data('count')) > 0

      _fuzzComboCount: (show=true) ->
        if show
          @ui.countFuzz.data('count', parseInt(@ui.countFuzz.data('count')||0)+1)
          @ui.countFuzz.show()
        else
          @ui.countFuzz.data('count',parseInt(@ui.countFuzz.data('count')||0)-1)
          if parseInt(@ui.countFuzz.data('count'))==0
            @ui.countFuzz.hide()
        @trigger('credCount:update')

      _credChanged: () ->
        @debouncedChangeEvent()

      _focusOutTextArea: (e) =>
        @_terminateCred(e)

      _import_workspace_creds: (e) ->
        if $(e.target).prop('checked')
          @workspace_cred_count = @model.get('workspace_cred_count')
          @_updateCredCount(@import_cred_pairs_count+@workspace_cred_count)
        else
          @workspace_cred_count = 0
          @_updateCredCount(@import_cred_pairs_count)

      _showFileWarning: () ->
        #View File region is a seperate component so we don't have the UI hash here.
        #Behavior specific to this view.
        $(".file-upload-region label",@el).css('border-color':'red')
        $(".file-upload-region span",@el).css(
          'border-color':'red'
          'border-left-color' : '#666'
        )
        $(".file-upload-region").append("<div class='error' style='color:red;'>Please re-select file</div>")
        $(".columns.small-12>.errors").replaceWith('<div class="errors" style="display: block;">The file you selected cannot be cloned. Please re-select the file.</div>')

      _showHideCredText: (e) ->
        if $(e.target).prop('checked')
          @import_cred_pairs_count = @file_cred_count + @text_area_count + @restored_import_cred_pairs_count
          @_updateCredCount(@import_cred_pairs_count+@workspace_cred_count)
          @ui.import_cred_pairs_text.show()
        else
          @import_cred_pairs_count = 0
          @_updateCredCount(@workspace_cred_count)
          @ui.import_cred_pairs_text.hide()

      clearLastUploaded: () ->
        @ui.lastUploaded.hide()
        $('.error',@el).remove()

      _disableTextArea: () ->
        @ui.textAreaDisabled.val(true)
        @ui.textArea.addClass('disabled')
        @ui.textArea.prop('disabled',true)

      _enableTextArea: () ->
        @ui.textAreaDisabled.val(false)
        @ui.textArea.removeClass('disabled')
        @ui.textArea.prop('disabled', false)

      fileChanged: () ->
        @bindUIElements()
        @clearLastUploaded()

        @file_cred_count=0
        file = @ui.fileInput[0].files[0]

        if file? && file.name.match(/.txt/)
          @ui.cloneFileWarning.val(true)
          @_parseCreds(file)
        else
          @_countCreds()


      _parseCreds: (file) ->
        file_size = file.size
        file_type = file.type

        for byte in [0..file_size] by CHUNK_SIZE
          blob = file.slice(byte, byte+CHUNK_SIZE)

          chunk_reader = new FileReader()
          chunk_reader.onloadstart = @_showLoading
          chunk_reader.onloadend = @_countCreds
          chunk_reader.readAsText(blob)


      _showLoading: () =>
        @ui.textArea.addClass('tab-loading')

      _changeRule: ->
        @fileChanged()
        @_countCreds()

      _countCreds: (e) =>
        @ui.textArea.removeClass('tab-loading')

        #If callback from file reader else called as a regular method
        if e?
          @file_cred_count = @file_cred_count + @_textAreaCount(e.target.result)
        else
          @text_area_count = @_textAreaCount(@ui.textArea.val())

        @import_cred_pairs_count = @file_cred_count + @text_area_count
        @restored_import_cred_pairs_count = 0
        @ui.importPairCount.val(@import_cred_pairs_count)
        @ui.textAreaCount.val(@text_area_count)
        @ui.filePairCount.val(@file_cred_count)
        @_updateCredCount(@import_cred_pairs_count+@workspace_cred_count)


      _textAreaCount: (val) ->
        count=0

        lines = val.match(/(([^\s]+(([\u0020]+[^\s]+)+)))|([^\s]+)/g)

        _.each(lines,(elem)=>
          #split = elem.split(' ')
          #split = _.filter(split,(elem)-> elem!='')
          passwordCount = -1
          inQuote = 0;
          inToken = 0;
          for i in [0 .. elem.length - 1]
            c = elem[i]
            if inQuote == 1
              if c == "\""
                inQuote = 0
              continue
            if c == " " || c == "\t"
              inToken = 0;
              continue
            if inToken == 0
              inToken = 1
              passwordCount = passwordCount + 1
            if c == "\""
              inQuote = 1
          #passwordCount = split.length-1
          if @ui.usernameAsPassword.prop('checked')
            passwordCount = passwordCount + 1
          if @ui.blankAsPassword.prop('checked')
            passwordCount = passwordCount + 1
          count = count + passwordCount
        )
        count


      _terminateCred:(e) =>
        val = $(e.target).val()
        if val.length > 2 and val.substring(val.length-1,val.length) != "\n"
          @ui.textArea.val(val+'\n')
          @ui.textArea.trigger('keyup')


      _updateCredCount: (count) ->
        @ui.credCount.html(_.escape(count))
        @trigger('credCount:update')


    class Quick.OptionsView extends App.Views.Layout
      template: @::templatePath 'brute_force_guess/quick/options_view'

      ui:
       form: 'form'
       payloadCheckBox: 'input[name="quick_bruteforce[options][payload_settings]"]'
       mutationCheckBox: 'input[name="quick_bruteforce[options][mutation]"]'
       hour: 'input[name="quick_bruteforce[options][overall_timeout][hour]"]'
       minutes: 'input[name="quick_bruteforce[options][overall_timeout][minutes]"]'
       seconds: 'input[name="quick_bruteforce[options][overall_timeout][seconds]"]'
       serviceTimeout: 'input[name="quick_bruteforce[options][service_timeout]"]'

      regions:
        overallTimeoutTooltipRegion: '.overall-timeout-tooltip-region'
        serviceTimeoutTooltipRegion: '.service-timeout-tooltip-region'
        timeTooltipRegion: '.time-tooltip-region'
        mutationTooltipRegion: '.mutation-tooltip-region'
        sessionTooltipRegion: '.session-tooltip-region'

      events:
        'input @ui.hour' : '_parseOptions'
        'input @ui.minutes' : '_parseOptions'
        'input @ui.seconds' : '_parseOptions'
        'input @ui.serviceTimeout': '_parseOptions'

      triggers:
        'change @ui.payloadCheckBox ' : 'payloadSettings:show'
        'change @ui.mutationCheckBox' : 'mutationOptions:show'

      deselectPayload: () ->
        @ui.payloadCheckBox.prop('checked', false)

      isPayloadSettingsSelected: ->
        @ui.payloadCheckBox.prop('checked')

      isMutationCheckboxSelected: ->
        @ui.mutationCheckBox.prop('checked')

      _parseOptions: (e) ->
        $(e.target).val($(e.target).val().replace(/[^0-9]/g, ''))

    class Quick.ConfirmationView extends App.Views.ItemView
      template: @::templatePath 'brute_force_guess/quick/confirmation_view'

      className: 'confirmation-view'

      onFormSubmit: ->
        # jQuery Deffered Object that closes modal when resolved.
        defer = $.Deferred()
        formSubmit = () ->
        defer.promise(formSubmit)
        defer.resolve()
        @trigger("launch")

        formSubmit

    class Quick.MutationView extends App.Views.ItemView
      template: @::templatePath 'brute_force_guess/quick/mutation_view'

      className: 'mutation-options'

      onRender: ->
        Backbone.Syphon.deserialize(@, @model.toJSON())


      # Interface method required by {Components.Modal}
      #
      # @return [Promise] jQuery promise
      onFormSubmit: () ->
        # jQuery Deferred Object that closes modal when resolved.
        defer = $.Deferred()
        formSubmit = () ->
        defer.promise(formSubmit)

        #TODO: Do some validations
        @_serializeForm()

        defer.resolve()
        defer

      _serializeForm: () ->
        @model.set(Backbone.Syphon.serialize(@))

    class Quick.CredLimitView extends App.Views.ItemView
      template: @::templatePath 'brute_force_guess/quick/cred_limit_view'

      className: 'cred-limit-view'

      onFormSubmit: () ->
        # jQuery Deferred Object that closes modal when resolved.
        defer = $.Deferred()
        formSubmit = () ->
        defer.promise(formSubmit)
        defer.resolve()
        defer

        formSubmit
