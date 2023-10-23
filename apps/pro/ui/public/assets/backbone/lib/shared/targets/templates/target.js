(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/shared/targets/templates/target"] = function(__obj) {
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
      
        __out.push('<div class="title">\n  <span class=\'username\'>');
      
        __out.push(__sanitize(this['host.address']));
      
        __out.push('</span>\n  <span class=\'private\'>');
      
        __out.push(__sanitize(this['name']));
      
        __out.push('</span>\n</div>\n\n<div class="subtitle">\n  ');
      
        __out.push(__sanitize(this['host.name']));
      
        __out.push('&nbsp;\n</div>\n\n<div class="arrow-container">\n  <a class="expand"></a>\n</div>\n\n<div class="toggle-info display-none"><!-- why do i\n  --><div>OS: ');
      
        __out.push(__sanitize(this['host.os_name']));
      
        __out.push('</div><!-- have\n  --><div>Port: ');
      
        __out.push(__sanitize(this['port']));
      
        __out.push('</div><!-- to do this?\n  --><div>Protocol: ');
      
        __out.push(__sanitize(this['proto']));
      
        __out.push('</div><!--\n  --><div>');
      
        __out.push(__sanitize(this['info']));
      
        __out.push('</div><!--\n--></div>\n\n<a class=\'right delete\' title=\'Remove this credential from the selection.\' href=\'javascript:void(0)\'>\n  <span>\n    &times;\n  </span>\n</a>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
