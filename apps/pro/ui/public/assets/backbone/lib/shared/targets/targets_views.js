(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_compositeview', 'base_itemview', 'lib/shared/targets/templates/targets_layout', 'lib/shared/targets/templates/target', 'lib/concerns/views/right_side_scroll'], function($) {
    return this.Pro.module("Shared.Targets", function(Targets, App) {
      Targets.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          this.toggleNext = __bind(this.toggleNext, this);
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath("targets/targets_layout");

        Layout.prototype.regions = {
          targetsRegion: '.targets-table',
          targetListRegion: '.target-list'
        };

        Layout.prototype.ui = {
          addSelectionButton: '.add-selection',
          rightSide: '.right-side',
          leftSide: '.left-side',
          next: 'a.btn.primary'
        };

        Layout.prototype.attributes = {
          "class": 'target-selection-view'
        };

        Layout.prototype.triggers = {
          'click @ui.addSelectionButton': 'targets:addToCart'
        };

        Layout.include("RightSideScroll");

        Layout.prototype.toggleNext = function(enabled) {
          return this.ui.next.toggleClass('disabled', !enabled);
        };

        return Layout;

      })(App.Views.Layout);
      Targets.Target = (function(_super) {

        __extends(Target, _super);

        function Target() {
          this.removeTarget = __bind(this.removeTarget, this);

          this.initialize = __bind(this.initialize, this);
          return Target.__super__.constructor.apply(this, arguments);
        }

        Target.prototype.template = Target.prototype.templatePath('targets/target');

        Target.prototype.attributes = {
          "class": 'target-row'
        };

        Target.prototype.events = {
          'click div:not(span)': 'toggleInfo',
          'click a.delete': 'removeTarget'
        };

        Target.prototype.ui = {
          toggleInfo: '.toggle-info',
          arrow: '.arrow-container a'
        };

        Target.prototype.initialize = function(_arg) {
          this.collection = _arg.collection, this.model = _arg.model;
        };

        Target.prototype.removeTarget = function() {
          return this.collection.remove(this.model);
        };

        Target.prototype.toggleInfo = function(e) {
          this.ui.arrow.toggleClass('expand');
          this.ui.arrow.toggleClass('contract');
          return this.ui.toggleInfo.toggleClass('display-none');
        };

        return Target;

      })(App.Views.ItemView);
      Targets.HostnameCellModalView = (function(_super) {

        __extends(HostnameCellModalView, _super);

        function HostnameCellModalView() {
          this.template = __bind(this.template, this);
          return HostnameCellModalView.__super__.constructor.apply(this, arguments);
        }

        HostnameCellModalView.prototype.ui = {
          content: '.truncated-data'
        };

        HostnameCellModalView.prototype.onShow = function() {
          return this.selectText(this.ui.content[0]);
        };

        HostnameCellModalView.prototype.template = function(model) {
          return "<div class='truncated-data'>" + (_.escape(model['host.name'])) + "</div>";
        };

        return HostnameCellModalView;

      })(App.Views.ItemView);
      return Targets.HostnameCellView = (function(_super) {

        __extends(HostnameCellView, _super);

        function HostnameCellView() {
          this.template = __bind(this.template, this);

          this.showDisclosureDialog = __bind(this.showDisclosureDialog, this);
          return HostnameCellView.__super__.constructor.apply(this, arguments);
        }

        HostnameCellView.prototype.ui = {
          disclosureLink: 'a.more'
        };

        HostnameCellView.prototype.events = {
          'click @ui.disclosureLink': 'showDisclosureDialog'
        };

        HostnameCellView.prototype.showDisclosureDialog = function() {
          var dialogView;
          dialogView = new Targets.HostnameCellModalView({
            model: this.model
          });
          return App.execute('showModal', dialogView, {
            modal: {
              title: 'Hostname',
              description: '',
              width: 600,
              height: 400
            },
            buttons: [
              {
                name: 'Close',
                "class": 'close'
              }
            ]
          });
        };

        HostnameCellView.prototype.template = function(model) {
          var max, text;
          max = 16;
          text = model['host.name'] || '';
          if (text.length > max) {
            this.truncatedText = text.substring(0, max) + '…';
            return "" + (_.escape(this.truncatedText)) + " <a class='more' href='javascript:void(0);'>more</a>";
          } else {
            return _.escape(text);
          }
        };

        return HostnameCellView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
