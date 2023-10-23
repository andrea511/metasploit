(function() {
  var $;

  $ = jQuery;

  $.fn.ByteEntry = function() {
    var BACKSPACE_KEY, PASSTHRU_KEYS, fixFormatting, lastKey, onChange;
    BACKSPACE_KEY = 8;
    PASSTHRU_KEYS = [BACKSPACE_KEY, 0, 46, 37, 38, 39, 40];
    lastKey = null;
    fixFormatting = function(str) {
      var parts;
      if (str == null) {
        str = '';
      }
      str = str.toLowerCase().replace(/\s+/g, '').replace(/[^0-9a-f]/g, '');
      parts = _.chain(str.split('')).groupBy(function(k, i) {
        return Math.floor(i / 2.0);
      }).map(function(_arg) {
        var a, b;
        a = _arg[0], b = _arg[1];
        return a + (b || '');
      }).value().join(" ");
      if (parts.match(/\w\w$/) && lastKey !== BACKSPACE_KEY) {
        parts += ' ';
      }
      return parts;
    };
    this.css('font-family', 'monospace');
    this.attr('spellcheck', false);
    this.keypress(function(e) {
      var char, code;
      if (_.contains(PASSTHRU_KEYS, e.which)) {
        return;
      }
      char = String.fromCharCode(e.which).toLowerCase();
      code = char.charCodeAt(0);
      if (char && char.length && (code < '0'.charCodeAt(0) || code > 'f'.charCodeAt(0))) {
        e.preventDefault();
        e.stopImmediatePropagation();
        return false;
      }
    });
    onChange = function(e) {
      var _this = this;
      lastKey = e.which || lastKey;
      return _.defer(function() {
        var fixedVal, initVal;
        initVal = $(_this).val();
        fixedVal = fixFormatting(initVal);
        if (initVal !== fixedVal) {
          return $(_this).val(fixedVal);
        }
      });
    };
    this.change(onChange);
    return this.keyup(onChange);
  };

}).call(this);
