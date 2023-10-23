(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/components/modal/templates/modal"] = function(__obj) {
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
      
        __out.push('\n<div class="bg"></div>\n\n\n<div class="modal ');
      
        __out.push(__sanitize(this["class"]));
      
        __out.push('" id="modal">\n    <div class="header">\n        <a class="close small"  href="javascript:void 0"> &times; </a>\n        ');
      
        if (this.title) {
          __out.push('\n            <h1>');
          __out.push(__sanitize(this.title));
          __out.push('</h1>\n        ');
        }
      
        __out.push('\n\n        ');
      
        if (this.description) {
          __out.push('\n            <p>');
          __out.push(__sanitize(this.description));
          __out.push('</p>\n        ');
        }
      
        __out.push('\n    </div>\n\n    <div class="padding">\n        <div class="content"></div>\n\n        ');
      
        if (this.showAgainOption) {
          __out.push('\n          <div class="show-again-option">\n            <label>\n              <input type="checkbox" name="showOnce">\n              Do not show this again\n            </label>\n          </div>\n        ');
        }
      
        __out.push('\n\n        <div class="clearfix"></div>\n        <div class="modal-actions"></div>\n    </div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
