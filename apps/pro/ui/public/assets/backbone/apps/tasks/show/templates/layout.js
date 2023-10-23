(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/tasks/show/templates/layout"] = function(__obj) {
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
      
        __out.push('<div class="rollup-header"></div>\n<div class="app-stats max-width" style="padding: 0px;">\n  <ul class="rollup-tabs">\n    <li class="selected">\n      <a href="javascript:void(0)">Statistics</a>\n    </li>\n    <li>\n      <a href="javascript:void(0)">Task Log</a>\n    </li>\n  </ul>\n  <div class="rollup-page">\n    <div class="rollup-tab">\n      <div class="stat-row stats-region">\n      </div>\n      <div class="drilldown-padding">\n        <div class="drilldown-area tab-loading">\n        </div>\n      </div>\n    </div>\n    <div class="rollup-tab" style="display: none">\n      <div class="console-area">\n      </div>\n    </div>\n  </div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
