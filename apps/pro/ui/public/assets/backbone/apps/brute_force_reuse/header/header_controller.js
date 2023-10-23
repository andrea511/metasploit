(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'entities/cred', 'apps/brute_force_reuse/header/header_views', 'lib/components/breadcrumbs/breadcrumbs_controller'], function() {
    return this.Pro.module('BruteForceReuseApp.Header', function(Header, App) {
      Header.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var _this = this;
          this.layout = new Header.Layout;
          this.setMainView(this.layout);
          this.workingGroup = options.workingGroup, this.targetListCollection = options.targetListCollection;
          this.listenTo(this.targetListCollection, 'reset remove', function() {
            return _this.setLaunchCrumb();
          });
          this.listenTo(this.workingGroup.get('creds'), 'reset remove', function() {
            return _this.setLaunchCrumb();
          });
          return this.listenTo(this.getMainView(), 'show', function() {
            _this.crumbsController = App.request('crumbs:component', {
              crumbs: [
                {
                  title: 'TARGETS'
                }, {
                  title: 'CREDENTIALS'
                }, {
                  title: 'REVIEW'
                }, {
                  title: 'LAUNCH'
                }
              ]
            });
            _this.crumbsCollection = _this.crumbsController.crumbsCollection;
            _this.listenTo(_this.crumbsCollection, "collection:chose:one", function(chosen) {
              switch (chosen.get('title')) {
                case 'REVIEW':
                  return this.setLaunchCrumb();
                default:
                  return this.unsetLaunchCrumb();
              }
            });
            return _this.show(_this.crumbsController, {
              region: _this.layout.crumbs
            });
          });
        };

        Controller.prototype.setLaunchCrumb = function() {
          var reviewCrumb, _ref;
          reviewCrumb = this.crumbsCollection.findWhere({
            title: "LAUNCH"
          });
          if (((_ref = this.targetListCollection) != null ? _ref.length : void 0) > 0 && this.workingGroup.get('creds').length > 0) {
            return reviewCrumb.set('launchable', true);
          } else {
            return this.unsetLaunchCrumb();
          }
        };

        Controller.prototype.unsetLaunchCrumb = function() {
          var reviewCrumb;
          reviewCrumb = this.crumbsCollection.findWhere({
            title: "LAUNCH"
          });
          return reviewCrumb.set('launchable', false);
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler("header:bruteForceReuseApp", function(options) {
        if (options == null) {
          options = {};
        }
        return new Header.Controller(options);
      });
    });
  });

}).call(this);
