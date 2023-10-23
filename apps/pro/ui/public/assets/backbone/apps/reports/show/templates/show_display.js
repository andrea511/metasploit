(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/reports/show/templates/show_display"] = function(__obj) {
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
      
        __out.push('<div id="report-display-panel">\n  <div id="unembeddable-message" class="report-display-panel-message">\n    <span>This filetype cannot be previewed in the browser.</span>\n  </div>\n  <div id="no-artifacts-message" class="report-display-panel-message">\n    <span>No report formats remaining for this report. Please click a format button on the left to begin regenerating this report.</span>\n  </div>\n  <div id="broken-artifact-message" class="report-display-panel-message">\n    <span>There was an error displaying the report. The report artifact file could not be found on the filesystem. Please delete and regenerate the file formats.</span>\n  </div>\n</div>\n\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
