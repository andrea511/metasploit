(function() { this.JST || (this.JST = {}); this.JST["backbone/apps/task_chains/index/templates/_task_chain"] = function(__obj) {
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
      
        __out.push('<td class="checkbox">\n  <input type="checkbox" ');
      
        if (this.selected) {
          __out.push('checked ');
        }
      
        __out.push(' >\n</td>\n<td class="schedule">\n  <div class="schedule-wrapper">\n    <div class="');
      
        if (this.schedule_state === 'unscheduled') {
          __out.push('no-schedule');
        } else {
          __out.push('schedule');
        }
      
        __out.push('"></div>\n    <div class="');
      
        __out.push(__sanitize(this.schedule_state));
      
        __out.push('"></div>\n  </div>\n</td>\n<td class="name">\n  <a href="');
      
        __out.push(__sanitize(this.edit_workspace_task_chain_path));
      
        __out.push('">');
      
        __out.push(__sanitize(this.name));
      
        __out.push('</a>\n</td>\n<td class="last-updated">\n  ');
      
        __out.push(__sanitize(this.last_updated));
      
        __out.push('\n</td>\n<td class="created-by">\n  ');
      
        __out.push(__sanitize(this.created_by));
      
        __out.push('\n</td>\n<td class="tasks">\n  ');
      
        __out.push(__sanitize(this.task_names));
      
        __out.push('\n</td>\n<td class="history">\n  ');
      
        if (this.last_run_url) {
          __out.push('\n    <a href="');
          __out.push(__sanitize(this.last_run_url));
          __out.push('" ');
          if (this.last_run_error) {
            __out.push(' class="error" ');
          }
          __out.push('>');
          __out.push(__sanitize(this.last_run));
          __out.push('</a>\n  ');
        } else {
          __out.push('\n    ');
          __out.push(__sanitize(this.last_run));
          __out.push('\n  ');
        }
      
        __out.push('\n  <br/>\n  ');
      
        __out.push(__sanitize(this.next_run));
      
        __out.push('\n</td>\n<td class="status">\n  ');
      
        if (this.last_run_task_state === "stopped") {
          __out.push('\n    <div class="stopped-state"></div>\n    <div class="task-info">\n      Task chain was stopped\n    </div>\n  ');
        }
      
        __out.push('\n\n  ');
      
        if (this.last_run_task_state === "interrupted") {
          __out.push('\n    <div class="failed-state"></div>\n    <div class="task-info">\n      Last task chain failed. See: <a href="');
          __out.push(__sanitize(this.last_run_url));
          __out.push('">Error log</a>\n    </div>\n  ');
        }
      
        __out.push('  \n\n  ');
      
        if (this.state !== 'running' && this.last_run_task_state === "completed") {
          __out.push(' \n    ');
          if (this.last_run_url) {
            __out.push('\n      ');
            if (this.last_run_error) {
              __out.push('\n        <div class="failed-state"></div>\n        <div class="task-info">\n          Last task chain failed. See: <a href="');
              __out.push(__sanitize(this.last_run_url));
              __out.push('">Error log</a>\n        </div>\n      ');
            } else {
              __out.push('\n        <div class="success-state"></div>\n        <div class="task-info">\n          ');
              __out.push(__sanitize(this.total_tasks));
              __out.push(' of ');
              __out.push(__sanitize(this.total_tasks));
              __out.push(' tasks completed successfully\n        </div>\n      ');
            }
            __out.push('\n    ');
          }
          __out.push('\n  ');
        }
      
        __out.push('\n\n  ');
      
        if (this.state === 'running') {
          __out.push('\n    <canvas height="35px" width="35px" />\n    <div class="task-info">\n      <a href="');
          __out.push(__sanitize(this.current_task_url));
          __out.push('">Task ');
          __out.push(__sanitize(this.started_tasks));
          __out.push(' of ');
          __out.push(__sanitize(this.total_tasks));
          __out.push('<br/>\n      ');
          __out.push(__sanitize(this.current_task_name));
          __out.push('</a>\n    </div>\n  ');
        }
      
        __out.push('\n</td>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
