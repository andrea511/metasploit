(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/shared/nexpose_push/templates/push_modal_no_console"] = function(__obj) {
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
      
        __out.push('<div class="push-text">\n  <p><a href=\'/settings#nexpose_consoles\' >Manage Nexpose Consoles</a></p>\n  <p class="push-warning">(This page will refresh and you will lose all applied filters.)</p>\n  ');
      
        if (!this.has_console) {
          __out.push('\n    <hr>\n    <p>Don\'t have Nexpose? <a href=\'http://www.rapid7.com/products/nexpose/nexpose-enterprise-trial.jsp?CS=metasploitinp\'>Try It Now</a></p>\n  ');
        }
      
        __out.push('\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
