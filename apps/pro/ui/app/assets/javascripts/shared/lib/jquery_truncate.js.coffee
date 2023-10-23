# Adds a jQuery function called #truncate()
# This checks the matching elements' heights against a set maxHeight,
#  maxLines, or lines option. If the element is too tall, its height
#  is truncated and a More... link is optionally shown.

jQuery ($) ->
  TRUNCATE_LINK_CLASSES = ['truncate', 'more'] # applied to the More... link

  $.fn.truncate = (opts={}) ->
    $(@).each ->
      opts = $.extend({}, $.fn.truncate.defaults, opts)
      text  = $(@).text()
      lineHeight = parseFloat($(@).css('line-height'))

      moreLink = =>
        $("~a.#{TRUNCATE_LINK_CLASSES.join('.')}", @)

      if (opts.maxHeight? and $(@).height() > opts.maxHeight) or
         (opts.maxLines? and $(@).height() > lineHeight*opts.maxLines) or
         (opts.lines? and $(@).height() > lineHeight*opts.lines)
        # truncate the text and show a More... link
        className = TRUNCATE_LINK_CLASSES.join(' ')
        $more = $('<a />', href: '#', html: opts.linkText, class: className)
        $more.click (e) =>
          e.preventDefault()
          if $(@).data('truncated')
            $(@).height('auto')
            moreLink().html(opts.lessLinkText)
            $(@).data('truncated', false)
          else
            $(@).truncate(opts)

        numLines = opts.lines || opts.maxLines
        totalHeight = (numLines && numLines*lineHeight) || opts.maxHeight
        if totalHeight?
          $(@).height(totalHeight).css(overflow: 'hidden')
          moreLink().remove()
          $(@).after($more) if opts.showMore
          $(@).data('truncated', true)
      else
        # show all text and remove any More... links
        if opts.maxLines?
          $(@).height(lineHeight*opts.maxLines)
        else
          $(@).height('auto')
        moreLink().html(opts.lessLinkText)
        $(@).data('truncated', false)

  $.fn.truncate.defaults = {
    maxLines: 3,
    maxHeight: null,
    linkText: 'more&hellip;',
    lessLinkText: 'less&hellip;',
    showMore: true
  }
