(function() {
  var m, re, _ref, _ref1;

  window.jQueryInWindow = function(func) {
    return func.call(window, jQuery);
  };

  if (top.location !== self.location) {
    top.location = self.location.href;
  }

  re = /\/(\w+)\/(\d+)/g;

  while (m = re.exec(window.location.href)) {
    window[m[1].toUpperCase().replace(/s$/i, '') + '_ID'] = parseInt(m[2]);
  }

  if ((_ref = window.HOST_ID) == null) {
    window.HOST_ID = null;
  }

  if ((_ref1 = window.WORKSPACE_ID) == null) {
    window.WORKSPACE_ID = null;
  }

  jQuery(function($) {
    var _base, _ref2, _ref3;
    window.WORKSPACE_ID || (window.WORKSPACE_ID = $('meta[name=workspace_id]').attr('content'));
    $.fn.addDisableOverlay = function(supportedProducts) {
      var $disabledOverlay, $mainContent;
      $disabledOverlay = $('.body-disabled-overlay');
      $mainContent = $('.mainContent');
      if ($disabledOverlay.height() < $mainContent.height()) {
        $disabledOverlay.css({
          height: $mainContent.height() - 20
        });
      }
      $disabledOverlay.find('span.products').html("<a href='" + ($('span.registration-url').html()) + "'>register for the free " + supportedProducts + " trial</a>");
      return $disabledOverlay.removeClass('invisible');
    };
    $.fn.removeDisableOverlay = function(supportedProducts) {
      var $disabledOverlay;
      $disabledOverlay = $('.body-disabled-overlay');
      return $disabledOverlay.addClass('invisible');
    };
    $.fn.toggleVisibility = function($elem) {
      return $(this).on('click', null, function(e) {
        if ($(this).prop('checked')) {
          return $elem.show();
        } else {
          return $elem.hide();
        }
      });
    };
    $.fn.checkAll = function($elem) {
      var $checkboxes, setAllCheckboxState,
        _this = this;
      $checkboxes = $elem.find('input[type=checkbox]');
      setAllCheckboxState = function() {
        var $uncheckedCheckboxes;
        $uncheckedCheckboxes = $elem.find('input[type=checkbox]:not(:checked)');
        if ($uncheckedCheckboxes.length > 0) {
          return $(_this).prop('checked', false);
        } else {
          return $(_this).prop('checked', true);
        }
      };
      setAllCheckboxState();
      $(this).on('click', null, function(e) {
        if ($(this).prop('checked')) {
          return $checkboxes.prop('checked', true);
        } else {
          return $checkboxes.prop('checked', false);
        }
      });
      return $checkboxes.on('click', null, function(e) {
        return setAllCheckboxState();
      });
    };
    (_base = $.expr[':']).focus || (_base.focus = function(elem) {
      return elem === document.activeElement && (elem.type || elem.href);
    });
    if ((_ref2 = $.fn.dataTableExt) != null) {
      _ref2.oPagination.r7Style = {
        fnInit: function(oSettings, nPaging, fnCallbackDraw) {
          var $curr, $first, $last, $next, $p, $prev, btnEvent;
          $p = $(nPaging).html('');
          $first = $('<span />', {
            "class": 'btn first'
          }).attr('title', 'First').appendTo($p);
          $prev = $('<span />', {
            "class": 'btn prev'
          }).attr('title', 'Previous').appendTo($p);
          $curr = $('<input />', {
            "class": 'curr'
          }).attr('title', 'Current page').appendTo($p);
          $next = $('<span />', {
            "class": 'btn next'
          }).attr('title', 'Next').appendTo($p);
          $last = $('<span />', {
            "class": 'btn last'
          }).attr('title', 'Last').appendTo($p);
          btnEvent = function(evtName) {
            return function(e) {
              if ($(e.currentTarget).hasClass('disabled')) {
                return;
              }
              oSettings.oApi._fnPageChange(oSettings, evtName);
              return fnCallbackDraw(oSettings);
            };
          };
          $first.click(btnEvent('first'));
          $prev.click(btnEvent('previous'));
          $next.click(btnEvent('next'));
          $last.click(btnEvent('last'));
          $curr.change(function() {
            var page;
            page = Math.ceil(oSettings._iDisplayStart / oSettings._iDisplayLength) + 1;
            if ($curr.val() !== page.toString() && ($curr.val() - 1) * oSettings._iDisplayLength < oSettings.fnRecordsTotal()) {
              oSettings._iDisplayStart = ($curr.val() - 1) * oSettings._iDisplayLength;
            }
            return oSettings.oInstance.fnDraw(false);
          });
          $curr.val(1);
          return $.extend(oSettings.oLanguage, {
            sLengthMenu: 'Show _MENU_',
            sInfo: "Showing _START_ - _END_ of _TOTAL_"
          });
        },
        fnUpdate: function(oSettings, fnCallbackDraw) {
          var $first, $last, $next, $prev, div, firstPage, lastPage, page;
          page = Math.ceil(oSettings._iDisplayStart / oSettings._iDisplayLength) + 1;
          lastPage = oSettings.fnDisplayEnd() >= oSettings.fnRecordsTotal();
          firstPage = page === 1;
          div = oSettings.aanFeatures.p;
          $first = $('span.first', div).toggleClass('disabled', firstPage);
          $prev = $('span.prev', div).toggleClass('disabled', firstPage);
          $next = $('span.next', div).toggleClass('disabled', lastPage);
          $last = $('span.last', div).toggleClass('disabled', lastPage);
          return $('input.curr', oSettings.aanFeatures.p).val(page).toggleClass('disabled', firstPage && lastPage).prop('disabled', firstPage && lastPage);
        }
      };
    }
    $.extend((_ref3 = $.fn.dataTable) != null ? _ref3.defaults : void 0, {
      sPaginationType: 'r7Style'
    });
    $.extend($.ui.tooltip.prototype.options, {
      position: {
        using: function(position, feedback) {
          var left, right, winWidth;
          left = feedback.target.left;
          right = 'auto';
          winWidth = $(window).width();
          if (left > winWidth - 200) {
            right = winWidth - (left + feedback.target.width);
            left = 'auto';
          }
          return $(this).css({
            position: 'absolute',
            left: left,
            right: right,
            top: feedback.target.top + feedback.target.height + 5,
            'z-index': 2
          });
        }
      }
    });
    $(document).on('updateBadges', function(e, resp) {
      var $badge, $chainsMenu, $chainsNotification, $lis, $nav, $taskNotification, $tasksMenu, findOrCreateBadge, findOrCreateNotification;
      $nav = $('#workspace_nav ul.nav_tabs');
      $lis = $nav.children('li');
      if ($lis.length === 0) {
        return;
      }
      findOrCreateBadge = function($li) {
        var $badge;
        $badge = $li.find('>a>.badge').first();
        if ($badge.length > 0) {
          return $badge;
        } else {
          return $('<span />', {
            "class": 'badge'
          }).appendTo($li.find('>a'));
        }
      };
      findOrCreateNotification = function($li) {
        var $badge;
        $badge = $li.find('>a>.error_notification').first();
        if ($badge.length > 0) {
          return $badge;
        } else {
          return $('<span />', {
            "class": 'error_notification'
          }).appendTo($li.find('>a'));
        }
      };
      $badge = findOrCreateBadge($lis.filter('li.sessions'));
      if (resp.session_count === 0) {
        $badge.remove();
      } else {
        $badge.text(resp.session_count);
      }
      $badge = findOrCreateBadge($lis.filter('li.reports'));
      if (resp.report_count === 0) {
        $badge.remove();
      } else {
        $badge.text(resp.report_count);
      }
      $tasksMenu = $lis.filter('li.tasks');
      $chainsMenu = $tasksMenu.find('>ul>li>.chains').first().parent();
      $taskNotification = findOrCreateNotification($tasksMenu);
      $chainsNotification = findOrCreateNotification($chainsMenu);
      if (resp.task_chain_errors === 0) {
        $taskNotification.removeClass('notification-dot');
        $chainsNotification.removeClass('notification-dot');
      } else {
        $taskNotification.addClass('notification-dot');
        $chainsNotification.addClass('notification-dot');
      }
      $badge = findOrCreateBadge($tasksMenu);
      if (resp.task_count === 0) {
        $badge.remove();
      } else {
        $badge.text(resp.task_count);
      }
      $badge = findOrCreateBadge($lis.filter('li.campaigns'));
      if (resp.campaign_count === 0) {
        return $badge.remove();
      } else {
        return $badge.text(resp.campaign_count);
      }
    });
    $(document).on('click', '#flash_messages > a.close', function(e) {
      return $(e.target).closest("#flash_messages").empty();
    });
    return $(document).ready(function() {
      $(document).on('click', 'span.btn a', function(e) {
        if ($(this).attr('href') === '#') {
          return e.preventDefault();
        }
      });
      _.mixin(_.str.exports());
      $('#top-menu>ul.drop-menu>li.menu>a').each(function() {
        return $(this).click(function(e) {
          return e.preventDefault();
        });
      });
      $('#top-menu ul.drop-menu.menu-left li.menu ul.sub-menu').each(function(index, elem) {
        var parent_width;
        parent_width = Math.max($(elem).parent().outerWidth(), 160);
        if ($(elem).width() < parent_width) {
          return $(elem).width(parent_width - 2);
        }
      });
      $('#top-menu ul.drop-menu:not(.menu-left) li.menu ul.sub-menu').each(function(index, elem) {
        var parent_width;
        parent_width = $(elem).parent().outerWidth();
        if ($(elem).width() < parent_width) {
          return $(elem).width(parent_width - 2);
        }
      });
      if ($("meta[name='msp:unlicensed'][content='true']").length > 0) {
        $('.mainContent').addDisableOverlay('Metasploit Pro');
      }
      $(document).on('click', 'a.show_hide', function(e) {
        e.preventDefault();
        Effect.toggle($(this).data('show-hide-element'), 'blind', {
          duration: 0.3
        });
        return false;
      });
      $(document).on('click', 'input.delete.async', function(e) {
        e.preventDefault();
        $.ajax($(this).data('url'), {
          method: 'delete',
          data: $(this).closest('form').serialize()
        });
        return false;
      });
      return $(document).on('click', 'a.popup-cancel', function(e) {
        e.preventDefault();
        $('#popup').hide();
        return false;
      });
    });
  });

}).call(this);
