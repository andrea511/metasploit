(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/imports/file/templates/file_layout"] = function(__obj) {
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
      
        __out.push('<form>\n  <div class="columns large-12 shared boxes">\n    <div class="row">\n      <div class="columns small-12">\n        <div class="error-container"></div>\n      </div>\n    </div>\n\n    <div class="row">\n      <div class="columns small-12">\n        <div class="row">\n          <div class="columns small-2 empty"></div>\n          <div class="columns small-10">\n            <div class="last-uploaded" style="display: none;"></div>\n            <input type=\'hidden\' name=\'use_last_uploaded\'>\n          </div>\n        </div>\n\n        <div class="file-input-region"></div>\n        <div>\n          <ul>\n            <li class="text input optional" id="nexpose_scan_task_blacklist_string_input" style="opacity: 1;">\n              <div class="row">\n                <div class="columns large-2"><label class="label" for="nexpose_scan_task_blacklist_string" style="opacity: 1;">Excluded Addresses</label></div>\n                <div class="columns large-10">\n                  <textarea id="nexpose_scan_task_blacklist_string" name="blacklist_string" rows="20" style="opacity: 1;"></textarea>\n                </div>\n              </div>\n            </li>\n          </ul>\n        </div>\n      </div>\n    </div>\n  </div>\n</form>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
