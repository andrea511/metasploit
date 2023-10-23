(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/reports/show/templates/show_info_dialog"] = function(__obj) {
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
        var address, option, section, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2, _ref3;
      
        __out.push('<div class="row">\n  <div class="label">Report Name</div>\n  <div class="value">');
      
        __out.push(__sanitize(this.name));
      
        __out.push('</div>\n</div>\n\n<div class="row">\n  <div class="label">Report Type</div>\n  <div class="value">');
      
        __out.push(__sanitize(this.pretty_report_type));
      
        __out.push('</div>\n</div>\n\n<div class="row">\n  <div class="label">Created</div>\n  <div class="value">');
      
        __out.push(__sanitize(this.pretty_created_at));
      
        __out.push('</div>\n</div>\n\n<div class="row">\n  <div class="label">Created By</div>\n  <div class="value">');
      
        __out.push(__sanitize(this.created_by));
      
        __out.push('</div>\n</div>\n\n<div class="row">\n  <div class="label">Report Sections Selected</div>\n  <div class="value">\n    <ul>\n      ');
      
        _ref = this.sections;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          section = _ref[_i];
          __out.push('\n        <li>');
          __out.push(__sanitize(section.name));
          __out.push('</li>\n      ');
        }
      
        __out.push('\n    </ul>\n  </div>\n</div>\n\n<div class="row">\n  <div class="label">Report Options Selected</div>\n  <div class="value">\n    <ul>\n      ');
      
        _ref1 = this.options;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          option = _ref1[_j];
          __out.push('\n        <li>');
          __out.push(__sanitize(option.name));
          __out.push('</li>\n      ');
        }
      
        __out.push('\n    </ul>\n  </div>\n</div>\n\n');
      
        if (this.included_addresses.size() > 1 || this.excluded_addresses.size() > 1) {
          __out.push('\n  <div class="row">\n    <div class="label">Addresses</div>\n    <div class="value">\n      <div class="col">\n        <div class="col-header">Included</div>\n        <ul>\n          ');
          _ref2 = this.included_addresses;
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            address = _ref2[_k];
            __out.push('\n            <li>');
            __out.push(__sanitize(address));
            __out.push('</li>\n          ');
          }
          __out.push('\n        </ul>\n      </div>\n      <div class="col">\n        <div class="col-header">Excluded</div>\n        <ul>\n          ');
          _ref3 = this.excluded_addresses;
          for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
            address = _ref3[_l];
            __out.push('\n            <li>');
            __out.push(__sanitize(address));
            __out.push('</li>\n          ');
          }
          __out.push('\n        </ul>\n      </div>\n    </div>\n  </div>\n');
        }
      
        __out.push('\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
