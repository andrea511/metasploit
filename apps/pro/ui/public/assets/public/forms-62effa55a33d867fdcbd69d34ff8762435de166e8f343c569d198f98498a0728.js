(function() {
  var $, ARROW_PAD_LEFT, HelpLinks, WAIT_TO_CHANGE_DOM;

  $ = jQuery;

  WAIT_TO_CHANGE_DOM = 350;

  ARROW_PAD_LEFT = 103;

  window.Forms = {
    autoFocus: function() {
      return $('form.formtastic input:visible, form.formtastic textarea:visible').first().focus();
    },
    disableSubmit: function() {
      var $form;
      $form = $('form.formtastic');
      $form.find('input[type=submit]').click(function() {
        return $(this).addClass('submitting').addClass('disabled');
      });
      return $form.bind("formSubmitted", function() {
        return $form.find('input[type=submit]').removeClass('submitting').removeClass('disabled');
      });
    },
    bind: function() {
      this.autoFocus();
      return this.disableSubmit();
    },
    renderHelpLinks: function(scope) {
      var hideAllHelp, inlineClick;
      if (scope == null) {
        scope = null;
      }
      $('.inline-help', scope).each(function() {
        var $helpLink, $newHelpLink, $targetLi;
        $helpLink = $(this).children('a');
        $targetLi = $("#" + ($helpLink.data('field')), scope);
        if ($targetLi.length < 1) {
          $targetLi = $(this).parents('li').first();
        }
        $targetLi.append($helpLink.clone());
        $newHelpLink = $targetLi.children('a');
        $helpLink.remove();
        if ($(this).find('div.wrap').length === 0) {
          $(this).wrapInner('<div class="wrap" />');
          $(this).find('h3').each(function() {
            return $(this).nextUntil('h3').wrapAll($('<div/>', {
              'class': 'content'
            }));
          });
        }
        if ($(this).find('div.arrow').length === 0) {
          return $(this).prepend("<div class='arrow' />");
        }
      });
      hideAllHelp = function(notClause) {
        return $('.inline-help:visible').not(notClause).fadeOut().each(function() {
          var _this = this;
          return setTimeout((function() {
            return $(_this).appendTo($(_this).data('old_parent'));
          }), ARROW_PAD_LEFT);
        });
      };
      inlineClick = function(e) {
        var $helpDiv, arrowShift, left, pos, real_left, width,
          _this = this;
        if ($(e.currentTarget).data('showing')) {
          return;
        }
        $(e.currentTarget).data('showing', true);
        _.defer((function() {
          return $(e.currentTarget).data('showing', false);
        }), 300);
        if (e) {
          e.preventDefault();
        }
        pos = $(this).offset();
        width = $(this).width();
        $helpDiv = $(HelpLinks.helpDivSelector($(this).data('field')));
        hideAllHelp($helpDiv);
        $('body').unbind('click.reset-help');
        if ($helpDiv.is(':visible')) {
          $helpDiv.fadeOut();
          return setTimeout((function() {
            return $helpDiv.appendTo($helpDiv.data('old_parent'));
          }), ARROW_PAD_LEFT);
        } else {
          $helpDiv.data('old_parent', $helpDiv.parent().first());
          $helpDiv.appendTo($('body'));
          arrowShift = $helpDiv.width() - ARROW_PAD_LEFT;
          left = pos.left - arrowShift;
          real_left = left < 10 ? 10 : left;
          $('.arrow', $helpDiv).css({
            right: (78 + real_left - left) + 'px'
          });
          $helpDiv.css("left", "" + real_left + "px");
          $helpDiv.css("top", "" + (pos.top + 20) + "px");
          $helpDiv.fadeIn();
          return window.setTimeout(function() {
            return $('body').bind('click.reset-help', function(e) {
              if ($(e.target).parents('a.help').length || $(e.target).parents('inline-help').length) {
                return;
              }
              $('body').unbind('click.reset-help');
              $helpDiv.fadeOut();
              setTimeout((function() {
                return $helpDiv.appendTo($helpDiv.data('old_parent'));
              }), ARROW_PAD_LEFT);
              return e.preventDefault();
            });
          });
        }
      };
      $('a.help', scope).click(inlineClick);
      $('a.help', scope).mouseover(function() {
        return $(this).find('img').attr('src', '/assets/icons/silky/information_hover-14a9d682776bb882f5a94d77a6503aa1e2ad652adfe979d5790e09b4ba9930fe.png');
      });
      return $('a.help', scope).mouseout(function() {
        return $(this).find('img').attr('src', '/assets/icons/silky/information-c0210a97250ec34cc04d6c8ff768012bf9e054abe33c7fcc558f65bf57a1661a.png');
      });
    }
  };

  HelpLinks = {
    helpDivSelector: function(fieldKey) {
      return ".inline-help[data-field=\"" + fieldKey + "\"]";
    }
  };

  $(document).ready(function() {
    $(document).on('click', 'a#advanced-options', function(e) {
      if ($(this).hasClass('show-advanced-options')) {
        $(this).html("Hide Advanced Options");
        $(this).removeClass('show-advanced-options');
        $(this).addClass('hide-advanced-options');
        $('.advanced').slideDown('fast');
      } else {
        $(this).html("Show Advanced Options");
        $(this).removeClass('hide-advanced-options');
        $(this).addClass('show-advanced-options');
        $('.advanced').slideUp('fast');
      }
      e.stopImmediatePropagation();
      return e.preventDefault();
    });
    Forms.renderHelpLinks();
    return Forms.bind();
  });

}).call(this);
