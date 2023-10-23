$ = jQuery

$ ->

  # Initialize the tag creation dialog.
  $tagDialog = $('#tag-dialog')

  $tagDialog.dialog
    title:     "Tag Hosts"
    width:     430
    height:    350
    buttons:
      "Tag": ->
        $('#tag-form').submit()

    autoOpen: false
    open: (e, ui) ->
      # Enable tokenized input for tag searching.
      wid = @workspace_id || window.WORKSPACE_ID
      tagSearchPath = Routes.search_workspace_tags_path(wid, format: 'json')
      tokenInputOptions =
        "theme": "metasploit"
        "hintText": "Type in a tag name..."
        "searchingText": "Searching tags..."
        "allowCustomEntry": true
        "preventDuplicates": true
        "allowFreeTagging": true

      # Enable and pre-populate (if necessary) the token input
      $tokenInput  = $('#new_host_tags')
      $checkedRows = $("table.list tbody tr td input[type='checkbox']").filter(':checked').parents('tr')

      # Don't reinitialize the input.
      unless $tokenInput.data('tokenInputObject')
        $tokenInput.tokenInput tagSearchPath, tokenInputOptions

      $tokenInput.tokenInput 'clear'

      # If only one host is selected, load up its tags so we can edit them.
      if $checkedRows.size() == 1
        $checkedRows
          .children('td')
          .find('.tag').each ->
            name = $(@).children('span.tag-name').html()
            id   = parseInt $(@).children('span.tag-id').html()
            $tokenInput.tokenInput "add", {name, id}
      e.preventDefault()

  # Open the tagging dialog when the tag button is clicked.
  $(document).on 'click','span.button a:contains(Tag)', (e) ->
    unless $(@).parent().hasClass 'disabled'
      $tagDialog.find('.error-container').html('')
      $tagDialog.dialog('open')
      $checkedHosts = $("table.list tbody tr td input[type='checkbox']").filter(':checked')
      if $checkedHosts.size() == 1
        $tagDialog.dialog 'option', 'title', 'Edit Tags'
      else
        $tagDialog.dialog 'option', 'title', 'Tag Hosts'
      # Make the help text appear.
      $('ul.token-input-list-facebook').click()
    e.preventDefault()

  # Submit the tagging data when the dialog button is clicked.
  $('#tag-form').submit (e) ->
    action = $(@).attr('action')
    $.ajax
      url  : action,
      type : 'POST',
      data : $('#tag-form, #table-form').serialize(),
      success : ->
        $tagDialog.dialog('close')
        $('table.list').data('dataTableObject').fnDraw()
        $("table.list thead tr th input[type='checkbox']").attr('checked', false)
        #$('#flash_messages').html "<div class='flash notice'>#{result.responseText}"
      error: (result) ->
        $('.error-container').html "<div class='flash errors'>#{result.responseText}</div>"

    e.preventDefault()
    false

  # Change the tagging icon based on the number of checkboxes selected.
  $(document).on 'change',"table.sortable tbody tr td input[type='checkbox'].hosts", ->
    $tagButton = $('span.button a:contains(Tag)')
    numChecked = $("table.sortable tbody tr td input[type='checkbox'].hosts").
      filter(':checked').size()
    switch numChecked
      when 0
        $tagButton.removeClass 'tag-edit tag-add'
        $tagButton.addClass    'tag-edit'
      when 1
        $tagButton.removeClass 'tag-edit tag-add'
        $tagButton.addClass    'tag-edit'
      else
        $tagButton.removeClass 'tag-edit tag-add'
        $tagButton.addClass    'tag-add'
