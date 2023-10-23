(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/findings/templates/sessions_hover"] = function(__obj) {
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
        var data, index, _i, _len, _ref;
      
        __out.push('<div class="foundation">\n  <h5>Go to Session</h5>\n\n  <div class=\'scrollie\'>\n    ');
      
        if (this.rowData == null) {
          __out.push('\n    <div class=\'spinner\'></div>\n    ');
        } else {
          __out.push('\n    ');
          _ref = this.rowData;
          for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
            data = _ref[index];
            __out.push('\n    <div class=\'row\'>\n      <div class="columns large-12">\n        <a href="');
            __out.push(__sanitize(Routes.session_path(WORKSPACE_ID, data.id)));
            __out.push('" class="underline">Session ');
            __out.push(__sanitize(data.id));
            __out.push('</a>\n      </div>\n    </div>\n    ');
          }
          __out.push('\n    ');
        }
      
        __out.push('\n  </div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
