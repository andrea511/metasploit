(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/components/filter/templates/help"] = function(__obj) {
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
        var k, _i, _len, _ref;
      
        __out.push('<p style=\'margin-bottom:12px\'>\nClick on the search field to view the search operators that are available. Select a search operator from the list and enter the keyword you want to use to filter the Sonar results. As you start typing, the search field displays the possible keywords that are available for the selected operator. You can use as many search operator and keyword combinations as you need.\nHere\'s a quick look at what each search operator does:\n</p>\n\n');
      
        _ref = _.keys(this.model.attributes).sort();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          k = _ref[_i];
          __out.push('\n  ');
          if (_.contains(this.whitelist, _.str.trim(k))) {
            __out.push('\n    <div class=\'filter-row\'>\n      <h5>');
            __out.push(__sanitize(k));
            __out.push('</h5>\n      <p>');
            __out.push(__sanitize(this.model.get(k)));
            __out.push('</p>\n    </div>\n  ');
          }
          __out.push('\n');
        }
      
        __out.push('\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
