(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/shared/attempt_session/templates/attempt_session"] = function(__obj) {
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
      
        if (this.model.get('attempt_session') === 'false') {
          __out.push('\n  <div>No Session Possible</div>\n');
        } else if (this.model.get('attempting_session')) {
          __out.push('\n  <a href="javascript:void(0)" class="btn primary narrow disabled">Attempt Session</a>\n  <div class=\'loading\'></div>\n');
        } else if (this.model.get('completed') && _.isEmpty(this.model.get('session'))) {
          __out.push('\n  <div>Attempt Failed <a href="javascript:void(0) " class="btn primary reload"></a></div>\n');
        } else if (this.model.get('completed') && !_.isEmpty(this.model.get('session'))) {
          __out.push('\n  <a href="');
          __out.push(__sanitize(Routes.session_path(WORKSPACE_ID, this.model.get('session').id)));
          __out.push('" class="">Session ');
          __out.push(__sanitize(this.model.get('session').id));
          __out.push('</a>\n');
        } else {
          __out.push('\n  <a href="javascript:void(0)" class="btn primary narrow">Attempt Session</a>\n');
        }
      
        __out.push('\n\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
