$ = jQuery

$(document).ready ->
  $(document).on 'click','a.reveal', (e) ->
    $dialog = $('<div style="display:hidden"></div>').appendTo('body')
    $dialog.load $(this).parent().parent().attr('rurl'), { 'id': $(this).parent().parent().attr('rid')}, (responseText, textStatus, xhrRequest) =>
      $dialog.dialog
        title: "Unobfuscated API Key"
        height: 100
        width: 300
    e.preventDefault()

$(document).ready ->
  $table      = $('table#api_key_list')
  $checkboxes = $table.find('[type=checkbox]')
  $checkboxes.change ->
    any = $checkboxes.filter(':checked').length > 0
    $('#api_key_delete').parent().toggleClass('disabled', !any)
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