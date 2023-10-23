/*!
 * jQuery Cookie Plugin v1.3.1
 * https://github.com/carhartl/jquery-cookie
 *
 * Copyright 2013 Klaus Hartl
 * Released under the MIT license
 */

(function (factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as anonymous module.
    define(['jquery'], factory);
  } else {
    // Browser globals.
    factory(jQuery);
  }
}(function ($) {

  var pluses = /\+/g;

  function raw(s) {
    return s;
  }

  function decoded(s) {
    return decodeURIComponent(s.replace(pluses, ' '));
  }

  function converted(s) {
    if (s.indexOf('"') === 0) {
      // This is a quoted cookie as according to RFC2068, unescape
      s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, '\\');
    }
    try {
      return config.json ? JSON.parse(s) : s;
    } catch(er) {}
  }

  var config = $.cookie = function (key, value, options) {

    // write
    if (value !== undefined) {
      options = $.extend({}, config.defaults, options);

      if (typeof options.expires === 'number') {
        var days = options.expires, t = options.expires = new Date();
        t.setDate(t.getDate() + days);
      }

      value = config.json ? JSON.stringify(value) : String(value);

      return (document.cookie = [
        config.raw ? key : encodeURIComponent(key),
        '=',
        config.raw ? value : encodeURIComponent(value),
        options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
        options.path    ? '; path=' + options.path : '',
        options.domain  ? '; domain=' + options.domain : '',
        options.secure  ? '; secure' : ''
      ].join(''));
    }

    // read
    var decode = config.raw ? raw : decoded;
    var cookies = document.cookie.split('; ');
    var result = key ? undefined : {};
    for (var i = 0, l = cookies.length; i < l; i++) {
      var parts = cookies[i].split('=');
      var name = decode(parts.shift());
      var cookie = decode(parts.join('='));

      if (key && key === name) {
        result = converted(cookie);
        break;
      }

      if (!key) {
        result[name] = converted(cookie);
      }
    }

    return result;
  };

  config.defaults = {};

  $.removeCookie = function (key, options) {
    if ($.cookie(key) !== undefined) {
      // Must not alter options, thus extending a fresh object...
      $.cookie(key, '', $.extend({}, options, { expires: -1 }));
      return true;
    }
    return false;
  };

}));
// Snipped from the js-popunder lib
// https://github.com/tuki/js-popunder

window.browserDetect = function() {
  var n = navigator.userAgent.toLowerCase();
  var b = {
    webkit: /webkit/.test(n),
    mozilla: (/mozilla/.test(n)) && (!/(compatible|webkit)/.test(n)),
    chrome: /chrome/.test(n),
    msie: (/msie/.test(n)) && (!/opera/.test(n)),
    firefox: /firefox/.test(n),
    safari: (/safari/.test(n) && !(/chrome/.test(n))),
    opera: /opera/.test(n)
  };
  b.version = (b.safari) ? (n.match(/.+(?:ri)[\/: ]([\d.]+)/) || [])[1] :
                           (n.match(/.+(?:ox|me|ra|ie)[\/: ]([\d.]+)/) || [])[1];
  return b;
};
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




//Append URL Anchor to POST request
$(document).ready(function() {
  var url = jQuery('form').attr('action')+'#'+ window.location.hash.substr(1);
  jQuery('form').attr('action',url);
});
