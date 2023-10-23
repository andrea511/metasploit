(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/imports/index/templates/type_selection_layout"] = function(__obj) {
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
      
        __out.push('<div class="large-4 columns no-left-padding">\n  <div class="columns large-4 no-left-padding">\n    <input type="radio" id="import-from-nexpose" name="imports[type]" value="import-from-nexpose"/><label for="import-from-nexpose">From Nexpose</label>\n  </div>\n\n  <div class="large-4 columns left-align">\n    <input type="radio" id="import-from-file" name="imports[type]" value="import-from-file"/><label for="import-from-file">From file</label>\n  </div>\n\n  <div class="large-4 columns left-align">\n    <input type="radio" id="import-from-sonar" name="imports[type]" value="import-from-sonar"/><label for="import-from-sonar">From Sonar</label>\n  </div>\n\n</div>\n\n<div class="large-8 columns"></div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
