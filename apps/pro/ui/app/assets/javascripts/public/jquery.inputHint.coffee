# jquery.inputHint: an input placeholder plug-in that utilizes HTML5's placeholder.
#   Usage: $('input.myinput').inputHint({..options..});
#   Options: fadeOutSpeed, fontFamily, fontSize, fontStyle, hintColor
# TODO XXX: remove since obsolete with placeholder attribute
jQuery ($) ->
  $ ->
    $.fn.inputHint = (options) ->
      this.each ->
        options = $.extend {
            fadeOutSpeed: 200
            fontFamily: 'Helvetica, Arial, sans-serif'
            fontSize: '12px'
            hintColor: '#888'
          }, options
        $this = $(this)
        title = $this.attr('title')
        title or= $this.attr('placeholder')

        # Use HTML5 placeholders, if they're supported.
        # TODO: Not sure how to do this in CoffeeScript.
        if "placeholder" of document.createElement("input")
          $this.attr('placeholder', title)
        else
          # Otherwise, simulate a placeholder using relative+absolute positioning
          # insert a rightSpan next to the input, and insert an absolute div on top of that
          $rightSpan = $('<span></span>').insertAfter($this).css(position: 'relative', display: 'inline-block', verticalAlign: 'top')
          $placeholderDiv = $('<div>'+title+'</div>').hide().css
            position: 'absolute'
            top: '3px'
            textAlign: 'left'
            right: '3px'
            width: $this.css('width')
            height: $this.css('height')
            color: options.hintColor
            fontSize: options.fontSize
            fontFamily: options.fontFamily
          $rightSpan.html($placeholderDiv)

          # set up events
          _input = this
          _ph = $placeholderDiv.eq(0)
          $placeholderDiv.click (e) ->
            $(_input).focus()

          $this.focus (e) ->
            $(_ph).fadeOut(options.fadeOutSpeed)

          # update shows/hides text depending on value
          update = (e) ->
            if !$this.val() || $this.val() == ''
              $(_ph).fadeIn(options.fadeOutSpeed)
            else
              $(_ph).fadeOut(options.fadeOutSpeed)

          $this.blur(update)
          $this.change(update)
          $this.blur() # trigger showing/hiding the text on content load.
      this
