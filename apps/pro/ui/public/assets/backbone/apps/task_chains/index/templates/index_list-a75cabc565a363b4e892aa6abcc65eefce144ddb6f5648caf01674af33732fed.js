(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/task_chains/index/templates/index_list"] = function(__obj) {
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
      
        __out.push('<div class="toolbar">\n  <a class="disabled" href="javascript:void(0);" id="delete">Delete</a>\n  <a class="disabled" href="javascript:void(0);" id="clone">Clone</a>\n  <a class="disabled" href="javascript:void(0);" id="stop">Stop</a>\n  <a class="disabled" href="javascript:void(0);" id="suspend">Suspend</a>\n  <a class="disabled" href="javascript:void(0);" id="unsuspend">Unsuspend</a>\n  <a class="disabled" href="javascript:void(0);" id="run">Run Now ▶</a>\n  <a href="javascript:void(0);" id="new">+ New Task Chain</a>\n</div>\n\n<div id="selected-indicator">\n  <span id="num-selected">0</span> of <span id="num-total"></span> task chains selected\n</div>\n\n<table>\n  <thead>\n    <th id="select-all"><input type="checkbox"></th>\n    <th class="schedule">Schedule</th>\n    <th class="sortable" data-sort-column="name">Name <div class="arrow up"></div></th>\n    <th class="sortable" data-sort-column="sortable_last_updated">Last Updated <div class="arrow"></div></th>\n    <th class="sortable" data-sort-column="created_by">Created By <div class="arrow"></div></th>\n    <th>Tasks</th>\n    <th class="sortable" data-sort-column="sortable_next_run">History <div class="arrow"></div></th>\n    <th class="sortable" data-sort-column="percent_tasks_started">Status <div class="arrow"></div></th>\n  </thead>\n  <tbody></tbody>\n</table>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
