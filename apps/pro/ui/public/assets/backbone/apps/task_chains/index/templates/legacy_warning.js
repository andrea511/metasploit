(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/task_chains/index/templates/legacy_warning"] = function(__obj) {
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
        var chain, _i, _len, _ref;
      
        __out.push('<div>\n  The following task chains need to be updated due to recent changes to the import and Nexpose configuration pages:\n\n  <br><br>\n\n  <h5>Affected Chains:</h5>\n\n  <ul>\n  ');
      
        _ref = this.legacyChains;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          chain = _ref[_i];
          __out.push('\n    <li>');
          __out.push(__sanitize(chain.name));
          __out.push('</li>\n  ');
        }
      
        __out.push('\n  </ul>\n\n\n\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
