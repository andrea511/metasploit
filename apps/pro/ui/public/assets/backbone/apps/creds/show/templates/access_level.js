(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/show/templates/access_level"] = function(__obj) {
    if (!__obj) __obj = {};
    var __out = [], __capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return __safe(result);
    }, __sanitize = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else if (typeof value !== 'undefined' && value != null) {
        return __escape(value);
      } else {
        return '';
      }
    }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
    __safe = __obj.safe = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else {
        if (!(typeof value !== 'undefined' && value != null)) value = '';
        var result = new String(value);
        result.ecoSafe = true;
        return result;
      }
    };
    if (!__escape) {
      __escape = __obj.escape = function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      };
    }
    (function() {
      (function() {
        var isDefault, level, levels, selected, _i, _j, _len, _len1, _ref, _ref1, _ref2;
      
        if (!this.showInput) {
          __out.push('\n  <select name="access_level">\n    ');
          isDefault = false;
          __out.push('\n    ');
          levels = this.accessLevels;
          __out.push('\n    ');
          _ref = ['Admin', 'Read Only'];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            level = _ref[_i];
            __out.push('\n\n      ');
            selected = ((_ref1 = this.access_level) != null ? _ref1.toLowerCase() : void 0) === level.toLowerCase();
            __out.push('\n      ');
            isDefault || (isDefault = selected);
            __out.push('\n      <option ');
            if (selected) {
              __out.push('selected');
            }
            __out.push('>');
            __out.push(__sanitize(level));
            __out.push('</option>\n\n    ');
          }
          __out.push('\n\n    ');
          for (_j = 0, _len1 = levels.length; _j < _len1; _j++) {
            level = levels[_j];
            __out.push('\n\n      ');
            selected = ((_ref2 = this.access_level) != null ? _ref2.toLowerCase() : void 0) === (level != null ? level.toLowerCase() : void 0);
            __out.push('\n      ');
            isDefault || (isDefault = selected);
            __out.push('\n\n      <option ');
            if (selected) {
              __out.push('selected');
            }
            __out.push('>');
            __out.push(__sanitize(level));
            __out.push('</option>\n    ');
          }
          __out.push('\n\n    ');
          if (!isDefault) {
            __out.push('\n      <option selected>');
            __out.push(__sanitize(this.access_level));
            __out.push('</option>\n    ');
          }
          __out.push('\n    <option>Other…</option>\n  </select>\n\n');
        } else {
          __out.push('\n  <input type=\'text\' maxlength=\'24\' />\n');
        }
      
        __out.push('\n\n');
      
        if (this.showLabel) {
          __out.push('\n    <label>Access Level</label>\n');
        }
      
        __out.push('\n\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
