(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/new/templates/private"] = function(__obj) {
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
      
        __out.push('<form>\n  <div>\n    <label for="type">Private type</label>\n    <select id="type" name="private[type]">\n      <option value="none">None</option>\n      <option value="plaintext">Plaintext Password</option>\n      <option value="ssh">SSH Key</option>\n      <option value="ntlm">NTLM Hash</option>\n      <option value="hash">Hash</option>\n    </select>\n  </div>\n\n  <div class=\'clear-floats\'>\n    <div class="none">\n\n    </div>\n\n    <div class="plaintext invisible option">\n      <label for="data">Password</label>\n    </div>\n\n    <div class="ssh invisible option">\n      <label for="data">SSH Key</label>\n    </div>\n\n    <div class="ntlm invisible option">\n      <label for="data">NTLM Hash</label>\n    </div>\n\n    <div class="hash invisible option">\n      <label for="data">Hash</label>\n    </div>\n    <textarea id="data" type="text" name="private[data]"></textarea>\n  </div>\n\n</form>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
