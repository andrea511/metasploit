(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', 'rainbow_bar', 'base_layout', 'base_view', 'base_itemview', 'apps/creds/show/templates/show_layout', 'apps/creds/show/templates/access_level', 'apps/creds/show/templates/validate_authentication', 'apps/creds/show/templates/validation_hover', 'entities/login', 'lib/concerns/pollable'], function($, RainbowProgressBar) {
    return this.Pro.module("CredsApp.Show", function(Show, App) {
      Show.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('creds/show/show_layout');

        Layout.prototype.ui = {
          compromised_progress: '.compromised-progress',
          reuse: 'li.quick-reuse a'
        };

        Layout.prototype.regions = {
          bannerRegion: "#banner-region",
          relatedLoginsRegion: "#related-logins-region",
          bannerRegion: "#banner-region",
          privateRegion: ".private-region",
          tags: ".tags",
          originRegion: ".origin-region"
        };

        Layout.prototype.triggers = {
          'click @ui.reuse': 'reuse:show'
        };

        Layout.prototype._innerFill = '#FFFFFF';

        Layout.prototype._innerFillHover = '#FFFFFF';

        Layout.prototype._textFill = '#A0A0A0';

        Layout.prototype._fontStyle = '20px Arial';

        Layout.prototype._percentFill = '#A0A0A0';

        /*onShow: ->
            Not using this, at the moment
            @chart = new RainbowProgressBar(
            canvas: @ui.compromised_progress[0]
            textFill: @_textFill
            innerFill: @_innerFill
            innerFillHover: @_innerFillHover
            fontStyle: @_fontStyle
            percentFill: @_percentFill
          )
        @chart.setPercentage(0)
        
        animatePercent: () =>
          @chart.setPercentage(80)
        */


        Layout.prototype.templateHelpers = {
          privateTypeLink: function() {
            var linkUrl;
            if (!this["private"]["class"]) {
              return;
            }
            linkUrl = "#creds?search=private.type:'" + this['pretty_type'] + "'";
            return "<a class='filter' href=\"" + linkUrl + "\">\n  " + this['pretty_type'] + "\n</a>";
          },
          publicUsernameLink: function() {
            var linkUrl, safe_username;
            if (!((this["public"].username != null) && this["public"].username !== "")) {
              return "*BLANK*";
            }
            safe_username = _.escapeHTML(_.unescapeHTML(this["public"].username));
            linkUrl = "#creds?search=public.username:'" + safe_username + "'";
            return "<a class='filter' href=\"" + linkUrl + "\">\n  " + safe_username + "\n</a>";
          },
          realmKeyLink: function() {
            var linkUrl, _ref, _ref1;
            if (!((((_ref = this.realm) != null ? _ref.key : void 0) != null) && (((_ref1 = this.realm) != null ? _ref1.key : void 0) != null) !== "None")) {
              return "None";
            }
            linkUrl = "#creds?search=realm.key:'" + this.realm.key + "'%20realm.value:'" + this.realm.value + "'";
            return "<a class='filter' href=\"" + linkUrl + "\">\n  " + this.realm.key + "\n</a>";
          }
        };

        return Layout;

      })(App.Views.Layout);
      Show.RelatedLogins = (function(_super) {

        __extends(RelatedLogins, _super);

        function RelatedLogins() {
          return RelatedLogins.__super__.constructor.apply(this, arguments);
        }

        return RelatedLogins;

      })(App.Views.ItemView);
      Show.Validation = (function(_super) {

        __extends(Validation, _super);

        function Validation() {
          this.template = __bind(this.template, this);
          return Validation.__super__.constructor.apply(this, arguments);
        }

        Validation.prototype.modelEvents = {
          'change:attempting_login': 'render'
        };

        Validation.prototype.initialize = function(_arg) {
          this.model = _arg.model, this.column = _arg.column;
        };

        Validation.prototype.serializeData = function() {
          return this;
        };

        Validation.prototype.template = function() {
          if (this.model.get('attempting_login')) {
            return 'Validating…';
          } else if (this.model.get(this.column.attribute) === App.Entities.Login.Status.SUCCESSFUL) {
            return 'Validated';
          } else {
            return 'Not Validated';
          }
        };

        return Validation;

      })(App.Views.ItemView);
      Show.FilterLink = (function(_super) {

        __extends(FilterLink, _super);

        function FilterLink() {
          this.template = __bind(this.template, this);
          return FilterLink.__super__.constructor.apply(this, arguments);
        }

        FilterLink.prototype.initialize = function(_arg) {
          this.model = _arg.model, this.column = _arg.column;
        };

        FilterLink.prototype.serializeData = function() {
          return this;
        };

        FilterLink.prototype.template = function() {
          return "<a href='javascript:void(0)'>" + (_.escape(this.model.get(this.column.attribute))) + "</a>";
        };

        return FilterLink;

      })(App.Views.ItemView);
      Show.SingleHostFilterLink = (function(_super) {

        __extends(SingleHostFilterLink, _super);

        function SingleHostFilterLink() {
          this.template = __bind(this.template, this);
          return SingleHostFilterLink.__super__.constructor.apply(this, arguments);
        }

        SingleHostFilterLink.prototype.initialize = function(_arg) {
          this.model = _arg.model, this.column = _arg.column;
        };

        SingleHostFilterLink.prototype.serializeData = function() {
          return this;
        };

        SingleHostFilterLink.prototype.template = function() {
          return "<a href='#creds/" + (_.escape(this.model.get('core_id'))) + "/hosts/" + (_.escape(this.model.get('service.host.id'))) + "'>" + (_.escape(this.model.get(this.column.attribute))) + "</a>";
        };

        return SingleHostFilterLink;

      })(App.Views.ItemView);
      Show.ValidationHover = (function(_super) {

        __extends(ValidationHover, _super);

        function ValidationHover() {
          return ValidationHover.__super__.constructor.apply(this, arguments);
        }

        ValidationHover.prototype.attributes = {
          "class": 'validation-hover'
        };

        ValidationHover.prototype.initialize = function(_arg) {
          this.model = _arg.model, this.column = _arg.column;
        };

        ValidationHover.prototype.serializeData = function() {
          return this;
        };

        ValidationHover.prototype.template = ValidationHover.prototype.templatePath('creds/show/validation_hover');

        return ValidationHover;

      })(App.Views.ItemView);
      Show.ValidateAuthentication = (function(_super) {

        __extends(ValidateAuthentication, _super);

        function ValidateAuthentication() {
          this.serializeData = __bind(this.serializeData, this);

          this.setTask = __bind(this.setTask, this);

          this.poll = __bind(this.poll, this);

          this.attemptingLoginChanged = __bind(this.attemptingLoginChanged, this);

          this.imageClicked = __bind(this.imageClicked, this);
          return ValidateAuthentication.__super__.constructor.apply(this, arguments);
        }

        ValidateAuthentication.include('Pollable');

        ValidateAuthentication.prototype.template = ValidateAuthentication.prototype.templatePath("creds/show/validate_authentication");

        ValidateAuthentication.prototype.ui = {
          'icon': 'div'
        };

        ValidateAuthentication.prototype.events = {
          'click @ui.icon': 'imageClicked'
        };

        ValidateAuthentication.prototype.modelEvents = {
          'change:attempting_login': 'attemptingLoginChanged'
        };

        ValidateAuthentication.prototype.task = null;

        ValidateAuthentication.prototype.pollInterval = 3000;

        ValidateAuthentication.prototype.imageClicked = function() {
          return this.model.set({
            attempting_login: true
          });
        };

        ValidateAuthentication.prototype.attemptingLoginChanged = function() {
          var _this = this;
          this.render();
          if (this.model.get('attempting_login')) {
            return this.model.validateAuthentication().done(function(task) {
              _this.setTask(task);
              return _this.startPolling();
            });
          }
        };

        ValidateAuthentication.prototype.poll = function() {
          var _this = this;
          if (this.task.isCompleted() || this.task.isFailed() || this.task.isInterrupted() || this.task.isStopped()) {
            this.stopPolling();
            return this.model.fetch().done(function() {
              return _this.model.set({
                attempting_login: false
              });
            });
          } else {
            return this.task.fetch();
          }
        };

        ValidateAuthentication.prototype.setTask = function(task) {
          this.task = task;
        };

        ValidateAuthentication.prototype.serializeData = function() {
          return this;
        };

        return ValidateAuthentication;

      })(App.Views.ItemView);
      Show.AccessLevel = (function(_super) {

        __extends(AccessLevel, _super);

        function AccessLevel() {
          this.serializeData = __bind(this.serializeData, this);

          this.enableSelect = __bind(this.enableSelect, this);

          this.disableSelect = __bind(this.disableSelect, this);

          this.updateInput = __bind(this.updateInput, this);

          this.inputActivity = __bind(this.inputActivity, this);

          this.optionChanged = __bind(this.optionChanged, this);

          this.updateLevels = __bind(this.updateLevels, this);

          this.initialize = __bind(this.initialize, this);
          return AccessLevel.__super__.constructor.apply(this, arguments);
        }

        AccessLevel.prototype.template = AccessLevel.prototype.templatePath("creds/show/access_level");

        AccessLevel.prototype.ui = {
          'select': 'select',
          'input': 'input'
        };

        AccessLevel.prototype.events = {
          'change @ui.select': 'optionChanged',
          'keydown @ui.input': 'inputActivity',
          'change @ui.input': 'updateInput'
        };

        AccessLevel.prototype.collectionEvents = {
          levelsChanged: 'updateLevels'
        };

        AccessLevel.prototype.accessLevels = [];

        AccessLevel.prototype.showInput = false;

        AccessLevel.prototype.onShow = function() {
          return this.delegateEvents();
        };

        AccessLevel.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          if (!_.isUndefined(opts.accessLevels)) {
            this.accessLevels = opts.accessLevels;
          }
          _.defaults(opts, {
            save: true,
            showLabel: false
          });
          return this.save = opts.save, this.showLabel = opts.showLabel, opts;
        };

        AccessLevel.prototype.updateLevels = function(accessLevels) {
          this.accessLevels = accessLevels;
          return this.render();
        };

        AccessLevel.prototype.optionChanged = function() {
          var _ref, _ref1;
          if ((_ref = this.ui.select.val()) != null ? _ref.match(/Other.../) : void 0) {
            this.showInput = true;
            this.render();
            this.ui.input.val(this.model.get('access_level'));
            return (_ref1 = this.ui.input.focus()[0]) != null ? _ref1.select() : void 0;
          } else {
            this.showInput = false;
            this.model.set('access_level', this.ui.select.val());
            this.disableSelect();
            if (this.save) {
              return this.model.save().then(this.enableSelect);
            } else {
              return this.enableSelect();
            }
          }
        };

        AccessLevel.prototype.inputActivity = function(e) {
          if (e.keyCode === 13) {
            return this.updateInput();
          } else if (e.keyCode === 27) {
            this.showInput = false;
            return this.render();
          } else {
            this.debouncedUpdateInput || (this.debouncedUpdateInput = _.debounce(this.updateInput, 1000));
            return this.debouncedUpdateInput();
          }
        };

        AccessLevel.prototype.updateInput = function() {
          var newVal;
          if (_.isEmpty(this.ui.input) || _.isEmpty(this.ui.input.val())) {
            return;
          }
          newVal = this.ui.input.val().trim();
          if (newVal !== /Other.../ && !_.isEmpty(newVal)) {
            this.showInput = false;
            this.model.set('access_level', newVal);
            this.render();
            this.disableSelect();
            if (this.save) {
              return this.model.save().then(this.enableSelect);
            } else {
              return this.enableSelect();
            }
          }
        };

        AccessLevel.prototype.disableSelect = function() {
          return this.ui.select.attr('disabled', 'disabled');
        };

        AccessLevel.prototype.enableSelect = function() {
          return this.ui.select.removeAttr('disabled');
        };

        AccessLevel.prototype.serializeData = function() {
          return _.extend({}, this.model.attributes, {
            showInput: this.showInput,
            accessLevels: this.accessLevels,
            showLabel: this.showLabel
          });
        };

        return AccessLevel;

      })(App.Views.ItemView);
      return App.reqres.setHandler('creds:accessLevel:view', function(options) {
        if (options == null) {
          options = {};
        }
        return new Show.AccessLevel(options);
      });
    });
  });

}).call(this);
