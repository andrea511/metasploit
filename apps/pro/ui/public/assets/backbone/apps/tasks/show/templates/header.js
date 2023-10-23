(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/tasks/show/templates/header"] = function(__obj) {
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
      
        __out.push('<div class="max-width clear">\n  <div class="task-status">\n    <h3>');
      
        __out.push(__sanitize(this.description));
      
        __out.push('</h3>\n    ');
      
        if (this.app_run_status != null) {
          __out.push('\n      <label class="status ');
          __out.push(__sanitize(_.str.underscored(this.app_run_status)));
          __out.push('">\n        ');
          __out.push(__sanitize(_.str.humanize(this.app_run_status)));
          __out.push('\n      </label>\n    ');
        } else {
          __out.push('\n      <label class="status ');
          __out.push(__sanitize(this.state));
          __out.push('">\n        ');
          __out.push(__sanitize(this.state.capitalize()));
          __out.push('\n      </label>\n    ');
        }
      
        __out.push('\n</div>\n\n  <div class="control-buttons">\n    ');
      
        if (this.running) {
          __out.push('\n\n      ');
          if (this.pausable) {
            __out.push('\n        <div class="control-button" id="pause"><label>Pause</label></div>\n      ');
          }
          __out.push('\n\n      <div class="control-button" id="stop">Stop</div>\n\n    ');
        } else if (this.paused) {
          __out.push('\n\n      <div class="control-button" id="resume"><label>Resume</label></div>\n\n      <div class="control-button" id="stop">Stop</div>\n\n    ');
        }
      
        __out.push('\n\n    <div class="retina spinner"></div>\n  </div>\n\n  <div class="clearfix"></div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
