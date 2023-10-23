(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/new/templates/realm"] = function(__obj) {
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
        var realm, _i, _len, _ref;
      
        __out.push('<form>\n  <div>\n    <label for="realm">Realm Type</label>\n    <select id="realm" name="realm[key]">\n        <option value="None">None</option>\n        ');
      
        _ref = Pro.Entities.Cred.Realms.ALL;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          realm = _ref[_i];
          __out.push('\n            <option value="');
          __out.push(__sanitize(realm));
          __out.push('">');
          __out.push(__sanitize(realm));
          __out.push('</option>\n        ');
        }
      
        __out.push('\n    </select>\n  </div>\n\n  <div class=\'clear-floats\'>\n    <label for="name">Realm Name</label>\n    <input id="name" name="realm[value]" type="text" />\n  </div>\n</form>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
