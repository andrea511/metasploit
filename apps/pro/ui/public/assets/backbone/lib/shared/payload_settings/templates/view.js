(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/shared/payload_settings/templates/view"] = function(__obj) {
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
        var macro, type, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      
        __out.push('<form>\n  <div class="foundation">\n    <div class="row">\n      <div class="columns large-6">\n        <label> Payload Type</label>\n      </div>\n\n      <div class="columns large-6">\n        <select name="payload_settings[payload_type]">\n          ');
      
        _ref = this.PAYLOAD_TYPE;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          type = _ref[_i];
          __out.push('\n            <option value="');
          __out.push(__sanitize(type));
          __out.push('">');
          __out.push(__sanitize(type));
          __out.push('</option>\n          ');
        }
      
        __out.push('\n        </select>\n      </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-6">\n        <label>Connection Type</label>\n      </div>\n\n      <div class="columns large-6">\n        <select name="payload_settings[connection_type]">\n          ');
      
        _ref1 = this.CONNECTION_TYPE;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          type = _ref1[_j];
          __out.push('\n          <option value="');
          __out.push(__sanitize(type));
          __out.push('">');
          __out.push(__sanitize(type));
          __out.push('</option>\n          ');
        }
      
        __out.push('\n        </select>\n      </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-6">\n        <label>Listener Ports</label>\n      </div>\n\n      <div class="columns large-6">\n        <input type="text" name="payload_settings[listener_ports]" />\n      </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-6">\n        <label>Listener Host</label>\n      </div>\n\n      <div class="columns large-6">\n        <input type="text" name="payload_settings[listener_host]" />\n      </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-6">\n        <label>Auto Launch Macro</label>\n      </div>\n\n      <div class="columns large-6">\n        <select name="payload_settings[macro]">\n          <option value=""></option>\n          ');
      
        _ref2 = this.macros;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          macro = _ref2[_k];
          __out.push('\n          <option value="');
          __out.push(__sanitize(macro.id));
          __out.push('">');
          __out.push(__sanitize(macro.name));
          __out.push('</option>\n          ');
        }
      
        __out.push('\n        </select>\n      </div>\n    </div>\n\n    <div class="row">\n\n      <div class="columns large-12">\n        <div>\n          <label>\n            <input type="checkbox" name="payload_settings[session_per_host]" />\n            Obtain only one session per host\n          </label>\n        </div>\n      </div>\n\n    </div>\n\n    <div class="row">\n\n      <div class="columns large-12">\n        <div>\n          <label>\n            <input type="checkbox" name="payload_settings[dynamic_stagers]" />\n            Use Dynamic Stagers for EXE payloads (AV evasion)\n          </label>\n        </div>\n      </div>\n\n    </div>\n\n    <div class="row">\n\n      <div class="columns large-12">\n        <div>\n          <label>\n          <input type="checkbox" name="payload_settings[ips_evasion]" />\n          Enable Stage Encoding (IPS evasion)\n        </label>\n       </div>\n      </div>\n\n    </div>\n\n  </div>\n</form>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
