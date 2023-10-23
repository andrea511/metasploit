(function() {

  jQuery(function($) {
    var TRUNCATE_LINK_CLASSES;
    TRUNCATE_LINK_CLASSES = ['truncate', 'more'];
    $.fn.truncate = function(opts) {
      if (opts == null) {
        opts = {};
      }
      return $(this).each(function() {
        var $more, className, lineHeight, moreLink, numLines, text, totalHeight,
          _this = this;
        opts = $.extend({}, $.fn.truncate.defaults, opts);
        text = $(this).text();
        lineHeight = parseFloat($(this).css('line-height'));
        moreLink = function() {
          return $("~a." + (TRUNCATE_LINK_CLASSES.join('.')), _this);
        };
        if (((opts.maxHeight != null) && $(this).height() > opts.maxHeight) || ((opts.maxLines != null) && $(this).height() > lineHeight * opts.maxLines) || ((opts.lines != null) && $(this).height() > lineHeight * opts.lines)) {
          className = TRUNCATE_LINK_CLASSES.join(' ');
          $more = $('<a />', {
            href: '#',
            html: opts.linkText,
            "class": className
          });
          $more.click(function(e) {
            e.preventDefault();
            if ($(_this).data('truncated')) {
              $(_this).height('auto');
              moreLink().html(opts.lessLinkText);
              return $(_this).data('truncated', false);
            } else {
              return $(_this).truncate(opts);
            }
          });
          numLines = opts.lines || opts.maxLines;
          totalHeight = (numLines && numLines * lineHeight) || opts.maxHeight;
          if (totalHeight != null) {
            $(this).height(totalHeight).css({
              overflow: 'hidden'
            });
            moreLink().remove();
            if (opts.showMore) {
              $(this).after($more);
            }
            return $(this).data('truncated', true);
          }
        } else {
          if (opts.maxLines != null) {
            $(this).height(lineHeight * opts.maxLines);
          } else {
            $(this).height('auto');
          }
          moreLink().html(opts.lessLinkText);
          return $(this).data('truncated', false);
        }
      });
    };
    return $.fn.truncate.defaults = {
      maxLines: 3,
      maxHeight: null,
      linkText: 'more&hellip;',
      lessLinkText: 'less&hellip;',
      showMore: true
    };
  });

}).call(this);
