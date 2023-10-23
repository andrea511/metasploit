jQuery ($) ->
  $(document).ready ->
    # prevent navigation to #
    $('span.btn a').click (e) -> e.preventDefault() if $(@).attr('href') == '#'

    # Switch between expanded/collapsed view for buttons.
    switchButton= ($button) ->
      if $button.hasClass 'expanded'
        $button.removeClass 'expanded'
        $button.addClass 'collapsed'
      else
        $button.removeClass 'collapsed'
        $button.addClass 'expanded'

    topBarPresent = $('#dashboard-expander').size() > 0

    # Expand/collapse sections on arrow button click.
    $('#dashboard-expander').parent().click ->
      $('#dashboard-content').slideToggle()
      switchButton($(this).find('#dashboard-expander'))
    $('#overview-expander').parent().click ->
      return unless topBarPresent
      $('form.overview').slideToggle()
      switchButton($(this).find('#overview-expander'))

    unless topBarPresent
      $('#overview-expander').hide().parent().css(cursor: 'default')
