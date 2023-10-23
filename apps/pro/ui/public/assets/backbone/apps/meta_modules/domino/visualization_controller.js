(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'apps/meta_modules/domino/visualization_views', 'base_controller'], function($) {
    return this.Pro.module('MetaModulesApp.Domino', function(Domino, App) {
      return Domino.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.tabClicked = __bind(this.tabClicked, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.layout = null;

        Controller.prototype.task = null;

        Controller.prototype.initialize = function(opts) {
          var _base, _ref,
            _this = this;
          if (opts == null) {
            opts = {};
          }
          this.task = opts.task;
          if ((_ref = (_base = this.task).updateGraph) == null) {
            _base.updateGraph = (function() {
              this.get('allNodes') || this.set({
                allNodes: []
              });
              this.get('allEdges') || this.set({
                allEdges: []
              });
              if (!this.get('nodes').consumed) {
                this.get('nodes').consumed = true;
                this.set({
                  allNodes: this.get('allNodes').concat(this.get('nodes') || [])
                });
              }
              if (!this.get('edges').consumed) {
                this.get('edges').consumed = true;
                return this.set({
                  allEdges: this.get('allEdges').concat(this.get('edges') || [])
                });
              }
            }).bind(this.task);
          }
          this.task.updateGraph();
          this.task.off('change:nodes change:edges', this.task.updateGraph);
          this.task.on('change:nodes change:edges', this.task.updateGraph);
          this.layout = new Domino.Views.Layout(this);
          this.setMainView(this.layout);
          this.d3View = new Domino.Views.D3({
            task: this.task
          });
          this.nodeInfoView = new Domino.Views.NodeInfo();
          this.listenTo(this.layout, 'show', function() {
            _this.show(_this.d3View, {
              region: _this.layout.d3
            });
            return _this.show(_this.nodeInfoView, {
              region: _this.layout.nodeInfo
            });
          });
          this.listenTo(this.layout, 'orientation:changed', function() {
            var orientation;
            orientation = _this.layout.selectedOrientation();
            if (orientation === Domino.Views.D3.LAYOUTS.RADIAL_TREE) {
              _this.d3View.layout = Domino.Views.D3.LAYOUTS.RADIAL_TREE;
              _this.d3View.orientation = Domino.Views.D3.ORIENTATIONS.VERTICAL;
            } else {
              _this.d3View.layout = Domino.Views.D3.LAYOUTS.TREE;
              _this.d3View.orientation = orientation;
            }
            return _this.d3View.updateD3();
          });
          this.listenTo(this.layout, 'layout:changed', function() {
            _this.d3View.layout = _this.layout.selectedLayout();
            return _this.d3View.updateD3();
          });
          this.listenTo(this.layout, 'sizetofit:resized', function() {
            return _this.d3View.updateD3();
          });
          this.listenTo(this.layout, 'fullscreen:changed', function() {
            return _this.d3View.toggleFullscreen(_this.layout.selectedFullscreen());
          });
          this.listenTo(this.d3View, 'node:mouseover', function(nodeData) {
            var url;
            _this.nodeInfoView.$el.show();
            _this.nodeInfoView.setNodeData(nodeData);
            url = Routes.task_detail_path(WORKSPACE_ID, _this.task.id) + ("/stats/node.json?node_id=" + nodeData.data.id);
            return $.getJSON(url).done(function(data) {
              nodeData.data.captured_creds_count = parseInt(data[0].captured_creds_count);
              nodeData.data.address = data[0].address;
              if (_this.nodeInfoView._isShown) {
                return _this.nodeInfoView.setNodeData(nodeData);
              }
            });
          });
          this.listenTo(this.d3View, 'node:mouseout', function(nodeData) {
            return _this.nodeInfoView.$el.hide();
          });
          this.listenTo(this.task, 'change:nodes change:edges', _.debounce((function() {
            if (_this.task.get('nodes').graphConsumed) {
              return;
            }
            if (_this.task.get('nodes').length < 1 && _this.task.get('edges').length < 1) {
              return;
            }
            _this.task.get('nodes').graphConsumed = true;
            return _this.d3View.updateGraph(_this.task.get('nodes'), _this.task.get('edges'));
          }), 100));
          return this.show(this.getMainView(), {
            region: opts.region
          });
        };

        Controller.prototype.tabClicked = function(idx) {
          if (idx === 0) {
            return this.d3View.updateD3();
          }
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
