(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/creds/new/templates/import"] = function(__obj) {
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
      
        __out.push('<form class="import-form">\n  <div class="file-input-region"></div>\n\n  <div class="user-pass-file-input-region">\n    Username file:\n    <div class="user-file-input-region"></div>\n    Password file:\n    <div class="pass-file-input-region"></div>\n  </div>\n\n  <div class="import-file-input">\n    <label id="import-file-input" style="position: absolute; margin-left: 4px; margin-top: 2px"></label>\n  </div>\n\n  <div class="inline-help" data-field="import-file-input">\n    <a href class="help" data-field="import-file-input" target="_blank">\n      <img src="/assets/icons/silky/information-c0210a97250ec34cc04d6c8ff768012bf9e054abe33c7fcc558f65bf57a1661a.png" />\n    </a>\n    <h3>File Import</h3>\n    <div style="margin-top: 6px;">\n      <p>\n        The Following file types are supported:\n      </p>\n\n      <ul>\n        <li>\n          CSV - A comma separated file that contains plain text credentials or hashes. The file must contain\n          the following header row: username,private_data.\n        </li>\n        <li>\n          TXT - A text file that contains plain text credentials or hashes. Each credential must appear on a\n          separate line. Unless you are using the User/Pass option, you must include the following header row in the file:\n          username,private_data. The file can also be a PWDump file exported from Metasploit.\n        </li>\n        <li>\n          ZIP - A compressed file exported from Metasploit that contains a CSV file of credentials.\n          If the exported file also contained SSH keys, the ZIP file will contain a manifest file that maps\n          SSH keys to usernames.\n        </li>\n      </ul>\n\n    </div>\n  </div>\n\n\n  <div class="import-type">\n    <div class="radio-label">Format</div>\n    <div class="inline-radio">\n      <label>\n        <input name="import[type]" value="csv" type="radio" checked="checked">\n        CSV\n      </label>\n    </div>\n\n    <div class="inline-radio">\n      <label>\n        <input name="import[type]" value="pwdump" type="radio">\n        pwdump\n      </label>\n    </div>\n\n    <div class="inline-radio">\n      <label>\n        <input name="import[type]" value="user_pass" type="radio">\n        User/Pass\n      </label>\n    </div>\n\n    <div class="import-format">\n      <label id="import-format" style="position: absolute; margin-left: 4px; margin-top: 2px"></label>\n    </div>\n\n    <div class="inline-help" data-field="import-format">\n      <a href class="help" data-field="import-format" target="_blank">\n        <img src="/assets/icons/silky/information-c0210a97250ec34cc04d6c8ff768012bf9e054abe33c7fcc558f65bf57a1661a.png" />\n      </a>\n      <h3>Import Format</h3>\n      <div style="margin-top: 6px;">\n        The following file formats are supported:\n\n        <ul>\n          <li>\n            CSV - The contents of the file are comma delimited. You should always use this option\n            unless the imported file is a password dump.\n          </li>\n\n          <li>\n            PWDump - The contents of the file were exported from Metasploit as a password dump.\n            Password dumps only contain credentials that have logins.\n          </li>\n\n          <li>\n            User/Pass - This option will allow you to input separate username and password files using a text file format.\n            These inputs generate credentials for all possible permutations. To enable, input each username or password on its\n            own line without a header. NTLM hashes and plain text passwords are supported.\n          </li>\n\n\n        </ul>\n\n      </div>\n    </div>\n\n\n  </div>\n\n  <hr>\n\n  <div class="password-type">\n    <p>\n      Select the type that will be used for credentials that do not have a type defined in\n      your import file:\n    </p>\n\n\n    <div>\n      <select name="import[password_type]">\n        <option value="plaintext">Plaintext Password</option>\n        <option value="ssh">SSH Key</option>\n        <option value="ntlm">NTLM Hash</option>\n        <option value="non-replayable">Non-Replayable Hash</option>\n      </select>\n\n      <div class="password-help">\n        <div class="password-help-label">\n          <label id="password-type" style="position: absolute; margin-left: 4px; margin-top: 2px"></label>\n        </div>\n\n        <div class="inline-help" data-field="password-type">\n          <a href class="help" data-field="password-type" target="_blank">\n            <img src="/assets/icons/silky/information-c0210a97250ec34cc04d6c8ff768012bf9e054abe33c7fcc558f65bf57a1661a.png" />\n          </a>\n          <h3>Password Type</h3>\n          <div style="margin-top: 6px;">\n            <p>\n              All credentials must have a defined type. You can set the default value for credentials\n              that do not have a type defined in the imported file. If Metasploit imports a credential\n              that has an empty type field, it will automatically assign this type to the credential.\n            </p>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n\n  <hr>\n\n</form>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
