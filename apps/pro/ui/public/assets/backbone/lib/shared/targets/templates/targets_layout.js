(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/shared/targets/templates/targets_layout"] = function(__obj) {
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
      
        __out.push('<div class="foundation">\n  <div class="row">\n    <div class="large-9 columns">\n      <p>\n        Choose the targets you want to test with the selected credentials from the list below. To refine the list, use the filters to create a custom search query.\n      </p>\n    </div>\n\n    <div class="large-3 columns last"></div>\n  </div>\n\n  <div class="row">\n    <div class="large-9 columns left-side">\n      <h1 class="invisible" data-table-id="targets"></h1>\n      <div class="targets-table"></div>\n    </div>\n    <div class="large-3 columns last right-side">\n\n\n      <div class="btn-arrow add-selection">\n        <span class="icon icon-fb"><span>＋</span></span>\n        <span class="title">Add Target(s) to this list</span>\n      </div>\n\n\n      <div class="target-list"></div>\n\n      <a href="javascript:void(0)" class="btn primary launch disabled">Next</a>\n    </div>\n  </div>\n</div>\n\n\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
