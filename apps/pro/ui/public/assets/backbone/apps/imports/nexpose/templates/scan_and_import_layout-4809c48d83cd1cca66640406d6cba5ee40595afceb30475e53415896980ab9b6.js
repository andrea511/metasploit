(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/imports/nexpose/templates/scan_and_import_layout"] = function(__obj) {
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
        var template, _i, _len, _ref, _ref1;
      
        __out.push('<div class="scan" style="display: block;">\n\n  <li class="text input optional" id="nexpose_scan_task_whitelist_string_input" style="opacity: 1;">\n    <div class="row">\n      <div class="columns large-2"><label class="label" for="nexpose_scan_task_whitelist_string" style="opacity: 1;">Scan targets</label></div>\n      <div class="columns large-10">\n        <textarea id="nexpose_scan_task_whitelist_string" name="nexpose_scan_task[whitelist_string]" rows="20" style="opacity: 1;">');
      
        __out.push(__sanitize((_ref = this.addresses) != null ? _ref[0] : void 0));
      
        __out.push('</textarea>\n      </div>\n    </div>\n\n\n  </li>\n\n  <li class="text input optional" id="nexpose_scan_task_blacklist_string_input" style="opacity: 1;">\n    <div class="row">\n      <div class="columns large-2"><label class="label" for="nexpose_scan_task_blacklist_string" style="opacity: 1;">Excluded Addresses</label></div>\n      <div class="columns large-10">    <textarea id="nexpose_scan_task_blacklist_string" name="nexpose_scan_task[blacklist_string]" rows="20" style="opacity: 1;"></textarea></div>\n    </div>\n  </li>\n\n  <li class="select input optional" id="nexpose_scan_task_scan_template_input" style="opacity: 1;">\n    <div class="row">\n      <div class="columns large-2">\n        <label class="label" for="nexpose_scan_task_scan_template" style="opacity: 1;">Scan template</label>\n      </div>\n\n      <div class="columns large-10 align-left">\n        <select id="nexpose_scan_task_scan_template" name="nexpose_scan_task[scan_template]" style="opacity: 1;">\n          ');
      
        _ref1 = this.templates;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          template = _ref1[_i];
          __out.push('\n            <option value="');
          __out.push(__sanitize(template.scan_template_id));
          __out.push('">');
          __out.push(__sanitize(template.name));
          __out.push('</option>\n          ');
        }
      
        __out.push('\n        </select>\n      </div>\n    </div>\n  </li>\n\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
