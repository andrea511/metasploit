(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/reports/show/templates/_file_format"] = function(__obj) {
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
      
        if (!(this.not_generated || this.status === 'regenerating')) {
          __out.push('\n  <input type="checkbox" class="report-format-checkbox" />\n');
        }
      
        __out.push('\n\n<div title="" class=\'format-button ');
      
        __out.push(__sanitize(this.file_format));
      
        __out.push(' ');
      
        if (this.not_generated) {
          __out.push(__sanitize('not-generated'));
        }
      
        __out.push(' ');
      
        __out.push(__sanitize(this.status));
      
        __out.push(' ');
      
        if (this.displayed) {
          __out.push(__sanitize('displayed'));
        }
      
        __out.push(' \'></div>\n\n\n<div class=\'regenerate-button ');
      
        __out.push(__sanitize(this.status));
      
        __out.push('\'></div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
