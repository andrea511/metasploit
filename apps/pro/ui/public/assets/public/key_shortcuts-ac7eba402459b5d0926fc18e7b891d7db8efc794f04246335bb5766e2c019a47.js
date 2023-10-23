(function() {

  jQuery(document).ready(function($) {
    var $console, $hider, $oldHelp, CONSOLE_HEIGHT_COOKIE, INPUT_SEL, WORKSPACE_REGEX, consoleId, consoleMouseUp, cookieKey, desiredHeight, maxHeight, minHeight, mousedown, toggleConsole, workspaceId, yankTimeout;
    INPUT_SEL = 'textarea:focus:visible,input[type=text]:focus:visible,' + 'input[type=email]:focus:visible,input[type=number]:focus:visible,' + 'input[type=tel]:focus:visible,input[type=url]:focus:visible,' + 'input[type=week]:focus:visible,input[type=color]:focus:visible,' + 'input[type=date]:focus:visible, input[type=password]:focus:visible';
    WORKSPACE_REGEX = /workspaces\/(\d+)/;
    CONSOLE_HEIGHT_COOKIE = 'console-height';
    $oldHelp = null;
    yankTimeout = null;
    if (location.href.match(WORKSPACE_REGEX)) {
      workspaceId = location.href.match(WORKSPACE_REGEX)[1];
    } else {
      workspaceId = null;
    }
    cookieKey = 'session-consoleId' + workspaceId;
    consoleId = $.cookie(cookieKey);
    $hider = null;
    $console = null;
    mousedown = false;
    desiredHeight = parseInt($.cookie()[CONSOLE_HEIGHT_COOKIE]) || null;
    minHeight = 200;
    maxHeight = $(window).height() - 30;
    $(window).on('resize', function() {
      return maxHeight = $(window).height() - 30;
    });
    consoleMouseUp = function() {
      var consoleHeight;
      $('body').unbind('mousemove.console-dragger');
      mousedown = false;
      if (!(($console != null ? $console.length : void 0) && ($console != null ? $console.is(':visible') : void 0))) {
        return;
      }
      if ($hider != null) {
        $hider.hide();
      }
      consoleHeight = $console.height();
      if (desiredHeight !== consoleHeight) {
        desiredHeight = consoleHeight;
        $.removeCookie(CONSOLE_HEIGHT_COOKIE);
        return $.cookie(CONSOLE_HEIGHT_COOKIE, consoleHeight);
      }
    };
    toggleConsole = function() {
      var $dragger, $iframe, initHeight, initPos, onMouseMove;
      if (!workspaceId) {
        return;
      }
      $console = $('#console-tray');
      if (yankTimeout != null) {
        window.clearTimeout(yankTimeout);
      }
      if (!$console.length) {
        $console = $('<div />', {
          id: 'console-tray',
          "class": 'hidden-console'
        }).appendTo($('body'));
        if ((desiredHeight != null) && desiredHeight > minHeight && desiredHeight < maxHeight) {
          $console.height(desiredHeight);
        }
        $iframe = $('<iframe />', {
          src: 'about:blank',
          name: 'console'
        }).appendTo($console);
        $dragger = $('<div />', {
          "class": 'dragger'
        }).appendTo($console);
        $hider = $('<div />', {
          "class": 'iframe-hider'
        }).appendTo($console);
        initPos = null;
        initHeight = null;
        onMouseMove = function(e) {
          var datHeight;
          if (!mousedown) {
            return;
          }
          datHeight = initHeight + e.screenY - initPos;
          if (datHeight < minHeight) {
            datHeight = minHeight;
          }
          if (datHeight > maxHeight) {
            datHeight = maxHeight;
          }
          return $console.height(datHeight);
        };
        $dragger.on('mousedown', function(e) {
          mousedown = true;
          initHeight = $console.height();
          initPos = e.screenY;
          $hider.show();
          return $('body').bind('mousemove.console-dragger', onMouseMove);
        });
        $('body').bind('mouseup.console-events, mouseleave.console-events', consoleMouseUp);
        if (consoleId) {
          $iframe.attr('src', "/workspaces/" + workspaceId + "/consoles/" + consoleId);
        } else {
          $iframe.attr('src', "/workspaces/" + workspaceId + "/console");
        }
        return window.setTimeout(function() {
          return $console.removeClass('hidden-console');
        });
      } else if ($console.hasClass('hidden-console')) {
        $console.show();
        $('body').bind('mouseup.console-events, mouseleave.console-events', consoleMouseUp);
        $iframe = $console.find('iframe');
        $iframe[0].contentWindow.focus();
        if ($console[0].parentNode == null) {
          $console.appendTo($('body'));
        }
        return window.setTimeout(function() {
          return $console.removeClass('hidden-console');
        });
      } else if (!$console.hasClass('hidden-console')) {
        $iframe = $console.find('iframe');
        $iframe[0].contentWindow.blur();
        $console.addClass('hidden-console');
        $('body').unbind('mouseup.console-events, mouseleave.console-events');
        yankTimeout = window.setTimeout((function() {
          return $console.remove();
        }), 10000);
        return window.focus();
      }
    };
    window['toggleConsole'] = toggleConsole;
    $(document).bind('consoleLoad', function(e, data) {
      consoleId = data.id;
      $.removeCookie(cookieKey);
      return $.cookie(cookieKey, consoleId, {
        expires: new Date(+(new Date) + 1000 * 60 * 5)
      });
    });
    return $(document.body).bind('keydown', function(e) {
      var $help, fieldKey;
      if (e.keyCode === 114) {
        $help = $(e.target).parents('li').find('a.help');
        if ($help.length < 1 && ($oldHelp != null) && $oldHelp.length > 0) {
          fieldKey = $oldHelp.data('field');
          if ($(".inline-help[data-field='" + fieldKey + "']").is(':visible')) {
            $oldHelp.click();
            $oldHelp = null;
            return;
          }
        }
        if ($help && $help.length) {
          $help.click();
        }
        $oldHelp = $help;
        e.preventDefault();
        return e.stopPropagation();
      } else if (e.keyCode === 112) {
        return window.open($('#top-menu a.help-item').first().attr('href'), '_blank');
      } else if (e.keyCode === 192 & (e.altKey || e.ctrlKey)) {
        return toggleConsole.call(this);
      }
    });
  });

}).call(this);
