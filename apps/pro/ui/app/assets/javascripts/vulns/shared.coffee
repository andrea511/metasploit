jQuery ($) ->
  $(document).ready ->
    # Clone the references tr html to use when adding more refs.
    cloneReferenceFields = ->
      $('#references tr:last')
        .clone()
        .css('display', 'none')
        .appendTo('#references tbody')
    cloneReferenceFields()

    # Add Reference button should add fields to the refs table.
    $('#add-reference').click (e) ->
      cloneReferenceFields()
      $('#references tr').eq(-2).show()
      e.preventDefault()

    # Delete links should remove rows from References table.
    $('td.delete a').on 'click', null, (e) ->
      $(this).parents('tr').remove()
      e.preventDefault()

