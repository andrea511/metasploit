(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_reuse/cred_selection/templates/cred_row"] = function(__obj) {
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
        var _ref;
      
        __out.push('<div class=\'group-row\'>\n\n  <div class=\'title\'>\n    <span class=\'username\'>\n      ');
      
        __out.push(__sanitize(this['public.username']));
      
        __out.push('\n    </span>\n    <span class=\'private\'>\n      ');
      
        __out.push(__sanitize(this['private.data']));
      
        __out.push('\n    </span>\n  </div>\n  <div class=\'subtitle\'>\n    ');
      
        if (((_ref = this['realm.key']) != null ? _ref.length : void 0) > 0) {
          __out.push('\n      ');
          __out.push(__sanitize(this['realm.key']));
          __out.push(' (');
          __out.push(__sanitize(this['realm.value']));
          __out.push(')\n    ');
        } else {
          __out.push('\n      No Realm\n    ');
        }
      
        __out.push('\n  </div>\n\n  <a class=\'right delete\' title=\'Remove this credential from the selection.\' href=\'javascript:void(0)\'>\n    <span>\n      &times;\n    </span>\n  </a>\n\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
