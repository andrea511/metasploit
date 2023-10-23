(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_guess/quick/templates/creds_view"] = function(__obj) {
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
      
        __out.push('<fieldset>\n\n\n  <div class="columns large-12 count">\n    <span class="cred-count">0</span><span class="fuzz">+</span> possible combinations\n  </div>\n\n  <div class="columns large-12">\n    <label>\n      <input type="checkbox" name="quick_bruteforce[creds][import_workspace_creds]" />\n      All credentials in this project\n    </label>\n  </div>\n\n  <div class="columns large-12">\n    <label>\n      <input type="checkbox" name="quick_bruteforce[creds][factory_defaults]" />\n      Attempt factory defaults\n    </label>\n  </div>\n\n  <div class="columns large-12">\n    <label>\n      <input type="checkbox" name="quick_bruteforce[creds][add_import_cred_pairs]"/>\n      Add/Import credential pairs\n    </label>\n  </div>\n\n  <div class="columns large-12">\n    <div class="mutation-label"><span>Mutation selected</span></div>\n    <div class="defaults-label"><span>Factory defaults selected</span></div>\n  </div>\n\n  <div class="columns large-12 space manual-cred-pair" style="display: none;">\n    <div class="row">\n      <div class="columns large-12">\n        Credentials <span class="line-max">(100 lines max)</span>\n      </div>\n\n      <div class="columns large-12">\n        <label style="display: none" for="manual-cred-pair-entry">Manual Cred Pairs</label>\n        <textarea id="manual-cred-pair-entry" name="quick_bruteforce[creds][import_cred_pairs][data]" placeholder="Enter a space and new line delimited list of credential pairs.\n\nExample:\nusername pass\nusername pass1 pass2\nrealm\\username pass\nrealm\\username pass1 pass2\n"></textarea>\n      </div>\n    </div>\n  </div>\n\n  <div class="columns large-12 space">\n    <div class="row manual-cred-pair" style="display: none;">\n      <div class="columns large-12">\n        <input type="hidden" name=\'quick_bruteforce[creds][import_cred_pairs][use_file_contents]\'>\n        <input type=\'hidden\' name=\'quick_bruteforce[use_last_uploaded]\'>\n        <input type=\'hidden\' name=\'text_area_status\'>\n        <input type=\'hidden\' name=\'import_pair_count\'>\n        <input type="hidden" name=\'text_area_count\'>\n        <input type="hidden" name="file_pair_count">\n        <input type="hidden" name="clone_file_warning">\n        <div class="last-uploaded" style="display: none;">\n        </div>\n      </div>\n\n      <div class="cred-file-upload-region">\n          <div class="columns large-12">\n            Import Credentials from a file:\n          </div>\n\n          <div class="columns large-12">\n            <div class="cancel file-input">&times;</div>\n            <div class="file-upload-region"></div>\n          </div>\n      </div>\n\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="quick_bruteforce[creds][import_cred_pairs][blank_as_password]"/>\n          Use &lt;BLANK&gt; as password\n        </label>\n      </div>\n\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="quick_bruteforce[creds][import_cred_pairs][username_as_password]"/>\n          Use username as password\n        </label>\n      </div>\n\n    </div>\n  </div>\n\n</fieldset>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
