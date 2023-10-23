define [
  'base_layout'
  'base_view'
  'base_itemview'
  'apps/imports/nexpose/templates/scan_and_import_layout'
  'apps/imports/nexpose/templates/site_import_layout'
  'apps/imports/nexpose/templates/choose_console'
  'lib/components/table/table_controller'
], () ->
  @Pro.module 'ImportsApp.Nexpose', (Nexpose, App, Backbone, Marionette, $, _) ->

    class Nexpose.SiteImportLayout extends App.Views.Layout
      template: @::templatePath 'imports/nexpose/site_import_layout'

      ui:
        configureNexposeBtn: '.configure-nexpose'
        nexposeConsole: '[name="imports[nexpose_console]"]'
        importType: '[name="imports[nexpose][type]"]'
        importTypeSelected:  '[name="imports[nexpose][type]"]:checked'
        errors: '.error-container'
        scanAndImport: '#scan-and-import'
        existing: '#existing'

      regions:
        nexposeSitesRegion: '.nexpose-sites-region'


      events:
        'change @ui.importType' : '_importTypeChanged'

      triggers:
        'click @ui.configureNexposeBtn': 'configureNexpose:nexpose'
        'change @ui.nexposeConsole' : 'selectNexposeConsole:nexpose'

      setScanAndImport: ->
        @ui.scanAndImport.prop('checked',true)
        @_importTypeChanged()

      setSiteImport: ->
        @ui.existing.prop('checked',true)
        @_importTypeChanged()

      setConsole: (consoleId) ->
        @ui.nexposeConsole.val(consoleId)
        @ui.nexposeConsole.trigger('change')

      showErrors: (errors) ->
        @ui.errors.css('display','block')
        @ui.errors.addClass('errors')
        @ui.errors.html(_.escape(errors))

      _importTypeChanged: =>
        @_bindUIElements()
        @trigger('selectImportType:nexpose',{view:@})


      # add a new console to the <select> dropdown
      # @param [Hash] opts the options hash
      # @option opts [Number] id
      # @option opts [String] name
      addNexposeConsoleToDropdown: (opts) ->
        consoles = @model.get('consoles')
        consoles[opts.name] = opts.id
        @model.set('consoles', consoles)
        $option = $('<option />', value: opts.id).text(opts.name)
        @ui.nexposeConsole.append($option)
        $option.prop('selected', true)
        @ui.nexposeConsole.trigger('change')

    class Nexpose.ScanAndImportLayout extends App.Views.Layout
      template: @::templatePath 'imports/nexpose/scan_and_import_layout'

      ui:
        whitelistHosts: '#nexpose_scan_task_whitelist_string'
        blacklistHosts: '#nexpose_scan_task_blacklist_string'
        scanTemplate: '#nexpose_scan_task_scan_template'
        error: '.error'

      events:
        'keyup @ui.whitelistHosts' : '_triggerWhiteListChange'

      onShow: ->
        @_triggerWhiteListChange()

      _triggerWhiteListChange: (e) ->
        @trigger 'scanAndImport:changed', @ui.whitelistHosts.val()

      # Render Form Errors
      # @param [Object] hash of errors
      showErrors: (errors) ->
        @bindUIElements()
        @ui.error.remove()
        if errors?
          _.each errors, (v, k) =>
            for error in v
              name = "nexpose_scan_task[#{k}]"
              $msg = $('<div />', class: 'error').text(error)
              $("[name='#{name}']", @el).addClass('invalid').after($msg)

    class Nexpose.ChooseConsole extends App.Views.Layout
      template : @::templatePath 'imports/nexpose/choose_console'

      className: 'shared nexpose-sites'