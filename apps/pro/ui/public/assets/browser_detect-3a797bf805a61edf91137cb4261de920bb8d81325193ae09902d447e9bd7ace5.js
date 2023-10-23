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
