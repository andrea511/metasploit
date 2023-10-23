(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_reuse/cred_selection/templates/group_container"] = function(__obj) {
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
        var _ref, _ref1;
      
        __out.push('<div class=\'header\'>\n  <span class=\'title\'>selected credentials</span>\n  <span class=\'badge\' style=\'display:none\'>0</span>\n  <a class=\'clear\' style=\'display:none\' title=\'Clear all selected items.\' href=\'javascript:void(0)\'>&times;</a>\n</div>\n\n<div class=\'border\'>\n  <div class=\'padder\'>\n    ');
      
        if (this.groupsFetched) {
          __out.push('\n\n      ');
          if (((_ref = this.groups) != null ? (_ref1 = _ref.models) != null ? _ref1.length : void 0 : void 0) > 0) {
            __out.push('\n        <div style=\'display: none\' class=\'dropdown-container\'>\n          <div class=\'dropdown\'>\n          </div>\n        </div>\n      ');
          }
          __out.push('\n\n    ');
        } else {
          __out.push('\n\n      <div style=\'display: none\' class=\'dropdown-container\'>\n        <div class=\'loading\'></div>\n      </div>\n\n    ');
        }
      
        __out.push('\n    <ul class=\'groups\'></ul>\n  </div>\n  ');
      
        __out.push('\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
