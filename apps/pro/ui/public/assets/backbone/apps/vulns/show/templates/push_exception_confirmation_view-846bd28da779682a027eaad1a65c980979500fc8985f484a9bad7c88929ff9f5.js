(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/vulns/show/templates/push_exception_confirmation_view"] = function(__obj) {
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
        var key, val, _ref;
      
        __out.push('<div class="msg">\n  <form>\n    <div class="foundation">\n      <div class="row">\n        <div class="columns large-6">\n          <label>Reason</label>\n        </div>\n\n        <div class="columns large-6">\n          <select name="reason">\n            ');
      
        _ref = this.reasons;
        for (key in _ref) {
          val = _ref[key];
          __out.push('\n            <option value="');
          __out.push(__sanitize(key));
          __out.push('">');
          __out.push(__sanitize(val));
          __out.push('</option>\n            ');
        }
      
        __out.push('\n          </select>\n        </div>\n      </div>\n\n      <div class="row">\n        <div class="columns large-6">\n          <label>Expiration Date</label>\n        </div>\n\n        <div class="columns large-6">\n          <input class=\'datetime\' type="text" name="expiration_date" readonly=""readonly" />\n        </div>\n      </div>\n\n      <div class="row">\n        <div class="columns large-12">\n          <div>\n            <label>\n              <input type="checkbox" name="approve" />\n              Automatically Approve\n            </label>\n          </div>\n        </div>\n      </div>\n\n    </div>\n  </form>\n</div>\n\n<div class="error-state"></div>\n\n<div class="processing ellipsis">\n  Processing\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
