(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/shared/templates/private_cell"] = function(__obj) {
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
      
        if (this.displayFilterEventLink) {
          __out.push('\n  <a class="filter event" href="javascript:void(0)">\n    ');
          __out.push(__sanitize(this['private.data_truncated'] || this['core.private.data_truncated']));
          __out.push('\n  </a>\n');
        } else if (this.displayFilterLink) {
          __out.push('\n  <a class="filter" href="#creds?search=private.data:');
          __out.push(__sanitize(encodeURIComponent(this['private.data'])));
          __out.push('">\n    ');
          __out.push(__sanitize(this['private.data_truncated'] || this['core.private.data_truncated']));
          __out.push('\n  </a>\n');
        } else {
          __out.push('\n  ');
          __out.push(__sanitize(this['private.data_truncated'] || this['core.private.data_truncated']));
          __out.push('\n');
        }
      
        __out.push('\n\n');
      
        if (this.truncated) {
          __out.push('\n  <a href="javascript:void(0);" class="private-data-disclosure">more</a>\n');
        }
      
        __out.push('\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
