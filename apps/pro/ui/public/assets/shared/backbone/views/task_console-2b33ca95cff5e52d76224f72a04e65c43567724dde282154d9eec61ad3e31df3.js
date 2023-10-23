(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/shared/task_console-482006bb8b6a9acdc2650a157daf1be8210d38a9dcac91a9ce48b021cbdb2b6e.js'], function($, Tmpl) {
    var TaskConsole;
    return TaskConsole = (function(_super) {

      __extends(TaskConsole, _super);

      function TaskConsole() {
        this.render = __bind(this.render, this);

        this._findLog = __bind(this._findLog, this);

        this.refreshLog = __bind(this.refreshLog, this);

        this.stopUpdating = __bind(this.stopUpdating, this);

        this.startUpdating = __bind(this.startUpdating, this);

        this.resumeUpdating = __bind(this.resumeUpdating, this);

        this.initializeEvents = __bind(this.initializeEvents, this);

        this.onRender = __bind(this.onRender, this);

        this.initialize = __bind(this.initialize, this);
        return TaskConsole.__super__.constructor.apply(this, arguments);
      }

      TaskConsole.POLL_DELAY = 2000;

      TaskConsole.prototype._pending = false;

      TaskConsole.prototype._updating = false;

      TaskConsole.prototype._updateInterval = null;

      TaskConsole.prototype._initialized = false;

      TaskConsole.prototype._prerendered = false;

      TaskConsole.prototype.initialize = function(_arg) {
        var prerendered;
        this.task = _arg.task, prerendered = _arg.prerendered;
        if (prerendered != null) {
          this.initializeEvents();
        }
        return this._prerendered = prerendered;
      };

      TaskConsole.prototype.onRender = function() {
        if (!this._initialized) {
          this.initializeEvents();
        }
        return this._initialized = true;
      };

      TaskConsole.prototype.initializeEvents = function(opts) {
        var $log;
        if (opts == null) {
          opts = {};
        }
        $log = this._findLog();
        $log.bind('scrollToBottom', function() {
          return $(this).scrollTop($(this).prop('scrollHeight'));
        });
        $log.bind('addLine', function(event, html) {
          var innerHeight, padding, prevLine, scrolled, shouldScrollToBottom;
          prevLine = $(this).data('prevLine');
          padding = parseInt($(this).css('padding-top')) + parseInt($(this).css('padding-bottom'));
          innerHeight = $(this).prop('scrollHeight') - padding;
          scrolled = $(this).height() + $(this).scrollTop();
          shouldScrollToBottom = scrolled >= innerHeight;
          if (html !== prevLine) {
            $(this).append(html);
          }
          if (shouldScrollToBottom) {
            $(this).trigger('scrollToBottom');
          }
          return $(this).data('prevLine', html);
        });
        return $log.trigger('scrollToBottom');
      };

      TaskConsole.prototype.template = HandlebarsTemplates['shared/task_console'];

      TaskConsole.prototype.resumeUpdating = function() {
        this._updating = false;
        return this.startUpdating();
      };

      TaskConsole.prototype.startUpdating = function() {
        var _this = this;
        if (this._updating) {
          return;
        }
        this._updating = true;
        if (!(typeof _updateInterval !== "undefined" && _updateInterval !== null)) {
          return this._updateInterval = setInterval((function() {
            return _this.refreshLog();
          }), TaskConsole.POLL_DELAY);
        }
      };

      TaskConsole.prototype.stopUpdating = function() {
        if (!this._updating) {
          return;
        }
        return this._updating = false;
      };

      TaskConsole.prototype.refreshLog = function() {
        var $log, lines,
          _this = this;
        $log = this._findLog();
        if ($('.end', $log).length !== 0) {
          this._updating = false;
        }
        if (this._updating && !this._pending) {
          lines = $log.children().length;
          this._pending = true;
          return $.ajax({
            url: "/tasks/" + this.task + "/logs?line=" + lines,
            dataType: "json",
            success: function(_arg) {
              var header, log;
              header = _arg.header, log = _arg.log;
              if ((header != null) && (log != null)) {
                if ((log != null ? log.length : void 0) > 0) {
                  $log.trigger('addLine', log);
                }
                if (_this._prerendered) {
                  if ((header != null ? header.length : void 0) > 0) {
                    return $(document).trigger('logUpdate', [log, header]);
                  }
                } else {
                  return $('table.list', _this.el).html(header);
                }
              }
            },
            complete: function() {
              return _this._pending = false;
            }
          });
        }
      };

      TaskConsole.prototype._findLog = function() {
        var $log;
        $log = $('pre.console', this.$el);
        if ($log.length) {
          return $log;
        } else {
          return this.$el;
        }
      };

      TaskConsole.prototype.render = function() {
        if ($(this.el).is('pre')) {
          return;
        }
        return TaskConsole.__super__.render.apply(this, arguments);
      };

      return TaskConsole;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
