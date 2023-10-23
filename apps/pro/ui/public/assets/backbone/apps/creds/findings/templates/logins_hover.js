(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/findings/templates/logins_hover"] = function(__obj) {
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
        var data, fpvt, _i, _len, _ref;
      
        __out.push('<div class="foundation">\n  <div class=\'row\'>\n    <div class=\'large-3 columns\'>Public</div>\n    <div class=\'large-4 columns\'>Private</div>\n    <div class=\'large-5 columns\'>Realm</div>\n  </div>\n  <div class=\'scrollie\'>\n    ');
      
        if (this.rowData == null) {
          __out.push('\n    <div class=\'spinner\'></div>\n    ');
        } else {
          __out.push('\n    ');
          _ref = this.rowData;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            data = _ref[_i];
            __out.push('\n    <div class=\'row\'>\n      <div class=\'large-3 columns\'>');
            __out.push(__sanitize(_.str.truncate(data.public_username, 12)));
            __out.push('</div>\n      ');
            if (data.private_type.match(/key/i)) {
              __out.push('\n      ');
              fpvt = "[" + data.private_type + "]";
              __out.push('\n      <div class=\'large-4 columns\'>');
              __out.push(__sanitize(_.str.truncate(fpvt, 18)));
              __out.push('</div>\n      ');
            } else {
              __out.push('\n      <div class=\'large-4 columns\'>');
              __out.push(__sanitize(_.str.truncate(data.private_data, 18)));
              __out.push('</div>\n      ');
            }
            __out.push('\n      <div class=\'large-5 columns\'>');
            __out.push(__sanitize(data.realm_key));
            __out.push('</div>\n    </div>\n    ');
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
