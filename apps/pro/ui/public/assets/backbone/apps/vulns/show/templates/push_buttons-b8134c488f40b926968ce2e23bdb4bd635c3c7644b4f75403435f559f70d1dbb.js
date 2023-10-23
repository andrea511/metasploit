(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/vulns/show/templates/push_buttons"] = function(__obj) {
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
      
        __out.push('<div class="push-options">\n  <div class="not-exploitable" ');
      
        if (!this.markable) {
          __out.push(__sanitize("title='" + this.not_pushable_reason + "'"));
        }
      
        __out.push(' >\n    <input id ="not_exploitable" name="not_exploitable" class="');
      
        if (!this.markable) {
          __out.push(__sanitize('disabled'));
        }
      
        __out.push('" type="checkbox" ');
      
        if (this.not_exploitable) {
          __out.push(__sanitize("checked"));
        }
      
        __out.push('>\n    <label for="not_exploitable" class="');
      
        if (!this.markable) {
          __out.push(__sanitize('disabled'));
        }
      
        __out.push('">Mark as Not Exploitable</label>\n  </div>\n  <div class="create-exception" ');
      
        if (!this.pushable) {
          __out.push(__sanitize("title='" + this.not_pushable_reason + "'"));
        }
      
        __out.push('>\n    <span class="btn ');
      
        if (!this.pushable) {
          __out.push(__sanitize('disabled'));
        }
      
        __out.push('"><a href="javascript:void(0)" class="nexpose">Push to Nexpose</a></span>\n  </div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
