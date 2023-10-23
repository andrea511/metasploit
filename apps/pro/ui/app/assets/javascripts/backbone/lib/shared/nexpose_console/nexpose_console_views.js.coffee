define [
  'jquery'
  'base_layout'
  'base_compositeview'
  'base_itemview'
  'lib/shared/nexpose_console/templates/form'
], ($) ->
  @Pro.module "Shared.NexposeConsole", (NexposeConsole, App) ->
    #
    # Nexpose Console Form
    #
    class NexposeConsole.Form extends App.Views.ItemView

      template: @::templatePath "nexpose_console/form"

      toggleConnectionStatus: (connection_success) ->
        $('.connectivity .connection_success', @el).toggle(connection_success)
        $('.connectivity .connection_error', @el).toggle(!connection_success)

      ##TODO: Make into concern
      clearErrors: () ->
        $('.error', @el).removeClass('error')
        $('p.inline-error', @el).remove()

      showErrors: (errors) =>
        @clearErrors()
        _.each errors, (v, k) =>
          $input = $("[name*='[#{k}]']", @el)
          $input.parents('li').first().addClass('error')
          $input.parent().append(@_errorDiv(v))

      # @return an initialized DOMElement containing a <p> with error message
      _errorDiv: (msg) => $('<p />', class: 'inline-error').text(msg)

      setLoading: (loading) =>
        $(@el).toggleClass('tab-loading', loading)
        # hide the other elements
        if loading
          $('>*', @el).css(opacity: 0.2, 'pointer-events': 'none')
        else
          $('>*', @el).css(opacity: 1, 'pointer-events': 'auto')