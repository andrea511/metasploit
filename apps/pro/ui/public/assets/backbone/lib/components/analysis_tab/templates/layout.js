(function() { this.JST || (this.JST = {}); this.JST["backbone/lib/components/analysis_tab/templates/layout"] = function(__obj) {
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
      
        __out.push('<div id="action-buttons-region" class="control-bar"></div>\n\n<ul class="tabs">\n  <li class="tab"><a class="hosts" href="');
      
        __out.push(__sanitize(Routes.hosts_path(WORKSPACE_ID)));
      
        __out.push('">Hosts</a></li>\n  <li class="tab"><a class="notes" href="');
      
        __out.push(__sanitize(Routes.workspace_notes_path(WORKSPACE_ID)));
      
        __out.push('">Notes</a></li>\n  <li class="tab"><a class="services" href="');
      
        __out.push(__sanitize(Routes.workspace_services_path(WORKSPACE_ID)));
      
        __out.push('">Services</a></li>\n  <li class="tab"><a class="vulnerabilities" href="');
      
        __out.push(__sanitize(Routes.workspace_vulns_path(WORKSPACE_ID)));
      
        __out.push('">Disclosed Vulnerabilities</a></li>\n  <li class="tab"><a class="web-vulnerabilities" href="');
      
        __out.push(__sanitize(Routes.workspace_web_vulns_path(WORKSPACE_ID)));
      
        __out.push('">Web Vulnerabilities</a></li>\n  <li class="tab"><a class="modules" href="');
      
        __out.push(__sanitize(Routes.workspace_related_modules_path(WORKSPACE_ID)));
      
        __out.push('">Applicable Modules</a></li>\n  <li class="tab"><a class="loots" href="');
      
        __out.push(__sanitize(Routes.workspace_loots_path(WORKSPACE_ID)));
      
        __out.push('">Captured Data</a></li>\n  <li class="tab"><a class="map" href="');
      
        __out.push(__sanitize(Routes.map_host_path(WORKSPACE_ID)));
      
        __out.push('">Network Topology</a></li>\n</ul>\n\n<div id="analysis-tabs-region" class="tab_panel"></div>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
