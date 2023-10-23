(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/components/tags/index/templates/tag_composite"] = function(__obj) {
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
        var tag, _i, _len, _ref, _ref1, _ref2;
      
        __out.push('<div class="nub-spacer"></div>\n\n<div class="row">\n    ');
      
        _ref = this.lastTags;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tag = _ref[_i];
          __out.push('\n       <div class="no-whitespace">\n           <a class="tag" href="javacript:void(0)">\n               <span class="name">');
          __out.push(__sanitize(tag.name));
          __out.push('</span>\n           </a>\n\n          ');
          if (((_ref1 = this.model) != null ? _ref1.tagUrl : void 0) != null) {
            __out.push('\n            <a class="tag-close" href="javascript:void(0)" data-id="');
            __out.push(__sanitize(tag.id));
            __out.push('">&times;</a>\n          ');
          }
          __out.push('\n\n       </div>\n    ');
        }
      
        __out.push('\n</div>\n\n');
      
        if (((_ref2 = this.model) != null ? _ref2.tagUrl : void 0) != null) {
          __out.push('\n  <div class="row add-tags">\n      <label class="tags">Tags</label>\n      <a class="green-add" href="javascript:void(0)" title="Add tags">+</a>\n  </div>\n');
        }
      
        __out.push('\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
