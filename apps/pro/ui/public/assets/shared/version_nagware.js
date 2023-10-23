(function() {
  var $, COOKIE_EXPIRATION, SUPPORTED_BROWSERS, SYSTEM_REQS_URL, browserIsSupported, browserName, browsers, key, matchedBrowsers, msg, name, requiredVersion, val, version, _i, _len,
    __hasProp = {}.hasOwnProperty;

  $ = jQuery;

  SYSTEM_REQS_URL = 'www.rapid7.com/products/metasploit/system-requirements.jsp';

  COOKIE_EXPIRATION = 2;

  SUPPORTED_BROWSERS = {
    chrome: 12,
    msie: 10,
    firefox: 18
  };

  browserIsSupported = false;

  requiredVersion = null;

  browsers = window.browserDetect();

  matchedBrowsers = [];

  for (key in SUPPORTED_BROWSERS) {
    if (!__hasProp.call(SUPPORTED_BROWSERS, key)) continue;
    val = SUPPORTED_BROWSERS[key];
    if (browsers[key]) {
      matchedBrowsers.push(key);
    }
  }

  msg = null;

  browserName = null;

  if (!(matchedBrowsers != null ? matchedBrowsers.length : void 0) && !(browsers.webkit != null) && !(browsers.mozilla != null)) {
    msg = "You are using an unsupported browser. Please install a <a " + ("href='" + SYSTEM_REQS_URL + "' target='_blank' class='supported-") + "browsers'>supported browser</a>.";
  } else {
    version = parseInt(browsers.version, 10);
    if (!version) {
      return;
    }
    browserName = null;
    for (_i = 0, _len = matchedBrowsers.length; _i < _len; _i++) {
      name = matchedBrowsers[_i];
      if (SUPPORTED_BROWSERS[name]) {
        browserName = name;
        break;
      }
    }
    requiredVersion = SUPPORTED_BROWSERS[browserName];
    browserIsSupported = !((requiredVersion != null) && version < requiredVersion);
  }

  if (!(browserIsSupported || $.cookie('browser-nagware') === '1')) {
    $(document).ready(function() {
      var $close, $nag;
      $nag = $('<div />', {
        id: 'nagware'
      }).appendTo($('body'));
      name = browserName === 'msie' ? 'IE' : browserName.replace(/^./, browserName[0].toUpperCase());
      msg || (msg = ("You are using an unsupported browser. Please upgrade to " + name + " ") + ("<strong>" + requiredVersion + "</strong> or higher."));
      $nag.html(msg);
      $('#appWrap').css('padding-top', $nag.height() + 1);
      return $close = $('<a />', {
        "class": 'close'
      }).html('&times;').appendTo($nag).click(function() {
        $nag.remove();
        $('#appWrap').css('padding-top', 0);
        return $.cookie('browser-nagware', '1', {
          expires: COOKIE_EXPIRATION
        });
      });
    });
  }

}).call(this);
