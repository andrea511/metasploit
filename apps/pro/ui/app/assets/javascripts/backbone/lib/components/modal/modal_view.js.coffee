define [
  'jquery'
  'base_layout'
  'base_itemview'
  'lib/components/modal/templates/modal'
], ($) ->
  @Pro.module "Components.Modal", (Modal, App) ->

    #
    # Contains the modal and modal content region
    #
    class Modal.ModalLayout extends App.Views.Layout
      @MODAL_CONFIRM_MSG: 'Are you sure you want to close this panel? Any text input will be lost.'

      template: @::templatePath "modal/modal"

      ui:
        showAgainOption: '[name="showOnce"]'

      regions:
        content: '.content'
        buttons: '.modal-actions'

      events:
        'click .header a.close, .modal-actions a.close': '_manualClose'

      triggers:
        'click a.btn.primary' : 'primaryClicked'

      #
      # Centers modal on the screen
      #
      center: =>
        offset = if @model.get('showAgainOption')? then 133 else 113
        $modal = $('.modal',@$el).first()
        modalWidth = @model.get('width') || $modal.width()
        modalHeight = @model.get('height') || $modal.height()
        screenWidth = $(window).width()
        $modal.width(@model.get('width')) if @model.get('width')
        if @model.get('height')
          $modal.height(@model.get('height'))
          $modal.find('.content').height(@model.get('height') - offset)
        $modal.css('left', parseInt(($(window).width()-modalWidth)/2)+'px')
        $modal.css('top', parseInt(($(window).height()-modalHeight)/2)+'px')
        $('ul.tabs>li:first-child', @el).addClass('first-child')
        $('.content', @el).css('border','none') if @model.get('hideBorder')
        $('.content', @el).hide() if @model.get('hideContent')

      #
      # When view is shown unbind and re-bind events
      #
      onShow: ->
        @origConfirm = window.confirm
        @_unbindWindow()
        @_bindWindow()

      #
      # closes the modal
      # @param e [event] the event
      onDestroy: () ->
        if @model.get('showAgainOption')? and @ui.showAgainOption.prop('checked')
          localStorage.setItem(@model.get('title'),false)
        @_unbindWindow()


      #
      # Binds the escape key and center events
      # must put window-level binds here, since it is out of scope of the actual view
      #
      _bindWindow: =>
        window.origConfirm ||= window.confirm
        $(window).bind('resize.tabbedModal', @center)
        $(window).bind('keyup.modal', @_escKeyHandler)

      #
      # Unbinds the escape key and center events
      # must put window-level unbinds here, since it is out of scope of the actual view
      #
      _unbindWindow: =>
        window.confirm = @origConfirm
        $(window).unbind('resize.tabbedModal', @center)
        $(window).unbind('keyup.modal', @_escKeyHandler)

      #
      # Close modal on escape event. Display confirm dialog window if modal has been edited
      # @param e [event] the key event
      #
      _escKeyHandler: (e) =>
        if String.fromCharCode(e.keyCode)?.match(/[\w]+/)?.length > 0
          @_edited = true
        if e.keyCode == 27
          if @_edited
            @destroy() if window.confirm(Modal.MODAL_CONFIRM_MSG)
          else
            @destroy()
          e.preventDefault()
          e.stopImmediatePropagation()

      #
      # Close the modal if user manually clicked close button and destroy views
      #
      _manualClose: () ->
        @trigger('closeClicked')
        @destroy()
