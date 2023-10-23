(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/meta_modules/domino/templates/layout"] = function(__obj) {
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
      
        __out.push('<div class=\'graph-controls\'>\n  <label class=\'vertical\'>\n    <input type=\'radio\' name=\'orientation\' value=\'vertical\' title=\'Vertical\' checked />\n    <span class=\'icon\' title=\'Vertical\' />\n  </label>\n  <label class=\'horizontal\'>\n    <input type=\'radio\' name=\'orientation\' value=\'horizontal\' title=\'Horizontal\'  />\n    <span class=\'icon\' title=\'Horizontal\' />\n  </label>\n  <label class=\'radial\' style=\'display:none\'>\n    <input type=\'radio\' name=\'orientation\' value=\'radial_tree\' title=\'Radial\'  />\n    <span class=\'icon\' title=\'Radial\' />\n  </label>\n  <label class=\'full-screen\'>\n    <input type=\'checkbox\' name=\'full-screen\' />\n    <span class=\'icon\' title=\'Fullscreen\' />\n  </label>\n</div>\n<div class=\'d3-graph-visualization\'></div>\n<div class=\'node-info-region\'></div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
