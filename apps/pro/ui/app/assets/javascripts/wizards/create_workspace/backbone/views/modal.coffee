jQueryInWindow ($) ->
  WORKSPACE_CREATE_URL = '/workspaces.json'
  class @CreateWorkspaceModal extends @TabbedModalView
    _modelsToTabs: {
      workspace: 0
    }

    initialize: ->
      super
      @setTitle 'Create Project'
      @setDescription ''
      @setTabs [ 
        {name: "Create Project"}
      ]
      @setButtons [
        {name: 'Cancel', class: 'close'},
        {name: 'Next', class: 'btn primary'}
      ]
      # this is a tiny form, so lets load it on-the-fly from
      #  an inline template. We have to defer() this call
      #  because the actual form gets rendered in open()
      _.defer => @formLoadedSuccessfully(@formTemplate(this))

    formTemplate: _.template($('#create-workspace-form').html())
    someInputChanged:(e) =>
      if(event.keyCode == 13)
        e.preventDefault()
        @submitButtonClicked(e)
      else
        super(e)

    submitButtonClicked: (e) =>
      e.preventDefault()
      @resetErrors()
      helpers.showLoadingDialog()
      formData = $('form', @$modal).serialize()
      $.ajax(
        url: WORKSPACE_CREATE_URL
        type: 'POST'
        dataType: 'json'
        data: _.extend(formData, {'_method': 'CREATE'})
        success: @workspaceSaved
        error: (e) =>
          data = $.parseJSON(e.responseText)
          helpers.hideLoadingDialog()
          @handleErrors({ errors: { workspace: data.errors } })
          $('.modal-actions a.btn.primary', @$modal).addClass('disabled')
          $('.modal-actions a.close', @$modal).removeClass('ui-disabled')
      )

    workspaceSaved: (data) =>
      window.location = data.path

    render: =>
      super
      @$modal.addClass('create-project-modal')

  class @QuickPhishModal extends @CreateWorkspaceModal
    initialize: ->
      super
      @setTitle 'Phishing Campaign'
      @setDescription 'First, create a project to store the phishing campaign. '+
                      'Then, click the Next button to launch the phishing campaign '+
                      'configuration page.'

    workspaceSaved: (data) =>
      window.location = data.path+'/social_engineering/campaigns'
