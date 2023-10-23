jQueryInWindow ($) ->
  class @MaliciousFileView extends FormView

    initialize: ->
      @loadingModal = $('<div class="loading">').dialog(
        modal: true,
        title: 'Submitting... ',
        autoOpen: false,
        closeOnEscape: false
      )
      super

    onLoad: ->
      super
      $("input[name='social_engineering_user_submitted_file[name]']", @el).focus()
      $('form', @el).submit (e) -> e.preventDefault()

    renderHeader: ->
      super
      $('.header .page-circles', @el).hide()
      $('.header', @el).addClass('no-box-shadow')

    actionButtons: -> [
      [['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]
    ]

    save: ->
      # send form request over ajax, termine results
      $form = $('form', @el)
      @loadingModal.dialog('open')
      $.ajax
        url: $form.attr('action')
        type: 'POST'
        files: $(':file', $form)
        data: $('input,select,textarea', $form).not(':file').serializeArray()
        iframe: true
        processData: false
        success: (data, status) =>
          $('.content', @el).html(data)
          @loadingModal.dialog('close')
          saveStatus = $('meta[name=save-status]', @el).attr('content')
          if saveStatus == 'false' || !saveStatus
            @onLoad()
          else # success!
            jsonData = $.parseJSON(saveStatus)
            @close()
        error: =>
          @loadingModal.dialog('close')

      super
