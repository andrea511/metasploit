$ = jQuery

$(document).ready ->
 # Module delete button should confirm deletion and verify that modules have
  # been selected.
  $('#macro-delete-submit').multiDeleteConfirm
    tableSelector:    '#macro_list'
    pluralObjectName: 'macros'

$(document).ready ->
  $table      = $('table#macro_list')
  $checkboxes = $table.find('[type=checkbox]')
  $checkboxes.change ->
    any = $checkboxes.filter(':checked').length > 0
    $('#macro-delete-submit').parent().toggleClass('disabled', !any)
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