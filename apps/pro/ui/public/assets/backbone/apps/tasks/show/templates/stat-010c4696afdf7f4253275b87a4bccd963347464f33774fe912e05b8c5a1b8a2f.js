(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/tasks/show/templates/stat"] = function(__obj) {
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
        var _ref;
      
        if (this.schema.badge != null) {
          __out.push('\n  <div class=\'stat-badge\' style=\'display: none\'>\n    <span></span>\n  </div>\n');
        }
      
        __out.push('\n\n');
      
        if (((_ref = this.schema) != null ? _ref.type : void 0) === 'percentage') {
          __out.push('\n\n  <div class="pie-chart-wrapper load-table" clickable="false">\n    <div class="pie-chart">\n      <canvas width="70px" height="80px" style=\'margin-top: 8px;\'></canvas>\n    </div>\n    <label class="stat run-stat">\n      <span class=\'numStat\'></span>/<span class=\'totalStat\'></span>\n    </label>\n    <label class="desc">\n      ');
          __out.push(__sanitize(_.str.humanize(this.title)));
          __out.push('\n    </label>\n  </div>\n\n');
        } else {
          __out.push('\n\n  <div class="big-stat center load-table" clickable="false">\n    <span class="stat run-stat numStat"></span>\n    <label>\n      <span>');
          __out.push(__sanitize(_.str.humanize(this.title)));
          __out.push('</span>\n    </label>\n  </div>\n\n');
        }
      
        __out.push('\n\n<div class=\'lil-nubster\'></div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
