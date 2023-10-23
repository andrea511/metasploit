jQueryInWindow ($) ->
  QUICK_WEB_APP_SCAN_URL = '/wizards/quick_web_app_scan/form/'

  class @QuickWebAppScanModal extends @TabbedModalView
    _modelsToTabs: {
      # transition map to figure out which tab a nested model is on. e.g.:
      workspace: 0,
      web_scan_task: 0,
      import_task: 0,
      web_audit_task: 2,
      web_sploit_task: 3,
      report: 4
    }
    initialize: ->
      super      
      @setTitle 'Web App Test'
      @setDescription 'To start, choose a scan option to bring web application '+
                      'data into the project. Then, complete the required fields '+
                      'on the General tab to create a project. If you want to use '+
                      'the default settings for the scan, you can launch the scan '+
                      'immediately after you complete the required fields. However, '+
                      'to customize the scan, click on the option tabs on the left '+
                      'to enable/disable options and to configure them.'
      @setTabs [
        {name: 'General'},
        {name: 'Authentication', checkbox: true},
        {name: 'Find Vulnerabilities', checkbox: true},
        {name: 'Exploit Vulnerabilities', checkbox: true},
        {name: 'Generate Report', checkbox: true}
      ]
      @setButtons [
        {name: 'Cancel', class: 'close'},
        {name: 'Start Scan', class: 'btn primary'}
      ]
      @loadForm(QUICK_WEB_APP_SCAN_URL)
      # build some specific callbacks from a function that returns a function
      @toggleGenerateReport = @generateToggleCallback('report_enabled')
      @_toggleFindVulns = @generateToggleCallback('web_audit_enabled')
      @toggleExploitVulns = @generateToggleCallback('web_sploit_enabled')
      @toggleAuth = @generateToggleCallback('toggle_auth', 'auth_enabled')

    events: _.extend({
      'click input#tab_generate_report': 'toggleGenerateReport',
      'click input#tab_authentication': 'toggleAuth',
      'click input#tab_find_vulnerabilities': 'toggleFindVulns',
      'click input#tab_exploit_vulnerabilities': 'toggleExploitVulns',
      'change .configure_auth .radio input[type=checkbox]': 'authTypeChanged',
      'change #quick_web_app_scan_scan_type_input input': 'scanTypeChanged'
    }, TabbedModalView.prototype.events)

    scanTypeChanged: (e) =>
      $checkedInput = $('#quick_web_app_scan_scan_type_input input:checked', @$modal)
      $('#web_scan_task_urls_input,div.advanced #scan_now_advanced', @$modal)
        .toggle($checkedInput.val() == 'scan_now')
      $('#import_task_file_input,#import_file_big_header,div.advanced #import_advanced', @$modal)
        .toggle($checkedInput.val() != 'scan_now')
      $('.page.create_project a.advanced', @$modal).toggleClass('import', $checkedInput.val() != 'scan_now')

    authTypeChanged: (e) =>
      $('#basic_auth_row>div, #cookie_auth_row>div', @$modal).removeClass('disabled')
       .find(':input').removeAttr('disabled')

      if !$('#basic_auth_row input[type=checkbox]', @$modal).first().is(':checked')
        $('#basic_auth_row>div:not(:first)', @$modal).addClass('disabled')
          .find(':input').attr('disabled', 'disabled')
        if e && $(e.currentTarget).is('#basic_auth_row input[type=checkbox]')
          $('#basic_auth_row :text, #basic_auth_row :password').val('')

      if !$('#cookie_auth_row input[type=checkbox]', @$modal).first().is(':checked')
        $('#cookie_auth_row>div:not(:first)', @$modal).addClass('disabled')
          .find(':input').attr('disabled', 'disabled')
        if e && $(e.currentTarget).is('#cookie_auth_row input[type=checkbox]')
          $('#cookie_auth_row textarea').val('')
      if e
        $(e.currentTarget).parents('.cell').first().siblings().first().find(':input').focus()

    toggleFindVulns: (e) =>
      $('input#tab_exploit_vulnerabilities', @$modal).parents('li').first()
        .toggleClass('tab-click-disabled', !$(e.target).is(':checked'))
      @_toggleFindVulns.apply(this, arguments)

    # checkbox on tab for report generation
    generateToggleCallback: (name, input_name) =>
      input_name ||= name
      (e) =>
        $targ = $(e.currentTarget)
        checked = $targ.is(':checked')
        idx = $targ.parents('li').first().index()
        $page = @content().find('div.page').eq(idx)
        $('h3.enabled>span', $page).removeClass('disabled enabled')
        if checked
          $('h3.enabled>span', $page).text("enabled").addClass('enabled')
          # toggle input value for report_enabled (hidden)
          $("[name='quick_web_app_scan[#{input_name}]']", @$modal).attr('value', '1')
        else
          $('h3.enabled>span', $page).text("disabled").addClass('disabled')
          # toggle input value for report_enabled (hidden)
          $("[name='quick_web_app_scan[#{input_name}]']", @$modal).removeAttr('value')

    submitButtonClicked: =>
      $form = $('form', @$modal).first()
      $form.attr('action', QUICK_WEB_APP_SCAN_URL)
      super

    render: =>
      super
      @$modal.addClass('quick-web-app-scan-modal')

    # hook to allow mutation of form submission data
    transformFormData: ($inputs) ->
      $inputs = super
      # override the infinity signs to mean "9999999999"
      $inputs.filter("[value='#{INFINITY}']").val("#{INFINITY_DISCRETE}")
      # add the :scan_type radio button (which is outside the <form>)
      $inputs = $inputs.add($("li#quick_web_app_scan_scan_type_input input:checked", @$modal))
      $inputs

    transformErrorData: (errorsHash) ->
      # if we have a String error from WebScanTask, convert it to object 
      #  form for an inline display. This will degrade nicely if we switch hash styles.
      errorsHash = super
      ws = errorsHash.errors['web_scan_task']
      if ws == 'No valid URLs have been provided'
        errorsHash.errors['web_scan_task'] = { urls: [ws] }
      errorsHash

    # we load the form from the wicked quick_pentest_controller route
    formLoadedSuccessfully: (html) =>
      return unless @content().is(':visible')
      super
      # toggle checkbox in tab depending on this value
      if $("[name='quick_web_app_scan[report_enabled]']", @$modal).val() == "true"
        $("#tab_generate_report", @$modal).prop('checked', true)
      if $("[name='quick_web_app_scan[auth_enabled]']", @$modal).val() == "true"
        $("#tab_authentication", @$modal).prop('checked', true)
      if $("[name='quick_web_app_scan[web_audit_enabled]']", @$modal).val() == "true"
        $("#tab_find_vulnerabilities", @$modal).prop('checked', true)
      if $("[name='quick_web_app_scan[web_sploit_enabled]']", @$modal).val() == "true"
        $("#tab_exploit_vulnerabilities", @$modal).prop('checked', true)
      # only show the first div
      $('form.quick_pentest>div.page', @$el).hide().first().show()
      @authTypeChanged()
      # the FORs of the labels get set ambiguously which fucks up label clicking
      $('.report_sections,.report_options', @$modal).find('ol li label').removeAttr('for')
      # move the "Scan Now" or "Import" options to right after the label
      $('li#quick_web_app_scan_scan_type_input', @$modal).insertAfter $('h1:first', @$modal)


