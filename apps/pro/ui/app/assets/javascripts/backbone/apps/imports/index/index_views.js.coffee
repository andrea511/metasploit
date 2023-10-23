define [
  'base_layout'
  'base_view'
  'base_itemview'
  'apps/imports/index/templates/index_layout'
  'apps/imports/index/templates/type_selection_layout'
  'apps/imports/index/type'
], () ->
  @Pro.module 'ImportsApp.Index', (Index, App, Backbone, Marionette, $, _) ->

    class Index.Layout extends App.Views.Layout
      template: @::templatePath 'imports/index/index_layout'

      className: 'foundation'

      ui:
        importBtn: '.import-btn'
        tagsLabel: '.tags-label'
        tagsPane: '.tags-pane'
        expandArrow: 'span.expand'
        collapseArrow: 'span.collapse'
        autoTagOs: '[name="imports[autotag_os]"]'
        preserveHosts: '#update_hosts'

      events:
        'click @ui.tagsLabel' : '_toggleTags'

      modelEvents:
        'change:showAutoTagByOS' : '_updateAutoTagOS'
        'change:showDontChangeExistingHosts' : '_updateDontChangeExistingHosts'

      triggers:
        'click @ui.importBtn':'import:start'

      regions:
        importTypeSelectRegion: '.import-type-select-region'
        mainImportViewRegion: '.main-import-view-region'
        tagsRegion: '.tags-region'

      _updateAutoTagOS: (model,visible) ->
        if visible
          @ui.autoTagOs.parent().show()
        else
          @ui.autoTagOs.parent().hide()

      _updateDontChangeExistingHosts: (model,visible) ->
        if visible
          @ui.preserveHosts.parent().show()
        else
          @ui.preserveHosts.parent().hide()

      _toggleTags: () ->
        @ui.expandArrow.toggle()
        @ui.collapseArrow.toggle()
        @ui.tagsPane.slideToggle('fast')

      enableImportButton: () ->
        @ui.importBtn.removeClass('disabled')

      disableImportButton: () ->
        @ui.importBtn.addClass('disabled')

      expandTagSection: ->
        @ui.expandArrow.hide()
        @ui.collapseArrow.show()
        @ui.tagsPane.show()

    #
    # Renders the radio button selection for Import Data Page
    # Only two selections available: 1) Nexpose Import 2) File Import
    #
    class Index.TypeSelectionView extends App.Views.ItemView

      template: @::templatePath 'imports/index/type_selection_layout'

      ui:
        nexposeRadioButton: '#import-from-nexpose'
        fileRadioButton: '#import-from-file'
        sonarRadioButton: '#import-from-sonar'
        importType: '[name="imports[type]"]'
        selectedImportType: '[name="imports[type]"]:checked'

      events:
        'change @ui.importType' : '_importTypeChanged'

      onRender: ->
        @_setRadioButton()

      _importTypeChanged: (e) =>
        @_bindUIElements()
        currentSelection = e.currentTarget.value
        switch currentSelection
          when @ui.fileRadioButton.val() then @model.set('type', Index.Type.File)
          when @ui.nexposeRadioButton.val() then @model.set('type', Index.Type.Nexpose)
          when @ui.sonarRadioButton.val() then @model.set('type', Index.Type.Sonar)
          else throw "Invalid import selection [#{currentSelection}]"

        @trigger('import:typeChange', @model)

      _getFileRadioButtonVal: ->
        @ui.fileRadioButton.val()

      _setRadioButton: ->
        @_clearRadioButtons()
        type = @model.get('type')
        switch type
          when Index.Type.File
            @_selectFileRadioButton()
          when Index.Type.Nexpose
            @_selectNexposeRadioButton()
          when Index.Type.Sonar
            @_selectSonarRadioButton()
          else
            throw "Error setting radio button [#{type}]"

      _clearRadioButtons: ->
        @ui.importType.prop('checked',false)

      _selectFileRadioButton: ->
        @ui.fileRadioButton.prop('checked', true)

      _selectNexposeRadioButton: ->
        @ui.nexposeRadioButton.prop('checked', true)

      _selectSonarRadioButton: ->
        @ui.sonarRadioButton.prop('checked', true)
