(function() {

  define(['d3_min'], function(d3) {
    var MAX_NODE_RADIUS, MIN_DEPTH_PAD, MIN_NODE_RADIUS, PcbLayout, calculateCircleRadius, d3_layout_hierarchyVisitAfter;
    d3_layout_hierarchyVisitAfter = function(node, callback) {
      var children, i, n, nodes, nodes2, _results;
      nodes = [node];
      nodes2 = [];
      while ((node = nodes.pop()) != null) {
        nodes2.push(node);
        if ((children = node.children) && (n = children.length)) {
          i = -1;
          while (++i < n) {
            nodes.push(children[i]);
          }
        }
      }
      _results = [];
      while ((node = nodes2.pop()) != null) {
        _results.push(callback(node));
      }
      return _results;
    };
    MAX_NODE_RADIUS = 100;
    MIN_NODE_RADIUS = 60;
    MIN_DEPTH_PAD = 100;
    calculateCircleRadius = function(depth, maxDepth) {
      maxDepth++;
      return Math.floor(Math.max(MAX_NODE_RADIUS - (depth / maxDepth) * (MAX_NODE_RADIUS - MIN_NODE_RADIUS), MIN_NODE_RADIUS));
    };
    return PcbLayout = function() {
      var cluster, hierarchy, iterations, size;
      hierarchy = d3.layout.hierarchy().value(null).sort(null);
      size = [1, 1];
      iterations = 0;
      cluster = function(d, i) {
        var availableDepthPadding, c, depthDimensions, depthIndices, depthMap, depthWidths, fits, h, layout, levelMap, maxDepth, nodeCount, nodes, root, totalWidthNecessary, w, xForNode;
        nodes = hierarchy.call(this, d, i);
        root = nodes[0];
        maxDepth = 0;
        depthMap = [];
        levelMap = [];
        nodeCount = 0;
        fits = false;
        layout = null;
        w = Math.max(size[0], 600);
        h = Math.max(size[1], 600);
        _.each(nodes, function(d) {
          var _name;
          maxDepth = Math.max(maxDepth, d.depth);
          depthMap[_name = d.depth] || (depthMap[_name] = []);
          depthMap[d.depth].push(d);
          return nodeCount++;
        });
        iterations = 0;
        while (!(fits || iterations > 1000)) {
          depthWidths = new Array(maxDepth);
          depthDimensions = new Array(maxDepth);
          totalWidthNecessary = 0;
          c = false;
          _.times(maxDepth + 1, function(idx) {
            var nodeSize, nodesPerCol, nodesPerRow;
            if (c) {
              return;
            }
            nodeSize = Math.max(calculateCircleRadius(idx, maxDepth) * 2 - iterations, 5);
            nodesPerCol = Math.max(Math.floor(h / nodeSize), 1);
            nodesPerRow = Math.ceil(depthMap[idx].length / nodesPerCol);
            if (nodesPerRow === 1 && nodesPerCol > 200) {
              nodesPerRow = Math.max(Math.floor(w / (maxDepth + 1) / nodeSize), 1);
              nodesPerCol = Math.ceil(depthMap[idx].length / nodesPerRow);
            }
            if (nodesPerRow > 1 && depthMap[idx].length < 5 && iterations < 400) {
              c = true;
              iterations++;
              return;
            }
            depthWidths[idx] = nodesPerRow * nodeSize;
            depthDimensions[idx] = [nodesPerRow, nodesPerCol];
            totalWidthNecessary += depthWidths[idx];
            return levelMap[idx] = Math.floor(depthMap[idx].length / nodesPerRow);
          });
          if (c) {
            continue;
          }
          fits = totalWidthNecessary < (w - MIN_DEPTH_PAD);
          if (!fits) {
            iterations++;
            w += 5;
            h += 5;
          }
        }
        availableDepthPadding = (w - totalWidthNecessary) / maxDepth;
        if (_.isFinite(availableDepthPadding)) {
          availableDepthPadding = Math.min(availableDepthPadding, 400);
        } else {
          availableDepthPadding = w / 2;
        }
        depthIndices = {};
        xForNode = function(node) {
          var x;
          x = 0;
          _.times(node.depth, function(i) {
            return x += depthWidths[i] + availableDepthPadding;
          });
          return x + availableDepthPadding;
        };
        d3_layout_hierarchyVisitAfter(root, function(node) {
          var currLevel, currOffset, left, levels, nodeSize, padding, partitionHeight, prevSize, push, realLevels, siblingIdx, siblings, top, _name;
          depthIndices[_name = node.depth] || (depthIndices[_name] = []);
          siblings = depthIndices[node.depth];
          nodeSize = Math.max(calculateCircleRadius(node.depth, maxDepth) * 2 - iterations, 5);
          prevSize = Math.max(calculateCircleRadius(node.depth, maxDepth - 1) * 2 - iterations, 5);
          node.radius = nodeSize / 2;
          siblingIdx = siblings.length;
          top = Math.floor(siblingIdx / depthDimensions[node.depth][0]) % depthDimensions[node.depth][1];
          left = Math.floor(siblingIdx % depthDimensions[node.depth][0]);
          if (left % 2 === 1) {
            top += .5;
          }
          push = MAX_NODE_RADIUS / 6;
          if (depthMap[node.depth].length <= depthDimensions[node.depth][1]) {
            partitionHeight = h / (depthMap[node.depth].length + 1);
            node.x = push + partitionHeight * (siblingIdx + 1) - nodeSize / 2;
          } else {
            levels = levelMap[node.depth];
            realLevels = Math.floor(depthMap[node.depth].length / depthDimensions[node.depth][0]);
            currLevel = Math.floor(siblingIdx / depthDimensions[node.depth][1]);
            padding = h - levels * nodeSize;
            currOffset = (padding / levels) * currLevel;
            if (_.isNaN(currOffset)) {
              currOffset = 0;
            }
            node.x = push + top * padding / levels + nodeSize * top + (levels - realLevels) * ((padding / levels) + nodeSize) / 2;
          }
          node.y = xForNode(node) + (left * nodeSize);
          return siblings.push(node);
        });
        return nodes;
      };
      cluster.size = function(x) {
        if (!arguments.length) {
          return size;
        }
        size = x;
        return this;
      };
      cluster.iterations = function() {
        return iterations;
      };
      cluster.links = function(nodes) {
        return d3.merge(_.map(nodes, (function(parent) {
          return (parent.children || []).map(function(child) {
            return {
              source: parent,
              target: child
            };
          });
        })));
      };
      d3.rebind(cluster, hierarchy, "sort", "children", "value");
      cluster.nodes = cluster;
      return cluster;
    };
  });

}).call(this);
