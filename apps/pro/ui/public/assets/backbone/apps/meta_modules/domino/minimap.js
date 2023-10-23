(function() {

  define(['d3_min', 'jquery', 'd3_transform'], function(d3, $) {
    var minimap;
    return minimap = function() {
      var base, frameX, frameY, height, minimapScale, scale, target, width, x, y, zoom;
      minimapScale = null;
      scale = 1;
      zoom = null;
      base = null;
      target = null;
      width = 0;
      height = 0;
      x = 0;
      y = 0;
      frameX = 0;
      frameY = 0;
      minimap = function(selection) {
        var container, drag, frame, getXYFromTranslate, normalizeDrag, toggleMap;
        base = selection;
        container = selection.append("g").attr("class", "minimap").call(zoom);
        zoom.on("zoom.minimap", function() {
          return scale = d3.event.scale;
        });
        getXYFromTranslate = function(translateString) {
          var split;
          split = translateString.split(",");
          x = split[0] ? ~~split[0].split("(")[1] : 0;
          y = split[1] ? ~~split[1].split(")")[0] : 0;
          return [x, y];
        };
        normalizeDrag = function(_arg) {
          var x, y;
          x = _arg[0], y = _arg[1];
          return [x, y];
        };
        toggleMap = function() {
          return container.attr('display', zoom.scale() < 1.1 ? 'none' : '');
        };
        minimap.node = container.node();
        frame = container.append("g").attr("class", "frame");
        frame.append("rect").attr("class", "background").attr("width", width).attr("height", height).attr("filter", "url(#minimapDropShadow)");
        drag = d3.behavior.drag().on("dragstart.minimap", function() {
          var frameTranslate;
          frameTranslate = normalizeDrag(getXYFromTranslate(frame.attr("transform")));
          frameX = frameTranslate[0];
          return frameY = frameTranslate[1];
        }).on("drag.minimap", function() {
          var frameTranslate, translate;
          d3.event.sourceEvent.stopImmediatePropagation();
          frameTranslate = normalizeDrag([frameX + d3.event.dx, frameY + d3.event.dy]);
          frameX = frameTranslate[0];
          frameY = frameTranslate[1];
          frame.attr("transform", d3.svg.transform().translate([frameX, frameY]));
          translate = [-frameX * scale, -frameY * scale];
          target.attr("transform", d3.svg.transform().translate(translate).scale(scale));
          zoom.translate(translate);
          return toggleMap();
        });
        frame.call(drag);
        minimap.render = function() {
          var node, targetTransform, translate;
          scale = zoom.scale();
          container.attr("transform", d3.svg.transform().scale(minimapScale).translate([50, 220]));
          node = target.node().cloneNode(true);
          node.removeAttribute("id");
          base.selectAll(".minimap .panCanvas").remove();
          minimap.node.appendChild(node);
          targetTransform = getXYFromTranslate(target.attr("transform"));
          translate = d3.svg.transform().translate([-targetTransform[0] / scale, -targetTransform[1] / scale]);
          frame.attr("transform", translate).select(".background").attr("width", width / scale).attr("height", height / scale);
          frame.node().parentNode.appendChild(frame.node());
          d3.select(node).attr("transform", d3.svg.transform().translate([1, 1]));
          toggleMap();
          return this;
        };
        return minimap.update = function() {
          var translate;
          frame.attr("transform", d3.svg.transform().translate([frameX, frameY]));
          translate = [-frameX * scale, -frameY * scale];
          target.attr("transform", d3.svg.transform().translate(translate).scale(scale));
          zoom.translate(translate);
          toggleMap();
          return this;
        };
      };
      minimap.width = function(value) {
        if (!arguments.length) {
          return width;
        }
        width = parseInt(value, 10);
        return this;
      };
      minimap.height = function(value) {
        if (!arguments.length) {
          return height;
        }
        height = parseInt(value, 10);
        return this;
      };
      minimap.x = function(value) {
        if (!arguments.length) {
          return frameX;
        }
        frameX = parseInt(value, 10);
        return this;
      };
      minimap.y = function(value) {
        if (!arguments.length) {
          return frameY;
        }
        frameY = parseInt(value, 10);
        return this;
      };
      minimap.scale = function(value) {
        if (!arguments.length) {
          return scale;
        }
        scale = value;
        frameX /= scale;
        frameY /= scale;
        return this;
      };
      minimap.minimapScale = function(value) {
        if (!arguments.length) {
          return minimapScale;
        }
        minimapScale = value;
        return this;
      };
      minimap.zoom = function(value) {
        if (!arguments.length) {
          return zoom;
        }
        zoom = value;
        return this;
      };
      minimap.target = function(value) {
        if (!arguments.length) {
          return target;
        }
        target = value;
        width = parseInt(target.attr("width"), 10);
        height = parseInt(target.attr("height"), 10);
        return this;
      };
      return minimap;
    };
  });

}).call(this);
