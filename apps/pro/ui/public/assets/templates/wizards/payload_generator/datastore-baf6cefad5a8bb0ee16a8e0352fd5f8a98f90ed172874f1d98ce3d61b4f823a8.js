(function() { this.JST || (this.JST = {}); this.JST["templates/wizards/payload_generator/datastore"] = function(__obj) {
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
        var field, name, val, _i, _len, _ref;
      
        __out.push('<!--\n  Render dependencies:\n  {\n    options: an Array of datastore options to render\n    advancedOptions: an Array of advanced (hidden) options\n    optionsHashName: a name that is prepended to every rendered input\n  }\n-->\n<ul>\n  ');
      
        _ref = this.options;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          val = _ref[_i];
          __out.push('\n    ');
          name = val.name;
          __out.push('\n    ');
          field = "" + this.optionsHashName + "[" + name + "]";
          __out.push('\n    ');
          if (val.type === 'path') {
            __out.push('\n      <span class=\'span-front\'>');
            __out.push(__sanitize(name));
            __out.push('</span>\n      <li class=\'file input front\'>\n    ');
          } else {
            __out.push('\n      <li class=\'');
            __out.push(__sanitize(val.type));
            __out.push(' ');
            __out.push(__sanitize(_.str.underscored(name)));
            __out.push('\' style=\'position:relative;\'>\n    ');
          }
          __out.push('\n    ');
          if (val.type === 'path') {
            __out.push('\n      <label class="');
            if (!val.required) {
              __out.push(__sanitize('no-req'));
            }
            __out.push('" for="');
            __out.push(__sanitize(field));
            __out.push('">File');
            if (val.required) {
              __out.push(__sanitize('*'));
            }
            __out.push('</label>\n    ');
          } else {
            __out.push('\n      <label class="');
            if (!val.required) {
              __out.push(__sanitize('no-req'));
            }
            __out.push('" for="');
            __out.push(__sanitize(field));
            __out.push('">');
            __out.push(__sanitize(name));
            if (val.required) {
              __out.push(__sanitize('*'));
            }
            __out.push('</label>\n    ');
          }
          __out.push('\n    ');
          if (name === 'EXITFUNC') {
            __out.push('\n      <select id=\'');
            __out.push(__sanitize(field));
            __out.push('\' name=\'');
            __out.push(__sanitize(this.optionsHashName));
            __out.push('[EXITFUNC]\'>\n        <option value=\'\' ');
            if (val["default"] === 'none') {
              __out.push(__sanitize('selected'));
            }
            __out.push('>None</option>\n        <option value=\'seh\' ');
            if (val["default"] === 'seh') {
              __out.push(__sanitize('selected'));
            }
            __out.push('>SEH</option>\n        <option value=\'thread\' ');
            if (val["default"] === 'thread') {
              __out.push(__sanitize('selected'));
            }
            __out.push('>Thread</option>\n        <option value=\'process\' ');
            if (val["default"] === 'process') {
              __out.push(__sanitize('selected'));
            }
            __out.push('>Process</option>\n      </select>\n    ');
          } else if (_.contains(['raw', 'string', 'address', 'port', 'integer', 'meterpreterdebuglogging'], val.type)) {
            __out.push('\n      <input id=\'');
            __out.push(__sanitize(field));
            __out.push('\' name=\'');
            __out.push(__sanitize(field));
            __out.push('\' type=\'text\' value=\'');
            __out.push(__sanitize(val["default"]));
            __out.push('\' />\n    ');
          } else if (val.type === 'bool') {
            __out.push('\n      <input name=\'');
            __out.push(__sanitize(field));
            __out.push('\' type=\'hidden\' value=\'false\' />\n      <input id=\'');
            __out.push(__sanitize(field));
            __out.push('\' name=\'');
            __out.push(__sanitize(field));
            __out.push('\' type=\'checkbox\' ');
            __out.push(__sanitize(val["default"] ? 'checked' : void 0));
            __out.push(' value=\'true\' />\n    ');
          } else if (val.type === 'path') {
            __out.push('\n      <input id=\'');
            __out.push(__sanitize(field));
            __out.push('\' name=\'');
            __out.push(__sanitize(field));
            __out.push('\' type=\'file\' />\n    ');
          } else {
            __out.push('\n      <input type=\'hidden\' name=\'');
            __out.push(__sanitize(field));
            __out.push('\' value=\'');
            __out.push(__sanitize(val["default"]));
            __out.push('\' />\n    ');
          }
          __out.push('\n    ');
          if (val.type !== 'path') {
            __out.push('\n      <div class=\'inline-help\' data-field=\'');
            __out.push(__sanitize(field));
            __out.push('\' >\n        <a href=\'javascript: void;\' tabindex=\'-1\' target=\'_blank\' class=\'help\' data-field=\'');
            __out.push(__sanitize(field));
            __out.push('\'>\n          <img src=\'/assets/icons/silky/information-c0210a97250ec34cc04d6c8ff768012bf9e054abe33c7fcc558f65bf57a1661a.png\' alt=\'Information\' />\n        </a>\n        <h3>');
            __out.push(__sanitize(_.humanize(name)));
            __out.push('</h3>\n        <p>\n        ');
            __out.push(__sanitize(val.desc));
            __out.push('\n        </p>\n      </div>\n    ');
          }
          __out.push('\n    </li>\n  ');
        }
      
        __out.push('\n</ul>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
