(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_guess/quick/templates/quick_layout"] = function(__obj) {
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
      
        __out.push('<form>\n  ');
      
        if (!this.taskChain) {
          __out.push('\n  <div class="header-region content-container">\n    <h1>Bruteforce</h1>\n  </div>\n  ');
        }
      
        __out.push('\n\n  <div class="content-region content-container">\n    <div class="foundation">\n      <div class="row"></div>\n      <div class="row">\n        <div class="columns small-8">\n          Bruteforce systematically attempts to use credentials to authenticate to services on target hosts.\n          Select the hosts and services you want to bruteforce and the credentials you want to use to attempt authentication.\n        </div>\n      </div>\n\n\n      <div class="row breadcrumbs space">\n\n      </div>\n\n      <div class="row box-container">\n        <div id="targets-region" class="columns large-4"></div>\n        <div id="creds-region" class="columns large-4"></div>\n        <div id="options-region" class="columns large-4"></div>\n      </div>\n\n      ');
      
        if (!this.taskChain) {
          __out.push('\n      <div class="row">\n        <div class="columns empty large-10"></div>\n\n        <div class="columns large-2 launch-container">\n          <a href="javascript:void(0)" class="btn primary launch disabled">LAUNCH</a>\n        </div>\n      </div>\n      ');
        }
      
        __out.push('\n\n    </div>\n  </div>\n</form>\n\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
