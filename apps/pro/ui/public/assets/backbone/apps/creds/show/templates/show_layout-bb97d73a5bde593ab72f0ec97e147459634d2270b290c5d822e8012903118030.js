(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/show/templates/show_layout"] = function(__obj) {
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
      
        __out.push('<div class=\'fixed\'>\n  <div id="banner-region" class="foundation">\n    <div id="single-cred-header">\n      <ul>\n        <li>\n          <div>\n            PUBLIC\n          </div>\n          <div class="black">\n            ');
      
        __out.push(this.publicUsernameLink());
      
        __out.push('\n          </div>\n        </li>\n\n        <li>\n          <div>\n            PRIVATE\n          </div>\n          <div class="black private-region" >\n\n          </div>\n        </li>\n\n        <li>\n          <div>\n            PRIVATE TYPE\n          </div>\n          <div class="black">\n            ');
      
        __out.push(this.privateTypeLink());
      
        __out.push('\n          </div>\n        </li>\n\n        <li>\n          <div>\n            REALM\n          </div>\n          <div class="black">\n            ');
      
        __out.push(this.realmKeyLink());
      
        __out.push('\n          </div>\n        </li>\n\n        <li>\n          <div>\n            ORIGIN\n          </div>\n          <div class="origin-region">\n          </div>\n        </li>\n\n        <li class="tags">\n          <div>\n            <span class="count">4</span> Tags\n          </div>\n        </li>\n\n        <li class="quick-reuse">\n          <a href="javascript:void(0)" class="btn primary launch">Reuse</a>\n        </li>\n\n      </ul>\n    </div>\n  </div>\n\n\n\n  <div class=\'sub-header foundation\'>\n    <div class="row">\n      <div class=\'hang\'>\n        <div class="columns small-5 white">\n        </div>\n\n        <div class="columns small-7 grey"></div>\n\n        <!--\n        <div class="columns small-2 grey">\n          <span class=\'large display-none\'>&#10003;</span> <span class=\'subtext display-none\'>validated</span>\n        </div>\n\n        <div class="columns small-2 grey">\n          <span class="instance-count display-none">457</span> <span class=\'subtext display-none\'>logins</span>\n        </div>\n\n        <div class="columns small-3 grey">\n          <div class="rainbow-progress-wrapper display-none" clickable="true">\n            <canvas class="compromised-progress" height="40px" width="84px"></canvas>\n            <div class="compromised-text">network compromised</div>\n          </div>\n        </div>\n        -->\n\n\n      </div>\n    </div>\n  </div>\n</div>\n\n\n<div id=\'related-logins-region\'>\n</div>\n\n\n\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
