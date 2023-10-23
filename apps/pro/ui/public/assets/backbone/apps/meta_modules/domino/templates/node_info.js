(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/meta_modules/domino/templates/node_info"] = function(__obj) {
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
      
        __out.push('<label class=\'no-margin\'>Host Name</label>\n<div class=\'host-name\'>\n  ');
      
        if (this.host_name) {
          __out.push('\n    ');
          __out.push(__sanitize(this.host_name));
          __out.push(' ');
          __out.push(__sanitize(typeof this.address === 'string' ? "(" + this.address + ")" : void 0));
          __out.push('\n  ');
        } else {
          __out.push('\n    ');
          __out.push(__sanitize(this.address));
          __out.push('\n  ');
        }
      
        __out.push('\n</div>\n<hr />\n');
      
        if (this.hasParent) {
          __out.push('\n  <label>Initial Credential Information</label>\n  <div class=\'table\'>\n    <label class=\'left\'>Public</label>\n    <span class=\'right truncate\'>');
          __out.push(__sanitize(this.credInfo["public"]));
          __out.push('</span>\n  </div>\n  <div class=\'table\'>\n    <label class=\'left\'>Private</label>\n    <span class=\'right truncate\'>');
          __out.push(__sanitize(this.credInfo["private"]));
          __out.push('</span>\n  </div>\n  ');
          if ((this.credInfo.realm != null) && this.credInfo.realm.length) {
            __out.push('\n    <div class=\'table\'>\n      <label class=\'left\'>Realm</label>\n      <span class=\'right truncate\'>');
            __out.push(__sanitize(this.credInfo.realm));
            __out.push('</span>\n    </div>\n  ');
          }
          __out.push('\n  <div class=\'table\'>\n    <label class=\'left\'>Service</label>\n    <span class=\'right truncate\'>');
          __out.push(__sanitize(this.credInfo.service_name));
          __out.push('</span>\n  </div>\n  <div class=\'table\'>\n    <label class=\'left\'>Port</label>\n    <span class=\'right truncate\'>');
          __out.push(__sanitize(this.credInfo.service_port));
          __out.push('</span>\n  </div>\n  <div style=\'clear:both\'></div>\n');
        } else {
          __out.push('\n<!--   <label>Initial Session</label>\n  <div class=\'session\'>\n  </div>\n -->  <div style=\'clear:both\'></div>\n');
        }
      
        __out.push('\n<hr />\n<label>Number of Unique Credentials Captured</label>\n<div class=\'unique-creds\'>\n  ');
      
        __out.push(__sanitize(this.captured_creds_count));
      
        __out.push(' credential');
      
        if (this.captured_creds_count !== 1) {
          __out.push(__sanitize('s'));
        }
      
        __out.push('\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
