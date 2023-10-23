define ['jquery'], ($) ->

  # Based on: http://stackoverflow.com/a/7138971
  # Jquery helper method that returns true if a div with "overflow:hidden" is
  # larger than its height constraints.
  $.fn.hasOverflowedHeight = ->
    el = $(@[0])
    if el.css("overflow") is "hidden"
      text = el.html()
      t = $(el[0].cloneNode(true))
        .hide()
        .css("position", "absolute")
        .css("overflow", "visible")
        .height("auto")
        .width(el.width())
      el.after(t)
      ret = t.height() > el.height()
      t.remove()
      ret
    else
      throw new Error("Element must have overflow:hidden to use isOverflowHeight")
