(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/brute_force_guess/quick/templates/mutation_view"] = function(__obj) {
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
      
        __out.push('<form>\n  <div>\n    <div class="row">\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="mutation_options[1337_speak]" />\n          1337 speak\n        </label>\n      </div>\n    </div>\n\n\n    <div class="row">\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="mutation_options[append_special]" />\n          Append special chars (!#*)\n        </label>\n       </div>\n    </div>\n\n\n    <div class="row">\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="mutation_options[prepend_special]" />\n          Prepend special chars (!#*)\n        </label>\n       </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="mutation_options[append_single_digit]" />\n          Append single digit\n        </label>\n      </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-12">\n        <div class="columns large-12">\n          <label>\n            <input type="checkbox" name="mutation_options[prepend_single_digit]" />\n            Prepend single digit\n          </label>\n        </div>\n      </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="mutation_options[prepend_multiple_digits]" />\n          Prepend digits\n        </label>\n      </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="mutation_options[append_multiple_digits]" />\n          Append digits\n        </label>\n      </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="mutation_options[prepend_current_year]" />\n          Prepend current year\n        </label>\n       </div>\n    </div>\n\n    <div class="row">\n      <div class="columns large-12">\n        <label>\n          <input type="checkbox" name="mutation_options[append_current_year]" />\n          Append current year\n        </label>\n      </div>\n    </div>\n\n  </div>\n</form>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
