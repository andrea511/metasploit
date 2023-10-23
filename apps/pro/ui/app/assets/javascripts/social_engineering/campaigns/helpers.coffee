window.Helpers = {

  # truncate cuts a string off at the given limit and adds
  # ellipses where necessary
  # @param String string the string to truncate
  # @param Integer limit the maximum number of characters the string
  #   can contain before it is truncated and appended with an ellipses
  # @return the modified string

  truncate: (string, limit) ->
    if string.length > limit # trim the string
      string.substring(0, limit).replace(/[\s+]$/g, '') + '...'
    else
      string

}