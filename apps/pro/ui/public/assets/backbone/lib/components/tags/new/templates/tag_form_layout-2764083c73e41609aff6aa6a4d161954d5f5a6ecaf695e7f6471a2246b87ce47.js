(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/components/tags/new/templates/tag_form_layout"] = function(__obj) {
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
      
        __out.push('<form id="add_tags" style="padding: 3px 0;" action="">\n    <ul>\n        <li class="name tags" style="margin-bottom: 20px; position:relative;">\n            <label id="tags-component" style="position: absolute; margin-left: 4px; margin-top: 2px; right: -25px;"></label>\n            <input name="name"/>\n        </li>\n    </ul>\n</form>\n\n\n<div class="inline-help" data-field="tags-component">\n    <a href class="help" data-field="tags-component" target="_blank">\n    ');
      
        __out.push(this.informationAssetTag);
      
        __out.push('\n    </a>\n    <h3>Tags</h3>\n    <div style="margin-top: 6px;">');
      
        __out.push(this.content);
      
        __out.push('</div>\n</div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
