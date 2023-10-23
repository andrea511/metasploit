(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_guess/quick/templates/options_view"] = function(__obj) {
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
      
        __out.push('<fieldset>\n\n  <div class="columns large-12">\n    <div class="columns large-4">\n      <div class="row">\n        Overall Timeout\n      </div>\n    </div>\n\n    <div class="columns large-8">\n      <div class="columns large-3">\n        <div class="row">\n          <label style="display: none" for="quick-bruteforce-options-overall-timeout-hour">Bruteforce Options Overall Timeout Hour</label>\n          <input class="time" type="text" value="4" id="quick-bruteforce-options-overall-timeout-hour" name="quick_bruteforce[options][overall_timeout][hour]">\n        </div>\n\n        <div class="row ellipses">\n          Hours\n        </div>\n      </div>\n\n      <div class="columns large-3">\n        <div class="row">\n          <label style="display: none" for="quick-bruteforce-options-overall-timeout-minutes">Bruteforce Options Overall Timeout Minutes</label>\n          <input class="time" type="text" value="0" id="quick-bruteforce-options-overall-timeout-minutes" name="quick_bruteforce[options][overall_timeout][minutes]">\n        </div>\n\n        <div class="row ellipses">\n          Minutes\n        </div>\n      </div>\n\n      <div class="columns large-3">\n        <div class="row">\n          <label style="display: none" for="quick-bruteforce-options-overall-timeout-seconds">Bruteforce Options Overall Timeout Seconds</label>\n          <input class="time" type="text" value="0" id="quick-bruteforce-options-overall-timeout-seconds" name="quick_bruteforce[options][overall_timeout][seconds]">\n        </div>\n\n        <div class="row ellipses">\n          Seconds\n        </div>\n      </div>\n\n      <div class="columns large-3 overall-timeout-tooltip-region"></div>\n    </div>\n  </div>\n\n  <div class="columns large-12">\n    <div class="columns large-4">\n      <div class="row">\n        Service Timeout\n      </div>\n    </div>\n\n    <div class="columns large-8">\n      <div class="columns large-3">\n        <div class="row">\n          <label style="display: none" for="quick-bruteforce-options-service-timeout">Bruteforce Options Service Timeout</label>\n          <input class="time" type="text" value="900" id="quick-bruteforce-options-service-timeout" name="quick_bruteforce[options][service_timeout]">\n        </div>\n\n        <div class="row">\n          Seconds\n        </div>\n      </div>\n\n      <div class="columns large-6">\n\n      </div>\n\n      <div class="columns large-3 service-timeout-tooltip-region"></div>\n    </div>\n  </div>\n\n  <div class="columns large-12">\n    <div class="columns large-4">\n      <div class="row">\n        Time Between Attempts\n      </div>\n    </div>\n\n    <div class="columns large-8">\n      <div class="columns large-9">\n        <div class="row">\n          <select class="time-between-attempts" name="quick_bruteforce[options][time_between_attempts]">\n            <option value="5">None (0 seconds)</option>\n            <option value="4">Aggressive (0.1 seconds)</option>\n            <option value="3">Normal (0.5 seconds)</option>\n            <option value="2">Polite (1 second)</option>\n            <option value="1">Sneaky (15 seconds)</option>\n            <option value="0">Glacial (5 minutes)</option>\n          </select>\n        </div>\n      </div>\n\n      <div class="columns large-3 time-tooltip-region"></div>\n    </div>\n  </div>\n\n  <div class="columns large-12">\n    <hr />\n  </div>\n\n  <div class="columns large-12 bottom-options">\n    <div class="columns large-7">\n      <div class="row">\n        <label>\n          <input type="checkbox" name="quick_bruteforce[options][mutation]" />\n          <div>Apply mutation(s) </div>\n        </label>\n      </div>\n    </div>\n\n    <div class="columns large-5">\n      <div class="columns large-7 empty">\n\n      </div>\n      <div class=" columns large-5 mutation-tooltip-region">\n\n      </div>\n    </div>\n  </div>\n\n\n  <div class="columns large-12 bottom-options">\n    <label>\n      <input type="checkbox" name="quick_bruteforce[options][stop_on_guess]" />\n      <div>Stop bruteforcing a target when a credential is guessed</div>\n    </label>\n  </div>\n\n\n  <div class="columns large-12 bottom-options">\n    <div class="columns large-7">\n      <div class="row">\n        <label>\n          <input type="checkbox" name="quick_bruteforce[options][payload_settings]" />\n          <div>Get session if possible</div>\n        </label>\n      </div>\n    </div>\n\n    <div class="columns large-5">\n      <div class="columns large-7 empty">\n\n      </div>\n      <div class=" columns large-5 session-tooltip-region">\n\n      </div>\n    </div>\n  </div>\n\n</fieldset>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
