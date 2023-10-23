(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_reuse/review/templates/layout"] = function(__obj) {
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
      
        __out.push('<div class="foundation">\n\n    <div class="row">\n        <div class="large-4 columns">\n            <div class="row">\n                <h1>Options:</h1>\n            </div>\n        </div>\n        <div class="large-3 columns"><h1>Review selections:</h1></div>\n        <div class="large-4 columns"></div>\n    </div>\n\n\n    <div class="row">\n        <div class="large-4 columns options review-options">\n            <form>\n              <div class="row">\n\n                <div class=\'header\'>\n                    reuse options\n                </div>\n\n                <div class=\'border\'>\n                    <div class=\'padder\'>\n                      <div class="columns">\n                          <div class="container columns">\n                              <h3>Timeout Options</h3>\n\n                              <div class="row">\n                                  <div class="timeout-label large-offset-1 large-3 columns">Service Timeout</div>\n                                  <div class="large-8 columns">\n                                    <div class="timeout-field">\n                                       <input id="options-timeout" name="service_seconds" type="text">\n                                       <label for="options-timeout">Seconds</label>\n                                    </div>\n                                  </div>\n                              </div>\n\n                              <div class="row">\n                                   <div class="timeout-label large-offset-1 large-3 columns">Overall Timeout</div>\n                                   <div class="large-8 columns">\n                                     <div class="timeout-field">\n                                          <input id="options-hour" type="text" name="overall_hours">\n                                          <label for="options-hour">Hours</label>\n                                     </div>\n                                      <div class="timeout-field">\n                                          <input type="text" id="options-minutes" name="overall_minutes">\n                                          <label for="options-minutes">Minutes</label>\n                                      </div>\n\n                                      <div class="timeout-field">\n                                          <input type="text" id="options-seconds" name="overall_seconds">\n                                          <label for="options-seconds">Seconds</label>\n                                      </div>\n                                   </div>\n                              </div>\n\n                          </div>\n                      </div>\n\n                      <div class="columns">\n                          <div class="container columns">\n                              <h3>Limitations</h3>\n\n                              <div class="row">\n                                  <div class="large-11 large-offset-1 columns">\n                                      <input id=\'limitation\' type="checkbox" name="limit"/>\n                                      <label for="limitation">Validate only one credential per service</label>\n                                  </div>\n                              </div>\n                          </div>\n                      </div>\n\n\n                    </div>\n                </div>\n              </div>\n            </form>\n        </div>\n\n        <div class="large-3 columns">\n            <div class="large-12 target-region">\n\n            </div>\n\n            <div class="large-12 back-edit">\n                <div class="large-12 columns">\n                    <a href="javascript:void(0)" class="back-targets">Go back and edit</a>\n                </div>\n            </div>\n\n\n        </div>\n\n        <div class="large-3 columns">\n            <div class="large-12 creds-region">\n\n            </div>\n\n            <div class="large-12 back-edit">\n                <div class="large-12 columns">\n                    <a href="javascript:void(0)" class="back-creds">Go back and edit</a>\n                </div>\n            </div>\n\n        </div>\n\n        <div class="large-2 columns">\n            <div class="row">\n                <div class="launch-container large-12 columns">\n                    <a href="javascript:void(0)" class="btn primary launch">LAUNCH</a>\n                </div>\n            </div>\n        </div>\n    </div>\n\n\n\n\n\n  </div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
