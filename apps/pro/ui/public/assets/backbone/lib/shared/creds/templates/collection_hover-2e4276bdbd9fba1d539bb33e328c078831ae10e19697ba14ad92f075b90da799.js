(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/shared/creds/templates/collection_hover"] = function(__obj) {
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
        var col, columns, row, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _ref3;
      
        if (this.title != null) {
          __out.push('\n  <h5>');
          __out.push(__sanitize(this.title));
          __out.push('</h5>\n');
        }
      
        __out.push('\n<div class="foundation">\n  <div class=\'row\'>\n    ');
      
        _ref = this.columns;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          col = _ref[_i];
          __out.push('\n      <div class=\'large-');
          __out.push(__sanitize((_ref1 = col.size) != null ? _ref1 : parseInt(12 / this.columns.length)));
          __out.push(' columns\'>\n        ');
          __out.push(__sanitize(col.label));
          __out.push('\n      </div>\n    ');
        }
      
        __out.push('\n  </div>\n  <div class=\'scrollie\'>\n    ');
      
        if (this.data == null) {
          __out.push('\n      <div class=\'spinner\'></div>\n    ');
        } else {
          __out.push('\n      ');
          columns = this.columns;
          __out.push('\n      ');
          _ref2 = this.data;
          for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
            row = _ref2[_j];
            __out.push('\n        <div class=\'row\'>\n          ');
            for (_k = 0, _len2 = columns.length; _k < _len2; _k++) {
              col = columns[_k];
              __out.push('\n            <div class=\'large-');
              __out.push(__sanitize((_ref3 = col.size) != null ? _ref3 : parseInt(12 / this.columns.length)));
              __out.push(' columns\'>\n              <div class=\'truncate\'>');
              __out.push(__sanitize(row[col.attribute]));
              __out.push('</div>\n            </div>\n\n          ');
            }
            __out.push('\n        </div>\n      ');
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
