(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['d3_min', 'jquery', 'apps/meta_modules/domino/minimap', 'apps/meta_modules/domino/pcb_layout', 'd3_transform', 'base_view', 'base_layout', 'apps/meta_modules/domino/templates/layout', 'apps/meta_modules/domino/templates/graph', 'apps/meta_modules/domino/templates/node_info', 'lib/components/table/table_view', 'lib/concerns/views/size_to_fit'], function(d3, $, minimap, PcbLayout) {
    var DEBOUNCE_DELAY, KEY_EDGE_FN, KEY_FN, MAX_ASPECT, MAX_NODE_RADIUS, MIN_NODE_RADIUS, isInViewPort;
    DEBOUNCE_DELAY = 100;
    MAX_ASPECT = 1;
    MAX_NODE_RADIUS = 100;
    MIN_NODE_RADIUS = 60;
    KEY_FN = function(d) {
      return d.id;
    };
    KEY_EDGE_FN = function(d) {
      return d.source.id + ',' + d.target.id;
    };
    isInViewPort = function(el) {
      var rect;
      rect = el.getBoundingClientRect();
      rect.top >= 0 && rect.left >= 0 && rect.bottom <= (window.innerHeight || document.documentElement.clientHeight);
      return rect.right <= (window.innerWidth || document.documentElement.clientWidth);
    };
    return this.Pro.module('MetaModulesApp.Domino.Views', function(Views, App) {
      Views.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          this.onRender = __bind(this.onRender, this);

          this.fullscreenChanged = __bind(this.fullscreenChanged, this);

          this.selectedFullscreen = __bind(this.selectedFullscreen, this);

          this.selectedLayout = __bind(this.selectedLayout, this);

          this.selectedOrientation = __bind(this.selectedOrientation, this);
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.include("SizeToFit");

        Layout.prototype.task = null;

        Layout.prototype.edges = null;

        Layout.prototype.nodes = null;

        Layout.prototype.template = Layout.prototype.templatePath('meta_modules/domino/layout');

        Layout.prototype.ui = {
          controls: '.graph-controls',
          resizeEl: '.d3-graph-visualization'
        };

        Layout.prototype.regions = {
          d3: '.d3-graph-visualization',
          nodeInfo: '.node-info-region'
        };

        Layout.prototype.triggers = {
          'change input[name=orientation]': 'orientation:changed',
          'change input[name=layout]': 'layout:changed'
        };

        Layout.prototype.events = {
          'change input[name="full-screen"]': 'fullscreenChanged'
        };

        Layout.prototype.selectedOrientation = function() {
          return this.ui.controls.find('[name=orientation]:checked').blur().val();
        };

        Layout.prototype.selectedLayout = function() {
          return this.ui.controls.find('[name=layout]:checked').blur().val();
        };

        Layout.prototype.selectedFullscreen = function() {
          return this.ui.controls.find('[name="full-screen"]').is(':checked');
        };

        Layout.prototype.fullscreenChanged = function() {
          this.setResizeDisabled(this.selectedFullscreen());
          return this.trigger('fullscreen:changed');
        };

        Layout.prototype.onRender = function() {
          return this.ui.controls.tooltip();
        };

        return Layout;

      })(App.Views.Layout);
      Views.NodeInfo = (function(_super) {

        __extends(NodeInfo, _super);

        function NodeInfo() {
          this.serializeData = __bind(this.serializeData, this);

          this.setNodeData = __bind(this.setNodeData, this);

          this.setLoading = __bind(this.setLoading, this);
          return NodeInfo.__super__.constructor.apply(this, arguments);
        }

        NodeInfo.prototype.className = 'node-info';

        NodeInfo.prototype.attributes = {
          style: 'display: none'
        };

        NodeInfo.prototype.template = NodeInfo.prototype.templatePath('meta_modules/domino/node_info');

        NodeInfo.prototype.setLoading = function(loading) {};

        NodeInfo.prototype.setNodeData = function(_arg) {
          var graphHeight, graphOrientation, graphWidth, h, mouse, rect, w;
          this.node = _arg.node, this.data = _arg.data, mouse = _arg.mouse, graphHeight = _arg.graphHeight, graphWidth = _arg.graphWidth, graphOrientation = _arg.graphOrientation;
          this.render();
          w = window.innerHeight || document.documentElement.clientHeight;
          h = window.innerHeight || document.documentElement.clientHeight;
          if (graphOrientation === Views.D3.ORIENTATIONS.VERTICAL) {
            this.$el.css({
              top: mouse[1] - 100,
              left: mouse[0] + 170,
              bottom: 'auto',
              right: 'auto'
            });
            rect = this.$el[0].getBoundingClientRect();
            if (rect.bottom >= h - 40) {
              this.$el.css({
                top: 'auto',
                bottom: graphHeight - mouse[1]
              });
              rect = this.$el[0].getBoundingClientRect();
            }
            if (rect.right >= w) {
              return this.$el.css({
                right: graphWidth - (mouse[0] - 50),
                left: 'auto'
              });
            }
          } else {
            this.$el.css({
              top: mouse[1] + 60,
              left: mouse[0],
              bottom: 'auto',
              right: 'auto'
            });
            rect = this.$el[0].getBoundingClientRect();
            if (rect.bottom >= h - 40) {
              this.$el.css({
                top: 'auto',
                bottom: graphHeight - (mouse[1] - 60)
              });
              rect = this.$el[0].getBoundingClientRect();
            }
            if (rect.left <= 0) {
              this.$el.css({
                left: mouse[0] + 30
              });
              rect = this.$el[0].getBoundingClientRect();
            }
            if (rect.left <= 0) {
              this.$el.css({
                left: mouse[0] + 60
              });
              rect = this.$el[0].getBoundingClientRect();
            }
            if (rect.right >= w) {
              this.$el.css({
                left: mouse[0] + 30
              });
              rect = this.$el[0].getBoundingClientRect();
            }
            if (rect.right >= w) {
              return this.$el.css({
                left: mouse[0]
              });
            }
          }
        };

        NodeInfo.prototype.serializeData = function() {
          return this.data;
        };

        return NodeInfo;

      })(Marionette.ItemView);
      return Views.D3 = (function(_super) {

        __extends(D3, _super);

        function D3() {
          this._updateNestedStructure = __bind(this._updateNestedStructure, this);

          this._buildNestedStructure = __bind(this._buildNestedStructure, this);

          this._trimText = __bind(this._trimText, this);

          this._fixText = __bind(this._fixText, this);

          this.selectNext = __bind(this.selectNext, this);

          this.selectPrev = __bind(this.selectPrev, this);

          this.nodeMouseover = __bind(this.nodeMouseover, this);

          this.nodeMouseout = __bind(this.nodeMouseout, this);

          this.eventInsideSameParentNode = __bind(this.eventInsideSameParentNode, this);

          this.refreshSize = __bind(this.refreshSize, this);

          this.toggleFullscreen = __bind(this.toggleFullscreen, this);

          this._updateD3 = __bind(this._updateD3, this);

          this.updateD3 = __bind(this.updateD3, this);

          this.updateGraph = __bind(this.updateGraph, this);

          this.zoomHandler = __bind(this.zoomHandler, this);

          this.initD3 = __bind(this.initD3, this);

          this.updateKey = __bind(this.updateKey, this);

          this.keyUp = __bind(this.keyUp, this);

          this.keyDown = __bind(this.keyDown, this);

          this.onShow = __bind(this.onShow, this);
          return D3.__super__.constructor.apply(this, arguments);
        }

        D3.TRANSITION_LENGTH = 300;

        D3.LAYOUTS = {
          TREE: 'tree',
          RADIAL_TREE: 'radial_tree'
        };

        D3.ORIENTATIONS = {
          HORIZONTAL: 'horizontal',
          VERTICAL: 'vertical'
        };

        D3.prototype.orientation = 'vertical';

        D3.prototype.layout = 'tree';

        D3.prototype.width = null;

        D3.prototype.height = null;

        D3.prototype.base = null;

        D3.prototype.wrapperBorder = 0;

        D3.prototype.minimap = null;

        D3.prototype.minimapPadding = 20;

        D3.prototype.minimapScale = 0.2;

        D3.prototype.zoomEnabled = true;

        D3.prototype.dragEnabled = true;

        D3.prototype.hoveredNode = null;

        D3.prototype.xScale = null;

        D3.prototype.yScale = null;

        D3.prototype.circles = [];

        D3.prototype.root = null;

        D3.prototype.treeLayout = null;

        D3.prototype.diagonal = null;

        D3.prototype.template = D3.prototype.templatePath('meta_modules/domino/graph');

        D3.prototype.keyMap = {
          38: 'up',
          40: 'down',
          39: 'right',
          37: 'left'
        };

        D3.prototype.ui = {
          graph: '.graph',
          pleaseWait: '.please-wait'
        };

        D3.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          this.task = opts.task;
          this.keys = {
            up: false,
            down: false,
            left: false,
            right: false
          };
          this.initialNodes = this.task.get('allNodes') || [];
          this.initialEdges = this.task.get('allEdges') || [];
          return _.each(this.initialNodes, function(n) {
            delete n.children;
            delete n.childrenMap;
            return delete n.hasParent;
          });
        };

        D3.prototype.onShow = function() {
          this.$el.parents('.drilldown-padding').css({
            padding: 0
          });
          $(window).on('keydown.domino', this.keyDown);
          return $(window).on('keyup.domino', this.keyUp);
        };

        D3.prototype.onDestroy = function() {
          this.$el.parents('.drilldown-padding').css({
            padding: 10
          });
          $(window).off('keydown.domino');
          return $(window).off('keyup.domino');
        };

        D3.prototype.keyDown = function(e) {
          var key;
          key = this.keyMap[e.which];
          if (key != null) {
            this.keys[key] = true;
          }
          return this.updateKey(key);
        };

        D3.prototype.keyUp = function(e) {
          var key;
          key = this.keyMap[e.which];
          if (key != null) {
            this.keys[key] = false;
          }
          return this.updateKey(key);
        };

        D3.prototype.updateKey = function(key) {
          var _base, _ref;
          if (!this.keys[key]) {
            return;
          }
          if (key === 'left') {
            this.minimap.x(this.minimap.x() - 5);
            d3.event = {
              translate: [this.panX - 5, this.panY]
            };
          }
          if (key === 'right') {
            this.minimap.x(this.minimap.x() + 5);
            d3.event = {
              translate: [this.panX + 5, this.panY]
            };
          }
          if (key === 'down') {
            this.minimap.y(this.minimap.y() + 5);
            d3.event = {
              translate: [this.panX, this.panY + 5]
            };
          }
          if (key === 'up') {
            this.minimap.y(this.minimap.y() - 5);
            d3.event = {
              translate: [this.panX, this.panY - 5]
            };
          }
          d3.event.scale = this.zoom;
          if ((_ref = (_base = d3.event).scale) == null) {
            _base.scale = 1;
          }
          this.zoomHandler(this.zoom);
          d3.event = null;
          return _.delay(this.updateKey, 200, key);
        };

        D3.prototype.initD3 = function() {
          var zoom;
          if (this.wrapSvg != null) {
            return;
          }
          if (_.isEmpty(this.task.get('allNodes'))) {
            return;
          }
          this.refreshSize();
          if (this.root == null) {
            this._buildNestedStructure(this.initialNodes, this.initialEdges);
          }
          this.xScale = d3.scale.linear().domain([-this.width / 2, this.width / 2]).range([0, this.width]);
          this.yScale = d3.scale.linear().domain([-this.height / 2, this.height / 2]).range([this.height, 0]);
          zoom = d3.behavior.zoom().x(this.xScale).y(this.yScale).scaleExtent([0.9, 10]).on("zoom.canvas", this.zoomHandler);
          this.wrapSvg = d3.select(this.ui.graph[0]).append('svg').attr("width", this.width).attr("height", this.height);
          this.svg = this.wrapSvg.append("g");
          this.svgDefs = this.svg.append("defs");
          this.rect = this.svgDefs.append("clipPath").attr("id", "wrapperClipPathDemo01").attr("class", "wrapper clipPath").append("rect").attr("class", "background").attr("width", this.width).attr("height", this.height);
          this.svgDefs.append("clipPath").attr("id", "minimapClipPath").attr("width", this.width).attr("height", this.height).attr("transform", d3.svg.transform().translate([this.width + this.minimapPadding, this.minimapPadding / 2])).append("rect").attr("class", "background").attr("width", this.width).attr("height", this.height);
          this.filter = this.svgDefs.append("svg:filter").attr("id", "minimapDropShadow").attr("x", "-20%").attr("y", "-20%").attr("width", "150%").attr("height", "150%");
          this.filter.append("svg:feOffset").attr("result", "offOut").attr("in", "SourceGraphic").attr("dx", "1").attr("dy", "1");
          this.filter.append("svg:feColorMatrix").attr("result", "matrixOut").attr("in", "offOut").attr("type", "matrix").attr("values", "0.1 0 0 0 0 0 0.1 0 0 0 0 0 0.1 0 0 0 0 0 0.5 0");
          this.filter.append("svg:feGaussianBlur").attr("result", "blurOut").attr("in", "matrixOut").attr("stdDeviation", "10");
          this.filter.append("svg:feBlend").attr("in", "SourceGraphic").attr("in2", "blurOut").attr("mode", "normal");
          this.minimapRadialFill = this.svgDefs.append("radialGradient").attr({
            id: "minimapGradient",
            gradientUnits: "userSpaceOnUse",
            cx: "500",
            cy: "500",
            r: "400",
            fx: "500",
            fy: "500"
          });
          this.minimapRadialFill.append("stop").attr("offset", "0%").attr("stop-color", "#FFFFFF");
          this.minimapRadialFill.append("stop").attr("offset", "40%").attr("stop-color", "#EEEEEE");
          this.minimapRadialFill.append("stop").attr("offset", "100%").attr("stop-color", "#E0E0E0");
          this.outerWrapper = this.svg.append("g").attr("class", "wrapper outer");
          this.outerWrapper.append("rect").attr("class", "background").attr("width", this.width).attr("height", this.height);
          this.innerWrapper = this.outerWrapper.append("g").attr("class", "wrapper inner").attr("clip-path", "url(#wrapperClipPathDemo01)").call(zoom);
          this.innerWrapper.append("rect").attr("class", "background").attr("width", this.width).attr("height", this.height);
          this.panCanvas = this.innerWrapper.append("g").attr("class", "panCanvas").attr("width", this.width).attr("height", this.height);
          this.panCanvas.append("rect").attr("class", "background").attr("width", this.width).attr("height", this.height);
          this.minimap = minimap().zoom(zoom).target(this.panCanvas).minimapScale(this.minimapScale);
          this.svg.call(this.minimap);
          zoom.scale(1);
          this.zoomHandler(1);
          return this.panLayer = this.panCanvas.append("g").attr("transform", d3.svg.transform().translate([0, 0]));
        };

        D3.prototype.zoomHandler = function(newScale, evt) {
          var bbound, className, lbound, rbound, scale, tbound, translation, z, _ref;
          if (evt == null) {
            evt = null;
          }
          if (!this.zoomEnabled) {
            return;
          }
          scale = d3.event ? d3.event.scale : newScale;
          if (this.dragEnabled) {
            tbound = -this.height * scale;
            bbound = this.height * scale;
            lbound = -this.width * scale;
            rbound = this.width * scale;
            translation = (_ref = d3.event) != null ? _ref.translate : void 0;
            if (translation == null) {
              translation = evt;
            }
            if (translation == null) {
              translation = [0, 0];
            }
            translation = [Math.max(Math.min(translation[0], rbound), lbound), Math.max(Math.min(translation[1], bbound), tbound)];
            className = '';
            if (!_.isUndefined(this.aspect)) {
              z = Math.min(Math.floor(this.aspect * scale * 10), 18);
              _.times(Math.min(Math.floor(this.aspect * scale * 10), 19), function(i) {
                if (i % 2 === 0) {
                  return className += ' z' + i;
                }
              });
              if (_.isBlank(className)) {
                className = 'z-1';
              }
              $(this.el).attr('class', className);
              if (z !== this.oldZ) {
                this._fixText();
              }
              this.oldZ = z;
            }
            this.panX = translation[0];
            this.panY = translation[1];
            d3.select(".panCanvas, .panCanvas .bg").attr("transform", d3.svg.transform().translate(translation).scale(scale));
            this.minimap.scale(scale);
            this.minimap.render();
            return this.zoom = scale;
          }
        };

        D3.prototype.updateGraph = function(nodes, links) {
          this._updateNestedStructure(nodes, links);
          return this._updateD3();
        };

        D3.prototype.updateD3 = function(opts) {
          this._updateD3Debounced || (this._updateD3Debounced = _.debounce(this._updateD3, DEBOUNCE_DELAY));
          return this._updateD3Debounced();
        };

        D3.prototype._updateD3 = function() {
          var aspect, aspectX, aspectY, diagonal, fnD3Transform, links, maxX, maxY, me, minX, minY, nodes, nodesEnter, offX, offY,
            _this = this;
          if (!((this.root != null) && (this.wrapSvg != null))) {
            this.initD3();
          }
          if (!((this.root != null) && (this.wrapSvg != null))) {
            return;
          }
          this.ui.pleaseWait.hide();
          if (!this.fullscreen) {
            this.refreshSize();
          }
          this.wrapSvg.transition().duration(Views.D3.TRANSITION_LENGTH).attr('width', this.width).attr('height', this.height);
          this.rect.transition().duration(Views.D3.TRANSITION_LENGTH).attr("width", this.width).attr("height", this.height);
          this.svgDefs.select(".clipPath .background").attr("width", this.width).attr("height", this.height);
          this.svg.attr("width", this.width + this.minimapPadding * 2 + (this.width * this.minimapScale)).attr("height", this.height);
          this.outerWrapper.select(".background").attr("width", this.width).attr("height", this.height);
          this.innerWrapper.select(".background").attr("width", this.width).attr("height", this.height);
          this.panCanvas.attr("width", this.width).attr("height", this.height).select(".background").attr("width", this.width).attr("height", this.height);
          if (this.layout === Views.D3.LAYOUTS.RADIAL_TREE) {
            diagonal = d3.svg.diagonal.radial().projection(function(d) {
              return [d.y, d.x / 180 * Math.PI];
            });
          } else if (this.orientation === Views.D3.ORIENTATIONS.VERTICAL) {
            diagonal = d3.svg.diagonal().projection(function(d) {
              return [d.x, d.y];
            });
            this.svg.transition().duration(Views.D3.TRANSITION_LENGTH).attr("transform", d3.svg.transform().translate([0, 0]));
          } else {
            diagonal = d3.svg.diagonal().projection(function(d) {
              return [d.y, d.x];
            });
            this.svg.transition().duration(Views.D3.TRANSITION_LENGTH).attr("transform", d3.svg.transform().translate([0, 0]));
          }
          if (this.layout === Views.D3.LAYOUTS.TREE) {
            this.treeLayout = PcbLayout();
            if (this.orientation === Views.D3.ORIENTATIONS.HORIZONTAL) {
              this.treeLayout.size([this.width, this.height]);
            } else {
              this.treeLayout.size([this.height, this.width]);
            }
          } else {
            this.treeLayout = d3.layout.cluster();
            this.treeLayout.size([360, Math.min(this.width, this.height) - 70]);
            this.treeLayout.separation(function(a, b) {
              var _ref;
              return ((_ref = a.parent === b.parent) != null ? _ref : {
                1: 2
              }) / a.depth;
            });
            this.treeLayout.sort(null);
          }
          this.svgNodes = this.treeLayout.nodes(this.root);
          this.svgLinks = this.treeLayout.links(this.svgNodes);
          minX = d3.min(this.svgNodes, function(n) {
            return n.x - n.radius;
          });
          minY = d3.min(this.svgNodes, function(n) {
            return n.y - n.radius;
          });
          maxX = d3.max(this.svgNodes, function(n) {
            return n.x + n.radius;
          });
          maxY = d3.max(this.svgNodes, function(n) {
            return n.y + n.radius;
          });
          aspect = 1;
          if (this.layout === Views.D3.LAYOUTS.TREE) {
            if (this.orientation === Views.D3.ORIENTATIONS.HORIZONTAL) {
              aspectX = (this.height - 50) / (maxX - minX);
              aspectY = (this.width - 50) / (maxY - minY);
              aspect = Math.min(aspectX, aspectY, MAX_ASPECT);
              offY = -minX + (Math.max(this.height - Math.abs(maxX - minX) * aspect, 0) / 2) / aspect;
              offX = -minY + (Math.max(this.width - Math.abs(maxY - minY) * aspect, 0) / 2) / aspect;
            } else {
              aspectX = (this.height - 50) / (maxY - minY);
              aspectY = (this.width - 50) / (maxX - minX);
              aspect = Math.min(aspectX, aspectY, MAX_ASPECT);
              offX = -minX + (Math.max(this.width - Math.abs(maxX - minX) * aspect, 0) / 2) / aspect;
              offY = -minY + (Math.max(this.height - Math.abs(maxY - minY) * aspect, 0) / 2) / aspect;
            }
          } else {
            aspect = 0.5;
            offX = this.width;
            offY = this.height;
          }
          this.aspect = aspect;
          this.panLayer.transition().duration(Views.D3.TRANSITION_LENGTH).attr('transform', d3.svg.transform().scale(aspect, aspect).translate([offX, offY]));
          fnD3Transform = function(x, y) {
            if (_this.layout === Views.D3.LAYOUTS.RADIAL_TREE) {
              return d3.svg.transform().rotate(x - 90).translate(y);
            } else if (_this.orientation === Views.D3.ORIENTATIONS.VERTICAL) {
              return d3.svg.transform().translate([x, y]);
            } else {
              return d3.svg.transform().translate([y, x]);
            }
          };
          links = this.panLayer.selectAll(".link").data(this.svgLinks, KEY_EDGE_FN);
          links.enter().append("path").attr("class", "link");
          links.transition().duration(Views.D3.TRANSITION_LENGTH).attr("d", diagonal);
          nodes = this.panLayer.selectAll(".node").data(this.svgNodes, KEY_FN);
          me = this;
          nodesEnter = nodes.enter().append("g").attr("class", "node").on('mouseover', function(d) {
            return me.nodeMouseover(d, this);
          }).on('mouseout', function(d) {
            return me.nodeMouseout(d, this);
          });
          nodesEnter.append("circle").attr("class", "outer-circle");
          nodesEnter.append("circle").attr("class", "inner-circle");
          nodesEnter.append("text");
          nodes.transition().duration(Views.D3.TRANSITION_LENGTH).attr("transform", function(d) {
            return fnD3Transform(d.x, d.y)();
          });
          _.each(nodes[0], function(d) {
            var data;
            d.parentNode.appendChild(d);
            data = d3.select(d).data()[0];
            return d3.select(d).classed({
              tiny: data.radius <= MIN_NODE_RADIUS,
              node: true,
              important: data.high_value
            });
          });
          this.d3Node = this.panLayer.selectAll(".node").data(this.svgNodes, KEY_FN);
          this.d3Link = this.panLayer.selectAll(".link").data(this.svgLinks, KEY_EDGE_FN);
          _.each(this.svgNodes, function(n) {
            if (_this.layout === Views.D3.LAYOUTS.RADIAL_TREE) {
              return n.radius = 40;
            }
          });
          this.panLayer.selectAll("circle.outer-circle").data(this.svgNodes, KEY_FN).attr("r", function(d) {
            return d.radius;
          });
          this.panLayer.selectAll("circle.inner-circle").data(this.svgNodes, KEY_FN).attr("r", function(d) {
            return Math.max(d.radius - Math.max(9 - d.depth, 0), 1);
          });
          this.panLayer.selectAll("text").data(this.svgNodes, KEY_FN).transition().duration(Views.D3.TRANSITION_LENGTH).attr("dx", 0).attr("dy", (this.oldZ != null) && this.oldZ > 12 ? 3 : 4).style("text-anchor", "middle");
          if (!this.minimapRendered) {
            _.delay((function() {
              if (!_this.minimapRendered) {
                return _this.minimap.render();
              }
            }), 500);
            this.minimapRendered = true;
          }
          this.zoomHandler(this.zoom);
          return this._fixText();
        };

        D3.prototype.toggleFullscreen = function(fullscreen) {
          var parent, parent2,
            _this = this;
          this.fullscreen = fullscreen;
          parent = this.$el.parents('.table-region');
          parent2 = this.$el.parents('.d3-graph-visualization');
          this.zoomHandler(1);
          if (this.fullscreen) {
            parent.css({
              position: 'fixed',
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              zIndex: 999,
              background: 'white'
            });
            parent2.css({
              overflow: 'none'
            });
          } else {
            parent.css({
              position: 'static'
            });
            parent2.css({
              overflow: 'hidden'
            });
          }
          return _.defer(function() {
            if (_this.fullscreen) {
              _this.width = _this.$el.width();
              _this.height = $(window).height();
              return _this.updateD3();
            } else {
              return _.delay((function() {
                return $(window).trigger('resize.sizeToFit');
              }), 1000);
            }
          });
        };

        D3.prototype.refreshSize = function() {
          this.width = this.$el.parent().width();
          return this.height = this.$el.parent().height();
        };

        D3.prototype.eventInsideSameParentNode = function() {
          var $fromNode, $toNode;
          $fromNode = $(d3.event.fromElement).parents('.node');
          $toNode = $(d3.event.toElement).parents('.node');
          return $fromNode.length && $toNode.length && $fromNode[0] === $toNode[0];
        };

        D3.prototype.nodeMouseout = function(d, node) {
          var next, prev;
          if (this.eventInsideSameParentNode()) {
            return;
          }
          d3.select(node).classed({
            hover: false
          });
          prev = this.selectPrev(d);
          prev.nodes.classed({
            selected: false
          });
          prev.links.classed({
            selected: false
          });
          next = this.selectNext(d);
          next.nodes.classed({
            forward: false
          });
          next.links.classed({
            forward: false
          });
          return this.trigger('node:mouseout', {
            node: node,
            data: d,
            mouse: d3.mouse(this.wrapSvg[0][0])
          });
        };

        D3.prototype.nodeMouseover = function(d, node) {
          var next, prev;
          if (this.eventInsideSameParentNode()) {
            return;
          }
          d3.select(node).classed({
            hover: true
          });
          node.parentNode.appendChild(node);
          prev = this.selectPrev(d);
          prev.nodes.classed({
            selected: true
          });
          prev.links.classed({
            selected: true
          });
          next = this.selectNext(d);
          next.nodes.classed({
            forward: true
          });
          next.links.classed({
            forward: true
          });
          return this.trigger('node:mouseover', {
            node: node,
            data: d,
            graphHeight: this.ui.graph.height(),
            graphWidth: this.ui.graph.width(),
            mouse: d3.mouse(this.wrapSvg[0][0]),
            graphOrientation: this.orientation
          });
        };

        D3.prototype.selectPrev = function(nodeData) {
          var nodeIds, parentData;
          nodeIds = {};
          nodeIds[nodeData.id] = true;
          while (parentData = nodeData != null ? nodeData.parent : void 0) {
            nodeIds[parentData.id] = true;
            nodeData = parentData;
          }
          return {
            nodes: this.d3Node.filter(function(d) {
              return nodeIds[d.id] != null;
            }),
            links: this.d3Link.filter(function(d) {
              return (nodeIds[d.source.id] != null) && (nodeIds[d.target.id] != null);
            })
          };
        };

        D3.prototype.selectNext = function(nodeData, nodeIds) {
          var child, top, _i, _len, _ref;
          top = !(nodeIds != null);
          if (top) {
            nodeIds = {};
          }
          nodeIds[nodeData.id] = true;
          if (nodeData.children != null) {
            _ref = nodeData.children;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              child = _ref[_i];
              this.selectNext(child, nodeIds);
            }
          }
          if (top) {
            return {
              nodes: this.d3Node.filter(function(d) {
                return nodeIds[d.id] != null;
              }),
              links: this.d3Link.filter(function(d) {
                return (nodeIds[d.source.id] != null) && (nodeIds[d.target.id] != null);
              })
            };
          }
        };

        D3.prototype._fixText = function() {
          var _this = this;
          this.debouncedFixText || (this.debouncedFixText = _.debounce((function() {
            var me;
            me = _this;
            return _this.panLayer.selectAll("text").data(_this.svgNodes, KEY_FN).each(function(d) {
              var rad;
              rad = Math.max(d.radius - Math.max(9 - d.depth, 0), 1);
              if (rad * me.minimap.scale() < 40) {
                return d3.select(this).attr('display', 'none');
              } else {
                d3.select(this).attr('display', 'block');
                return me._trimText(this, d.host_name || d.address, (rad - 9) * 2);
              }
            });
          }), 100));
          return this.debouncedFixText();
        };

        D3.prototype._trimText = function(textObj, textString, width) {
          var x;
          textObj.textContent = textString;
          try {
            if (textObj.getSubStringLength(0, textString.length) >= width) {
              x = textString.length - 1;
              while (x > 0) {
                if (textObj.getSubStringLength(0, x) <= width) {
                  textObj.textContent = textString.substring(0, x) + "…";
                  return;
                }
                x--;
              }
              return textObj.style.display = 'none';
            }
          } catch (_error) {}
        };

        D3.prototype._buildNestedStructure = function(nodes, edges) {
          var bail, roots,
            _this = this;
          if (!(nodes.length > 0 || edges.length > 0)) {
            return;
          }
          this.allEdges || (this.allEdges = [].concat(edges));
          this.nodesQuick || (this.nodesQuick = {});
          _.each(nodes, function(node) {
            return _this.nodesQuick[node.id] = node;
          });
          bail = false;
          _.every(this.allEdges, function(edge) {
            var dest, source;
            source = _this.nodesQuick[edge.source_node_id];
            dest = _this.nodesQuick[edge.dest_node_id];
            dest.credInfo = edge;
            if (dest != null) {
              dest.hasParent = true;
            }
            source.children || (source.children = []);
            source.childrenMap || (source.childrenMap = {});
            if ((dest != null) && !(source.childrenMap[dest.id] != null)) {
              source.childrenMap[dest.id] = 1;
              source.children.push(dest);
            }
            return true;
          });
          if (bail) {
            return;
          }
          this.leafNodes = 0;
          this.root = null;
          roots = [];
          _.each(nodes, function(node) {
            if (!node.hasParent) {
              roots.push(node);
            }
            if (!node.children) {
              return _this.leafNodes++;
            }
          });
          return this.root = _.min(roots, function(obj) {
            return obj.id;
          });
        };

        D3.prototype._updateNestedStructure = function(nodes, edges) {
          var newNodes,
            _this = this;
          if (nodes.length > 0 && !(this.nodesQuick != null)) {
            return this._buildNestedStructure(nodes, edges);
          }
          newNodes = [];
          _.each(nodes, function(node) {
            if (_this.nodesQuick[node.id] == null) {
              newNodes.push(node);
              _this.nodesQuick[node.id] = node;
              return _this.leafNodes++;
            }
          });
          this.allEdges = this.allEdges.concat(edges);
          _.each(this.allEdges, function(edge) {
            var dest, source;
            source = _this.nodesQuick[edge.source_node_id];
            dest = _this.nodesQuick[edge.dest_node_id];
            if (!((source != null) && (dest != null))) {
              return;
            }
            if (edge.added) {
              return;
            }
            edge.added = true;
            dest.credInfo = edge;
            if (dest != null) {
              dest.hasParent = true;
            }
            source.children || (source.children = []);
            source.childrenMap || (source.childrenMap = {});
            if (source.childrenMap[dest.id] == null) {
              source.childrenMap[dest.id] = 1;
              return source.children.push(dest);
            }
          });
          return this.root;
        };

        return D3;

      })(Marionette.ItemView);
    });
  });

}).call(this);
