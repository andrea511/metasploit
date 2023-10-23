(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/imports/nexpose/templates/site_import_layout"] = function(__obj) {
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
        var console, id, _ref;
      
        __out.push('<div class="columns large-12 shared boxes">\n  <div class="row">\n    <div class="columns small-12">\n      <div class="error-container"></div>\n    </div>\n  </div>\n\n  <div class="row">\n    <div class="columns large-2">\n      <select name="imports[nexpose_console]" class="imports_nexpose_console_select">\n        <option value="none">Choose a nexpose console...</option>\n        ');
      
        _ref = this.consoles;
        for (console in _ref) {
          id = _ref[console];
          __out.push('\n        <option value="');
          __out.push(__sanitize(id));
          __out.push('">');
          __out.push(__sanitize(console));
          __out.push('</option>\n        ');
        }
      
        __out.push('\n      </select>\n    </div>\n\n    <div class="columns large-10">\n      <div class="circle-container">\n        <div class="shared circle">+</div>\n      </div>\n\n      <div class="circle-label">\n        <a href="javascript:void(0)" class="configure-nexpose">Configure a Nexpose Console</a>\n      </div>\n    </div>\n\n  </div>\n\n  <div class="row v-padding">\n    <div class="columns large-2">\n      <input id="existing" type="radio" name="imports[nexpose][type]" checked="checked" value="import_site"/><label for="existing">Import existing data</label>\n    </div>\n    <div class="columns large-10 push-left">\n      <input id="scan-and-import" type="radio" name="imports[nexpose][type]" value="scan_and_import"/><label for="scan-and-import">Scan and import data</label>\n    </div>\n  </div>\n\n  <div class="row v-padding site-area">\n    <div class="nexpose-sites-region columns small-12"></div>\n  </div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
