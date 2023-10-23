(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_compositeview', 'base_itemview', 'lib/shared/attempt_session/templates/attempt_session', 'entities/shared/payload_settings', 'lib/concerns/pollable'], function($) {
    return this.Pro.module("Shared.AttemptSession", function(AttemptSession, App) {
      return AttemptSession.ItemView = (function(_super) {

        __extends(ItemView, _super);

        function ItemView() {
          this.serializeData = __bind(this.serializeData, this);

          this.setTask = __bind(this.setTask, this);

          this._attemptingSessionChanged = __bind(this._attemptingSessionChanged, this);

          this.launchAttempt = __bind(this.launchAttempt, this);
          return ItemView.__super__.constructor.apply(this, arguments);
        }

        ItemView.include('Pollable');

        ItemView.prototype.template = ItemView.prototype.templatePath("attempt_session/attempt_session");

        ItemView.prototype.className = 'attempt-session-container';

        ItemView.prototype.ui = {
          attemptBtn: '.btn.primary.narrow',
          reloadBtn: '.btn.primary.reload'
        };

        ItemView.prototype.triggers = {
          'click @ui.attemptBtn': 'btnClicked',
          'click @ui.reloadBtn': 'btnClicked'
        };

        ItemView.prototype.modelEvents = {
          'change:attempting_session': '_attemptingSessionChanged'
        };

        ItemView.prototype.pollInterval = 3000;

        ItemView.prototype.task = null;

        ItemView.prototype.launchAttempt = function(payloadModel) {
          this.payloadModel = payloadModel;
          this.model.set({
            attempting_session: true
          });
          return this.model.set({
            completed: false
          });
        };

        ItemView.prototype._attemptingSessionChanged = function() {
          var _this = this;
          this.render();
          if (this.model.get('attempting_session')) {
            return this.model.attemptSession(this.payloadModel).done(function(task) {
              _this.setTask(task);
              return _this.startPolling();
            });
          }
        };

        ItemView.prototype.poll = function() {
          var _this = this;
          if (this.task.isCompleted()) {
            this.stopPolling();
            return this.model.sessions().done(function(session) {
              _this.model.set({
                session: session
              });
              _this.model.set({
                completed: true
              });
              return _this.model.set({
                attempting_session: false
              });
            });
          } else {
            return this.task.fetch();
          }
        };

        ItemView.prototype.setTask = function(task) {
          this.task = task;
        };

        ItemView.prototype.serializeData = function() {
          return this;
        };

        return ItemView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
