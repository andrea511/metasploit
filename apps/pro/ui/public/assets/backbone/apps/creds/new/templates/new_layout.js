(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/new/templates/new_layout"] = function(__obj) {
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
      
        __out.push('<div class="add-cred">\n    <div class="cred-type">\n        <div class="manual">\n            <input id="manual" name="cred_type" value="manual" type="radio" checked="checked">\n            <label for="manual">Manual</label>\n        </div>\n        <div class="import">\n            <input id="import" name="cred_type" value="import" type="radio">\n            <label for="import">Import</label>\n        </div>\n    </div>\n\n    <div class="form-container cred"></div>\n\n    <div class="login-form-container"></div>\n\n\n    <div class="tag-container clear-floats">\n        <label for="token-input-">Tags</label>\n        <div class="tags"></div>\n    </div>\n\n    <div class="core-errors"></div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
