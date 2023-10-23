(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/findings/templates/private_cell_disclosure_dialog"] = function(__obj) {
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
      
        if (this.private_type_humanized === 'SSHKey') {
          __out.push('\n<div class=\'ssh-key-fingerprint\'>\n  <h4>Fingerprint:</h4>\n\n  <div>');
          __out.push(__sanitize(this.full_fingerprint));
          __out.push('</div>\n\n</div>\n\n<h4 class="private-key">Private key:</h4>\n');
        }
      
        __out.push('\n\n<div class=\'private-data\'>\n  ');
      
        __out.push(__sanitize(this["private"]));
      
        __out.push('\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
