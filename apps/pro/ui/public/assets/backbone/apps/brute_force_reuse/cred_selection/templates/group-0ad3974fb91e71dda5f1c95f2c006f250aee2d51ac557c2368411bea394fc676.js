(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_reuse/cred_selection/templates/group"] = function(__obj) {
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
        var klass;
      
        __out.push('\n');
      
        if (!this.working) {
          __out.push('\n  ');
          klass = this.expanded ? 'contract' : 'expand';
          __out.push('\n  <div class=\'group-row\'>\n    <a class=\'');
          __out.push(__sanitize(klass));
          __out.push('\' href=\'javascript:void(0)\' title=\'Show creds in this group\'></a>\n\n    <span class=\'name\'>\n      ');
          __out.push(__sanitize(this.name));
          __out.push('\n    </span>\n\n    <a class=\'right delete\' href=\'javascript:void(0)\'>\n      &times;\n    </a>\n  </div>\n');
        }
      
        __out.push('\n\n');
      
        if (this.loading) {
          __out.push('\n  \n  <p>\n    <div class=\'loading\'></div>\n  </p>\n\n  <ul class=\'cred-rows\'>\n  </ul>\n\n');
        } else if (this.working) {
          __out.push('\n\n  <ul class=\'cred-rows\'>\n  </ul>\n\n');
        } else if (this.expanded) {
          __out.push('\n\n  <ul class=\'cred-rows\'>\n  </ul>\n\n');
        } else {
          __out.push('\n\n  <ul class=\'cred-rows\' style=\'display:none\'>\n  </ul>\n\n');
        }
      
        __out.push('\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
