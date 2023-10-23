(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/shared/nexpose_console/templates/form"] = function(__obj) {
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
      
        __out.push('<div class="nexpose_console_form">\n  <form action="/" method="POST" class="form formtastic nexpose_console">\n    <li class="console_name">\n      <label for="nexpose_console[name]">Name</label>\n      <input name="nexpose_console[name]" id="nexpose_console[name]" type="text">\n    </li>\n    <li class="console_address">\n      <label for="nexpose_console[address]">Address</label>\n      <input name="nexpose_console[address]" id="nexpose_console[address]" type="text">\n    </li>\n    <li class="console_port">\n      <label for="nexpose_console[port]">Port</label>\n      <input name="nexpose_console[port]" id="nexpose_console[port]" type="text">\n    </li>\n    <li class="console_username">\n      <label for="nexpose_console[username]">Username</label>\n      <input name="nexpose_console[username]" id="nexpose_console[username]" type="text">\n    </li>\n    <li class="console_password">\n      <label for="nexpose_console[password]">Password</label>\n      <input name="nexpose_console[password]" id="nexpose_console[password]" type="password">\n    </li>\n  </form>\n  <div class="connectivity">\n    <div class="connection_success">\n      Connected successfully.\n    </div>\n    <div class="connection_error">\n      Connection failed.\n    </div>\n  </div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
