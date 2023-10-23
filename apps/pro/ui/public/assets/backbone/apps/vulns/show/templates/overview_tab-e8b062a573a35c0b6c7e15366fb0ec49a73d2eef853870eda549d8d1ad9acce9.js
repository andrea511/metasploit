(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/vulns/show/templates/overview_tab"] = function(__obj) {
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
      
        __out.push('<form>\n  <div>\n    <label for="comments">Comments</label>\n  </div>\n  <div>\n\n    <textarea id="comments" type="text" name="comment">');
      
        __out.push(__sanitize((_ref = this.notes[0]) != null ? _ref.comment : void 0));
      
        __out.push('</textarea>\n    ');
      
        __out.push(this.buttomMoreAssetTag);
      
        __out.push('\n    <div class="error" style="display:none;"></div>\n  </div>\n  <h5>Attempts History</h5>\n  <div class="overview-region"></div>\n</form>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
