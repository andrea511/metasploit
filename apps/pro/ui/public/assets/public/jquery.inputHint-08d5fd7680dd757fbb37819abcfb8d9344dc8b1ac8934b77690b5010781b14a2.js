(function() {

  jQuery(function($) {
    return $(function() {
      return $.fn.inputHint = function(options) {
        this.each(function() {
          var $placeholderDiv, $rightSpan, $this, title, update, _input, _ph;
          options = $.extend({
            fadeOutSpeed: 200,
            fontFamily: 'Helvetica, Arial, sans-serif',
            fontSize: '12px',
            hintColor: '#888'
          }, options);
          $this = $(this);
          title = $this.attr('title');
          title || (title = $this.attr('placeholder'));
          if ("placeholder" in document.createElement("input")) {
            return $this.attr('placeholder', title);
          } else {
            $rightSpan = $('<span></span>').insertAfter($this).css({
              position: 'relative',
              display: 'inline-block',
              verticalAlign: 'top'
            });
            $placeholderDiv = $('<div>' + title + '</div>').hide().css({
              position: 'absolute',
              top: '3px',
              textAlign: 'left',
              right: '3px',
              width: $this.css('width'),
              height: $this.css('height'),
              color: options.hintColor,
              fontSize: options.fontSize,
              fontFamily: options.fontFamily
            });
            $rightSpan.html($placeholderDiv);
            _input = this;
            _ph = $placeholderDiv.eq(0);
            $placeholderDiv.click(function(e) {
              return $(_input).focus();
            });
            $this.focus(function(e) {
              return $(_ph).fadeOut(options.fadeOutSpeed);
            });
            update = function(e) {
              if (!$this.val() || $this.val() === '') {
                return $(_ph).fadeIn(options.fadeOutSpeed);
              } else {
                return $(_ph).fadeOut(options.fadeOutSpeed);
              }
            };
            $this.blur(update);
            $this.change(update);
            return $this.blur();
          }
        });
        return this;
      };
    });
  });

}).call(this);
