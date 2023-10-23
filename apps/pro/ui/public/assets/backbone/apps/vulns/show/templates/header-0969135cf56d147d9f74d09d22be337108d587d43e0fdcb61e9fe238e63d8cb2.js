(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/vulns/show/templates/header"] = function(__obj) {
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
      
        __out.push('<div id="banner-region" class="foundation">\n  <div id="single-vuln-header">\n    <div class="row">\n      <div class="columns small-6 vuln-name">\n        <h5>\n          Name\n          <a class="pencil" href="javascript:void(0)"></a>\n        </h5>\n        <div class=\'strong\'>\n          ');
      
        __out.push(__sanitize(this.name));
      
        __out.push('\n        </div>\n      </div>\n\n      <div class="columns small-3 host">\n        <h5>\n          Host\n        </h5>\n\n        <div>\n          <a href=\'/hosts/');
      
        __out.push(__sanitize(this.host.id));
      
        __out.push('\'>');
      
        __out.push(__sanitize(this.host.address));
      
        __out.push('</a>\n          ');
      
        if (this.service) {
          __out.push('\n            <span class=\'strong\'>(');
          __out.push(__sanitize(this.service.name));
          __out.push(')</span>\n          ');
        }
      
        __out.push('\n        </div>\n\n        <div>\n          <span class=\'light\'>');
      
        __out.push(__sanitize(this.host.name));
      
        __out.push('</span>\n        </div>\n\n        <ul class="os-icons">\n          ');
      
        if (this.host.is_vm_guest) {
          __out.push('\n            <li><span class="vm-badge">VM</span></li>\n          ');
        }
      
        __out.push('\n          <li>');
      
        __out.push(this.host.os_icon_html);
      
        __out.push('</li>\n        </ul>\n\n      </div>\n\n      <div class="columns small-3 vuln-refs">\n        <h5>\n          References\n          <a class="pencil" href="javascript:void(0)"></a>\n        </h5>\n\n        <div class=\'refs\'>\n          ');
      
        __out.push('\n          ');
      
        __out.push('\n          ');
      
        __out.push(this.refs.map(function(ref) {
          return ref.html_link;
        }).join(''));
      
        __out.push('\n          <a class=\'more\'>More…</a>\n        </div>\n\n      </div>\n\n     </div>\n  </div>\n\n</div>\n\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
