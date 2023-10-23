jQueryInWindow ($) ->
  class @WebTemplateView extends FormView
    initialize: ->
      @loadingModal = $('<div class="loading">').dialog(
        modal: true, 
        title: 'Submitting...',
        autoOpen: false,
        closeOnEscape: false
      )
      super

    onLoad: ->
      super
      $('select>option', @el).each -> $(@).removeAttr('value') if $(@).val() == ''
      $('select', @el).select2(DEFAULT_SELECT2_OPTS)
      window.renderAttributeDropdown()
      window.renderCodeMirror(220)
      $('a.clone-btn', @el).click(window.renderCloneDialog)

    actionButtons: -> [
      [['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]
    ]

    save: ->
      # send form request over ajax, termine results
      @loadingModal.dialog('open')
      $form = $('form', @el)
      Placeholders.submitHandler($form[0]) # resolve any placeholder polyfills from being submitted
      $('textarea.to-code-mirror', $form).trigger 'loadFromEditor'
      $form.trigger('syncWysiwyg')
      $.ajax(
        url: $form.attr('action'),
        type: $form.attr('method'),
        data: $form.serialize(),
        success: (data) => # data is the new CampaignSummary object
          @render()
          @close(confirm: false)
          @loadingModal.dialog('close')
        error: (response) =>
          $('.content-frame>.content', @el).html(response.responseText)
          @onLoad()
          @loadingModal.dialog('close')
      )
      super