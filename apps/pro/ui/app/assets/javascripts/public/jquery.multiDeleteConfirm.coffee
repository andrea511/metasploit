jQuery ($) ->
  $.multiDeleteConfirm = 
    defaults:
      pluralObjectName: 'objects'

    bind: ($button, $table, options) ->
      # Button should confirm deletion and verify that items have
      # been selected.
      $button.on 'click', null, (e) ->
        if $table.find("input[type=checkbox]").filter(':checked').size() > 0
          return confirm("Are you sure you want to delete the selected #{options.pluralObjectName}?")
        else
          alert("Please select #{options.pluralObjectName} to be deleted.")
          e.preventDefault()

  $.fn.multiDeleteConfirm = (options) ->
    settings = $.extend {}, $.multiDeleteConfirm.defaults, options, true
    $button  = $(this)
    $table   = $(settings.tableSelector)

    return this.each -> $.multiDeleteConfirm.bind($button, $table, settings)
