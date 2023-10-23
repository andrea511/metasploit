define [], ->
  @Pro.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->

    Concerns.TextAreaLimit =

      _bindTextArea: ($elem,maxRows,modalView,model) ->
        $elem.on 'input', (e) =>
          @_textEnteredHandler(e,maxRows,modalView,model)

      _unbindTextArea: ($elem) ->
        $elem.off('input')

      _textEnteredHandler: (e,maxRows,modalView,model) ->
        text = $(e.target).val()
        lines = text.split('\n')

        if lines.length > 100
          @_truncateTextArea($(e.target),maxRows,lines)
          if modalView
            @_showLimitModal(modalView,model)

      _truncateTextArea: ($elem,maxRows,lines) ->
        buffer = ''

        for index in [0..98]
          buffer = buffer.concat("#{lines[index]}\n")
        buffer = buffer.concat("#{lines[index]}")
        $elem.val(buffer)
        $elem.trigger('keyup')

      _showLimitModal: (View,model) ->
        view = new View(model:model)

        App.execute 'showModal', view,
          modal:
            title: ''
            description: ''
            width:200
            height:200
          buttons: [
            {name :'OK', class: 'btn primary'}
          ]
          loading: false













