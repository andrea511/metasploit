(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/logins/new/templates/form"] = function(__obj) {
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
        var host, service, _i, _j, _len, _len1, _ref, _ref1;
      
        __out.push('<div style=\'clear:both;margin-top:10px;\'>\n  <select class="host" name="host[id]">\n    ');
      
        _ref = this.hosts;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          host = _ref[_i];
          __out.push('\n    <option value="');
          __out.push(__sanitize(host.id));
          __out.push('">');
          __out.push(__sanitize(host.name));
          __out.push('/');
          __out.push(__sanitize(host.address));
          __out.push('</option>\n    ');
        }
      
        __out.push('\n  </select>\n  <label for="host">Host</label>\n</div>\n\n\n<div class=\'clear-floats\'>\n  <select id="service" name="service">\n    ');
      
        _ref1 = this.services;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          service = _ref1[_j];
          __out.push('\n    <option value="');
          __out.push(__sanitize(service.id));
          __out.push('">');
          __out.push(__sanitize(service.name));
          __out.push('/');
          __out.push(__sanitize(service.proto));
          __out.push('/');
          __out.push(__sanitize(service.port));
          __out.push('</option>\n    ');
        }
      
        __out.push('\n  </select>\n  <label for="service">Service</label>\n\n</div>\n\n\n<div class="clear-floats access-level-region">\n\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
