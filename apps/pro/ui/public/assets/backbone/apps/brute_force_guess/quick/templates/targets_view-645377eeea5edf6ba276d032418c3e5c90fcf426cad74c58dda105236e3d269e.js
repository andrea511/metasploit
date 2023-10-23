(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_guess/quick/templates/targets_view"] = function(__obj) {
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
        var i, service, _i, _len, _ref;
      
        __out.push('<fieldset>\n\n  <div class="columns large-12 count">\n    <span class="target-count">0</span> targets selected\n  </div>\n\n  <div class="columns large-12">\n    Selected Host(s):\n  </div>\n\n  <div class="columns large-12">\n    <label>\n      <input class="all-hosts" type="radio" name="quick_bruteforce[targets][type]" value="all" checked="checked" />\n      All hosts\n    </label>\n  </div>\n\n  <div class="columns large-12">\n    <label>\n      <input class="manual-hosts" type="radio" name="quick_bruteforce[targets][type]" value="manual" />\n      Enter target addresses\n    </label>\n  </div>\n\n   <div class="columns large-12 addresses" style="display: none;">\n    <div class="large-12 space">\n      <div class="row">\n        <div class="columns small-5">\n          <div>Target addresses:</div>\n        </div>\n\n        <div class="columns small-7 target-addresses-tooltip-region">\n\n        </div>\n\n\n      </div>\n\n      <div class="row">\n        <div class="columns small-12 space">\n          <textarea id="manual-target-entry" name="quick_bruteforce[targets][whitelist_hosts]"></textarea>\n        </div>\n      </div>\n\n    </div>\n\n    <div class="large-12 space">\n      <div class="row">\n        <div class="columns small-5">\n          <div>Excluded addresses:</div>\n        </div>\n\n        <div class="columns small-7 blacklist-addresses-tooltip-region">\n\n        </div>\n\n      </div>\n\n      <div class="row">\n        <div class="columns small-12 space">\n          <textarea id="manual-target-entry-blacklist" name="quick_bruteforce[targets][blacklist_hosts]"></textarea>\n        </div>\n      </div>\n\n    </div>\n  </div>\n\n  <div class="columns large-12">\n    <hr />\n  </div>\n\n  <div class="large-12 columns space services">\n    <div class="row">\n      <div class="columns large-12">\n        Select services:\n      </div>\n\n      <div class="columns large-12">\n        <label>\n          <input class="all-services" name="quick_bruteforce[targets][all_services]" type="checkbox" />\n          All services\n        </label>\n      </div>\n\n      <div class="row">\n        <div class="columns large-12">\n          ');
      
        _ref = this.SERVICES;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          service = _ref[i];
          __out.push('\n            ');
          if (i % 3 === 0 && i > 0) {
            __out.push('\n              </div></div><div class="row"><div class="columns large-12">\n            ');
          }
          __out.push('\n\n            <div class="columns large-4 service">\n              <label>\n                <input type="checkbox" name="quick_bruteforce[targets][services][');
          __out.push(__sanitize(service));
          __out.push(']"/>');
          __out.push(__sanitize(service === "SSH_PUBKEY" ? "SSH PUBKEY" : service));
          __out.push('\n              </label>\n            </div>\n\n\n            ');
          if (i >= this.SERVICES.length - 1) {
            __out.push('\n              <div class="columns large-4">\n\n              </div>\n\n              ');
            if (i >= this.SERVICES.length) {
              __out.push('\n                <div class="columns large-4">\n\n                </div>\n              ');
            }
            __out.push('\n            ');
          }
          __out.push('\n          ');
        }
      
        __out.push('\n        </div>\n      </div>\n     </div>\n  </div>\n\n</fieldset>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
