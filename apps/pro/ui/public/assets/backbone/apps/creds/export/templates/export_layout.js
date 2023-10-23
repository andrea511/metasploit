(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/export/templates/export_layout"] = function(__obj) {
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
      
        __out.push('\n<div class="form-container export-form">\n    <div>\n        <input id="filename" name="filename" type="text">\n        <label for="filename">File Name</label>\n    </div>\n\n    <div>\n        <div class="radio-label inline-block">Format</div>\n\n        <div class="inline-block">\n            <div class="inline-radio">\n                <input id="csv" type="radio" name="export_format" value="csv" checked>\n                <label for="csv">CSV</label>\n            </div>\n\n            <div class="inline-radio wide">\n                <input id="pwdump" type="radio" name="export_format" value="radio">\n                <label for="pwdump">pwdump (logins only)</label>\n            </div>\n        </div>\n    </div>\n\n    <div class="pwdump-warning">\n      SSH keys will not be exported in pwdump format\n    </div>\n\n    <div class="row-options">\n        <div class="radio-label inline-block">Rows</div>\n\n        <div class="inline-block">\n            <div class="inline-radio">\n                <input id="selected" type="radio" name="rows" value="selected" checked>\n                <label for="selected">Selected</label>\n            </div>\n\n            <div class="inline-radio">\n                <input id="all" type="radio" name="rows" value="all">\n                <label for="all">All</label>\n            </div>\n        </div>\n    </div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
