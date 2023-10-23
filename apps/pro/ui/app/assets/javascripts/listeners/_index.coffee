$ = jQuery

$(document).ready ->
  $table      = $('table#listener_list')
  $checkboxes = $table.find('[type=checkbox]')
  $checkboxes.change ->
    any = $checkboxes.filter(':checked').length > 0
    $('#listener-delete-submit').parent().toggleClass('disabled', !any)
    true

  $checkboxes.change()

  $table.find('td.toggle').click (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()
    return if $(e.target).hasClass('disabled')
    return unless confirm($(e.target).attr('data-confirm'))
    $(e.target).addClass('disabled')
    $.ajax
      url: $(e.target).attr('href')
      type: 'POST'
      success: -> location.reload(true)
