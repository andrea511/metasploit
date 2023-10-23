(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_reuse/cred_selection/templates/cred_selection_layout"] = function(__obj) {
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
      
        __out.push('<div class="foundation">\n  <div class="row">\n    <div class="large-9 columns">\n      <p class="reuse-title">\n        Choose the credentials that Metasploit will attempt to use to authenticate to the selected target list below.\n      </p>\n    </div>\n\n    <div class="large-3 columns"></div>\n  </div>\n\n  <div class="row">\n    <div class="large-9 columns left-side">\n      <h1 class="invisible" data-table-id="reuse-creds"></h1>\n      <div class="creds-table"></div>\n    </div>\n    <div class="large-3 columns last right-side">\n      <div class="btn-arrow add-selection">\n        <span class="icon icon-fb"><span>＋</span></span>\n        <span class="title">Add Credential(s) to this list</span>\n      </div>\n      <div class="creds-groups"></div>\n      <a href="javascript:void(0)" class="btn primary launch disabled">Next</a>\n    </div>\n  </div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
