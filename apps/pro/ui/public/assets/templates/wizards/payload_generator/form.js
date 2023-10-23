(function() { this.JST || (this.JST = {}); this.JST["templates/wizards/payload_generator/form"] = function(__obj) {
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
      
        __out.push('<form class=\'formtastic form\' id=\'payload_generator\'>\n  <li id=\'payload_class\'>\n    <label>\n      <input type=\'radio\' name=\'payload[payload_class]\' value=\'classic_payload\'>\n      Classic Payload\n    </label>\n    <label>\n      <input type=\'radio\' name=\'payload[payload_class]\' value=\'dynamic_stager\' checked>\n      Dynamic Payload (AV evasion)\n    </label>\n  </li>\n\n  <input type=\'hidden\' name=\'_method\' value=\'put\' />\n  <input type=\'hidden\' name=\'authenticity_token\' value=\'\' />\n  <input name=\'payload[options][payload]\' type=\'hidden\' />\n\n  <div class=\'dynamic_payload_form\'>\n    <div class=\'page payload_options upsell\'>\n      <ul>\n        <li style=\'display:none\'>\n          <div>\n            <input name=\'payload[payload_class]\' type=\'hidden\' />\n            <input name=\'payload[options][platform]\' type=\'hidden\' value=\'Windows\' />\n            <input name=\'payload[options][useStager]\' type=\'hidden\' value=\'true\' />\n            <input name=\'payload[options][format]\' type=\'hidden\' value=\'exe\' />\n          </div>\n        </li>\n        <li>\n            <label for=\'payload[options][arch]\'>Architecture</label>\n            <select name=\'payload[options][arch]\' id=\'payload[options][arch]\'></select>\n        </li>\n        <li>\n          <label for=\'payload[options][stager]\'>Stager</label>\n          <select name=\'payload[options][stager]\' id=\'payload[options][stager]\'></select>\n        </li>\n        <li>\n          <label for=\'payload[options][stage]\'>Stage</label>\n          <select name=\'payload[options][stage]\' id=\'payload[options][stage]\'></select>\n        </li>\n\n        <div class="payload-options advanced" style=\'display:block\'>\n          <div class=\'ajax\'></div>\n          <div style=\'display:none\'>\n            <div class=\'ajax-advanced-options\'>\n              <div class=\'render\' style=\'display:none;\'></div>\n              <div style=\'clear:both\'></div>\n            </div>\n          </div>\n        </div>\n      </ul>\n    </div>\n  </div>\n\n  <div class=\'page payload_options\'>\n    <ul>\n      <li>\n        <label for=\'payload[options][platform]\'>Platform</label>\n        <select name=\'payload[options][platform]\' id=\'payload[options][platform]\'></select>\n      </li>\n      <li>\n        <label for=\'payload[options][arch]\'>Architecture</label>\n        <select name=\'payload[options][arch]\' id=\'payload[options][arch]\'></select>\n      </li>\n      <li>\n        <label for=\'payload[options][useStager]\'>\n          <input name=\'payload[options][useStager]\' id=\'payload[options][useStager]\' type=\'checkbox\' />\n          Stager\n        </label>\n        <select name=\'payload[options][stager]\'></select>\n      </li>\n      <li>\n        <label for=\'payload[options][stage]\'>Stage</label>\n        <select name=\'payload[options][stage]\' id=\'payload[options][stage]\'></select>\n      </li>\n      <li>\n        <label for=\'payload[options][single]\'>Payload</label>\n        <select name=\'payload[options][single]\' id=\'payload[options][single]\'></select>\n      </li>\n\n      <div class="payload-options advanced" style=\'display:block\'>\n      <div class=\'ajax\'></div>\n        <span class=\'span-front\'>Added Shellcode</span>\n        <li class=\'file input front\'>\n          <label for=\'payload[options][add_code]\'>File</label>\n          <input name=\'payload[options][add_code]\' id=\'payload[options][add_code]\' type=\'file\' />\n        </li>\n        <li>\n          <label for=\'payload[options][nops]\'>Size of NOP sled</label>\n          <input name=\'payload[options][nops]\' id=\'payload[options][nops]\' type=\'text\' placeholder=\'(bytes)\' />\n        </li>\n        <div class=\'ajax-advanced-options\'>\n          <div class=\'\' style=\'text-align:right;padding-right:20px;padding-bottom:8px;\'>\n            <a href=\'#\' class=\'advanced\' data-toggle-selector=\'.ajax-advanced-options .render\'>Advanced</a>\n          </div>\n          <div class=\'render\' style=\'display:none\'></div>\n        </div>\n      </div>\n    </ul>\n\n  </div>\n\n  <div class=\'page encoding\'>\n    <h3 class=\'enabled\'>Encoding is <span class=\'enabled\'>enabled</span></h3>\n    <ul>\n      <li>\n        <label for=\'payload[options][encoder]\'>Encoder</label>\n        <select name=\'payload[options][encoder]\' id=\'payload[options][encoder]\'></select>\n      </li>\n    </ul>\n\n    <ul>\n      <li class=\'slider\'>\n        <label for=\'payload[options][iterations]\'>Number of iterations</label>\n        <input type=\'text\' name=\'payload[options][iterations]\' id=\'payload[options][iterations]\' data-min=\'1\' data-max=\'10\' value=\'1\'></input>\n      </li>\n\n      <li>\n        <label for=\'payload[options][space]\'>Maximum size of payload</label>\n        <input type=\'text\' name=\'payload[options][space]\' id=\'payload[options][space]\' placeholder=\'(bytes)\'></input>\n      </li>\n\n      <li>\n        <label for=\'payload[options][badchars]\'>Bad characters</label>\n        <textarea name=\'payload[options][badchars]\' id=\'payload[options][badchars]\' id=\'badchars\'></textarea>\n      </li>\n    </ul>\n\n    <div class=\'encoder-options advanced\' style=\'display:block\'>\n      <div class=\'ajax\'></div>\n    </div>\n  </div>\n\n  <div class=\'page output_options\'>\n    <ul>\n      <li class=\'output\'>\n        <label style=\'width:20%;\'>Output type</label>\n        <label style=\'font-weight: normal\'>\n          <input type=\'radio\' name=\'payload[options][outputType]\' value=\'exe\' />\n          Executable file\n        </label>\n        <label style=\'font-weight: normal\'>\n          <input type=\'radio\' name=\'payload[options][outputType]\' value=\'raw\' />\n          Raw bytes\n        </label>\n        <label style=\'font-weight: normal\'>\n          <input type=\'radio\' name=\'payload[options][outputType]\' value=\'buffer\' />\n          Shellcode buffer\n        </label>\n      </li>\n      <li class=\'not-raw\'>\n        <label for=\'payload[options][format]\'>Format</label>\n        <select name=\'payload[options][format]\' id=\'payload[options][format]\'></select>\n      </li>\n      <span class=\'exe span-front\'>Template file</span>\n      <li class=\'exe file input front\'>\n        <label>File</label>\n        <input type=\'file\' name=\'payload[options][template]\' id=\'payload[options][template]\' />\n      </li>\n      <li class=\'exe keep\'>\n        <input type=\'hidden\' name=\'payload[options][keep]\' value=\'false\' />\n        <input type=\'checkbox\' name=\'payload[options][keep]\' id=\'payload[options][keep]\' value=\'true\' />\n        <label for=\'payload[options][keep]\'>\n          Preserve original functionality of the executable\n        </label>\n      </li>\n    </ul>\n  </div>\n\n</form>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
