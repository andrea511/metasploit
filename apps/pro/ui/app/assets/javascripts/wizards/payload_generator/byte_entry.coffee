#
# The ByteEntry jQuery plugin installs a smart "byte"
# input handler that only allows hexadecimal input.
# Additionally, some logic is added to format pasted bytes
# into the accepted hex format.
#

$ = jQuery # only effects our scope

$.fn.ByteEntry = ->

  BACKSPACE_KEY = 8

  # these keys do NOT trigger the onchange re-formatting behavior
  PASSTHRU_KEYS = [
    BACKSPACE_KEY,
    0,  # nothing
    46, # delete
    37, # arrow
    38, # arrow
    39, # arrow
    40 # arrow
  ]

  lastKey = null

  fixFormatting = (str='') ->
    str = str.toLowerCase().replace(/\s+/g, '').replace(/[^0-9a-f]/g, '')
    parts = _.chain(str.split(''))
      .groupBy((k,i) -> Math.floor(i/2.0))
      .map(([a,b]) -> a+(b||''))
      # .uniq()
      .value()
      .join(" ")
    parts += ' ' if parts.match(/\w\w$/) and lastKey isnt BACKSPACE_KEY
    parts

  @css('font-family', 'monospace')
  @attr('spellcheck', false)

  # Prevent special keys from being pressed
  @keypress (e) ->
    return if _.contains(PASSTHRU_KEYS, e.which) # bail on backspace
    char = String.fromCharCode(e.which).toLowerCase()
    code = char.charCodeAt(0)
    if char and char.length and (code < '0'.charCodeAt(0) or code > 'f'.charCodeAt(0))
      
      e.preventDefault()
      e.stopImmediatePropagation()
      return false

  # Fix up any added text
  onChange = (e) ->
    lastKey = e.which || lastKey
    _.defer =>
      initVal  = $(@).val()
      fixedVal = fixFormatting(initVal)
      $(@).val(fixedVal) unless initVal is fixedVal

  @change(onChange)
  @keyup(onChange)
