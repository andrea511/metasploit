(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/imports/index/templates/index_layout"] = function(__obj) {
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
      
        __out.push('<fieldset class="shared">\n  <legend><span>Import Data</span></legend>\n\n\n  <div class="row v-padding import-type-select-region"></div>\n\n  <div class="row main-import-view-region"></div>\n\n  <div class="row">\n    <div class="row tags-label">\n      <div class="columns small-2 left-text">\n          <span class="collapse left-align">▼</span><span class="expand left-align">▶</span>&nbsp;Automatic Tagging (Optional)\n      </div>\n      <div class="columns small-8 empty"></div>\n    </div>\n\n    <div class="row tags-pane">\n      <div class="row">\n        <div class="columns small-1 add-tags">Add Tags</div>\n        <div class="columns small-3">\n            <div class="row tags-region"></div>\n            <div class="row">\n              <label>\n                <input type="checkbox" name="imports[autotag_os]">\n                Automatically Tag by OS\n              </label>\n            </div>\n        </div>\n        <div class="columns small-8 empty"></div>\n      </div>\n    </div>\n\n\n\n  </div>\n\n</fieldset>\n\n<div class="row">\n  <div class="columns large-12">\n    <div class="columns large-9 empty">\n\n    </div>\n\n    <div class="columns large-2 align-right">\n      <input id="update_hosts" type="checkbox" name="import[update_hosts]" ><label for="update_hosts">Don\'t change existing hosts</label>\n    </div>\n\n\n    ');
      
        if (this.showTypeSelection) {
          __out.push('\n      <div class="columns large-1 align-right">\n      <span class="btn disabled import-btn">\n        <input class="import" id="popup_submit" name="commit" type="submit" value="Import Data">\n      </span>\n      </div>\n    ');
        }
      
        __out.push('\n\n  </div>\n\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
