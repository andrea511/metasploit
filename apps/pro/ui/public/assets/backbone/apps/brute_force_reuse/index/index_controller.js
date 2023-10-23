(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'entities/cred', 'apps/brute_force_reuse/index/index_views', 'lib/components/content_container/content_container_controller', 'apps/brute_force_reuse/header/header_controller', 'lib/shared/targets/targets_controller', 'apps/brute_force_reuse/review/review_controller', 'entities/target', 'entities/brute_force_run', 'entities/abstract/brute_force_reuse_options'], function() {
    return this.Pro.module('BruteForceReuseApp.Index', function(Index, App) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.setLaunchTab = __bind(this.setLaunchTab, this);

          this.showError = __bind(this.showError, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var _this = this;
          this.core_id = options.core_id;
          this.workspace_id = options.workspace_id || WORKSPACE_ID;
          this.layout = new Index.Layout;
          this.setMainView(this.layout);
          this.targetListCollection || (this.targetListCollection = App.request('targets:entities', [], {
            workspace_id: this.workspace_id
          }));
          this.workingGroup || (this.workingGroup = new App.Entities.CredGroup({
            workspace_id: this.workspace_id,
            working: true
          }));
          this.listenTo(this.getMainView(), 'show', function() {
            var prevChoice;
            _this.headerController = App.request("header:bruteForceReuseApp", {
              targetListCollection: _this.targetListCollection,
              workingGroup: _this.workingGroup
            });
            _this.contentContainer = App.request('contentContainer:component', {
              headerView: _this.headerController
            });
            _this.listenTo(_this.contentContainer._mainView, "show", function() {
              this.setTargetTab();
              return this.headerController.crumbsCollection.choose(this.headerController.crumbsCollection.at(0));
            });
            _this.show(_this.contentContainer, {
              region: _this.layout.content
            });
            prevChoice = _this.headerController.crumbsCollection.at(0);
            _this.listenTo(_this.headerController.crumbsCollection, "collection:chose:one", function(chosen) {
              var reset;
              if (chosen === prevChoice) {
                return;
              }
              reset = false;
              switch (chosen.get('title')) {
                case 'TARGETS':
                  this.setTargetTab();
                  break;
                case 'CREDENTIALS':
                  if (prevChoice.get('title') !== 'TARGETS' || !_.isEmpty(this.targetListCollection.ids)) {
                    this.setCredentialsTab();
                  } else {
                    reset = true;
                    this.showError("You must add at least 1 target to the list.");
                  }
                  break;
                case 'REVIEW':
                  if ((prevChoice.get('title') !== 'CREDENTIALS' && prevChoice.get('title') !== 'TARGETS') || !_.isEmpty(this.workingGroup.get('creds').ids)) {
                    this.setReviewTab();
                  } else {
                    reset = true;
                    this.showError("You must add at least 1 credential to the list.");
                  }
                  break;
                case 'LAUNCH':
                  if (_.isEmpty(this.workingGroup.get('creds').ids)) {
                    this.showError("You must have selected at least 1 credential to launch the Bruteforce.");
                    reset = true;
                  } else if (_.isEmpty(this.targetListCollection.ids)) {
                    this.showError("You must have selected at least 1 target to launch the Bruteforce.");
                    reset = true;
                  } else {
                    this.setLaunchTab();
                  }
              }
              if (reset) {
                chosen.unchoose();
                return prevChoice.choose();
              } else {
                return prevChoice = chosen;
              }
            });
            _this.listenTo(_this._mainView, 'tab:credentials', function() {
              return this.headerController.crumbsCollection.choose(this.headerController.crumbsCollection.at(1));
            });
            _this.listenTo(_this._mainView, 'tab:review', function() {
              return this.headerController.crumbsCollection.choose(this.headerController.crumbsCollection.at(2));
            });
            _this.listenTo(_this._mainView, 'tab:launch', function() {
              return this.headerController.crumbsCollection.choose(this.headerController.crumbsCollection.at(3));
            });
            App.vent.on('crumb:credentials', function() {
              return _this.headerController.crumbsCollection.choose(_this.headerController.crumbsCollection.at(1));
            });
            return App.vent.on('crumb:targets', function() {
              return _this.headerController.crumbsCollection.choose(_this.headerController.crumbsCollection.at(0));
            });
          });
          return this.show(this.layout, {
            region: this.region
          });
        };

        Controller.prototype.showError = function(msg) {
          return App.execute('flash:display', {
            title: 'Error',
            style: 'error',
            message: msg,
            duration: 3000
          });
        };

        Controller.prototype.setTargetTab = function() {
          this.targetsController = App.request('targets:shared', {
            collection: this.targetListCollection
          });
          return this.contentContainer.showContentRegion(this.targetsController);
        };

        Controller.prototype.setCredentialsTab = function() {
          var _this = this;
          this.reuseCredController = new App.BruteForceReuseApp.CredSelection.Controller({
            show: false,
            workingGroup: this.workingGroup
          });
          this.listenTo(this.reuseCredController._mainView, 'show', function() {
            if (_this.core_id != null) {
              return _this.reuseCredController.addCred(_this.core_id);
            }
          });
          return this.contentContainer.showContentRegion(this.reuseCredController);
        };

        Controller.prototype.setReviewTab = function() {
          var reviewController;
          this.workingGroup || (this.workingGroup = new App.Entities.CredGroup({
            workspace_id: this.workspace_id,
            working: true
          }));
          this.reuseOptions || (this.reuseOptions = App.request('new:brute_force_reuse_options:entity'));
          reviewController = new App.BruteForceReuseApp.Review.Controller({
            show: false,
            targetListCollection: this.targetListCollection,
            workingGroup: this.workingGroup,
            reuseOptions: this.reuseOptions
          });
          return this.contentContainer.showContentRegion(reviewController);
        };

        Controller.prototype.setLaunchTab = function() {
          var brute_force_run,
            _this = this;
          brute_force_run = App.request('new:brute_force_run:entity', {
            service_ids: this.targetListCollection.ids,
            core_ids: this.workingGroup.get('creds').ids,
            config: this.reuseOptions.toJSON(),
            workspace_id: this.workspace_id
          });
          App.execute('loadingOverlay:show');
          return brute_force_run.save().done(function(data) {
            if (data.success) {
              return window.location = data.redirect_to;
            } else {
              return App.execute('loadingOverlay:hide');
            }
          });
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
