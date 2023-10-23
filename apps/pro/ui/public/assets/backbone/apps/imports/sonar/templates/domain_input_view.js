(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/imports/sonar/templates/domain_input_view"] = function(__obj) {
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
      
        __out.push('<div class="row">\n\n  <div class="columns small-12">\n    <div id="sonar-domain-input-error-container" class="error-container"></div>\n  </div>\n\n  <div class="columns large-12">\n\n    <div class="inline-block domain">\n      <label for="sonar-domain-input-textbox" hidden>Sonar Domain</label>\n      <input id="sonar-domain-input-textbox" type="text" name="imports[sonar][domain]" placeholder="Example: rapid7.com" value="');
      
        __out.push(__sanitize(this.domainUrl));
      
        __out.push('">\n    </div>\n\n    <div class="inline-block last-seen">\n      <label>\n        Last seen within\n        <input id="sonar-last-seen-input" name="imports[sonar][last_seen]" type="number" min="1" maxlength="3" value="30"/>\n        day(s)\n      </label>\n    </div>\n\n    <div class="inline-block query">\n      <span id="sonar-domain-query-button" class="btn disabled">\n        <input class="generic" name="commit" type="submit" value="Query">\n      </span>\n    </div>\n\n\n  </div>\n\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
