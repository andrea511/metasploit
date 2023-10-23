define [
  'd3_min'
  'jquery'
  'd3_transform'
], (d3, $) ->

  # This is a small helper class for managing the minimap.
  # This is based on demo code here:
  # http://www.billdwhite.com/wordpress/2014/02/03/d3-pan-and-zoom-reuse-demo/
  minimap = ->
    minimapScale = null
    scale        = 1
    zoom         = null
    base         = null
    target       = null
    width        = 0
    height       = 0
    x            = 0
    y            = 0
    frameX       = 0
    frameY       = 0

    minimap = (selection) ->
      base = selection
      container = selection.append("g").attr("class", "minimap").call(zoom)
      zoom.on "zoom.minimap", ->
        scale = d3.event.scale

      getXYFromTranslate = (translateString) ->
        split = translateString.split(",")
        x = if split[0] then ~~split[0].split("(")[1] else 0
        y = if split[1] then ~~split[1].split(")")[0] else 0
        [x, y]

      normalizeDrag = ([x, y]) ->
        [x, y]

      toggleMap = ->
        container.attr('display', if zoom.scale() < 1.1 then 'none' else '')

      minimap.node = container.node()
      frame = container.append("g").attr("class", "frame")
      frame.append("rect")
        .attr("class", "background")
        .attr("width", width)
        .attr("height", height)
        .attr("filter", "url(#minimapDropShadow)")
      drag = d3.behavior.drag().on("dragstart.minimap", ->
        frameTranslate = normalizeDrag(getXYFromTranslate(frame.attr("transform")))
        frameX = frameTranslate[0]
        frameY = frameTranslate[1]
      ).on("drag.minimap", ->
        d3.event.sourceEvent.stopImmediatePropagation()
        frameTranslate = normalizeDrag([frameX + d3.event.dx, frameY + d3.event.dy])
        frameX = frameTranslate[0]
        frameY = frameTranslate[1]
        frame.attr "transform", d3.svg.transform().translate([frameX, frameY])
        translate = [-frameX * scale, -frameY * scale]
        target.attr "transform", d3.svg.transform().translate(translate).scale(scale)
        zoom.translate translate
        toggleMap()
      )
      frame.call drag

      minimap.render = ->
        scale = zoom.scale()
        container.attr "transform", d3.svg.transform().scale(minimapScale).translate([50, 220])
        node = target.node().cloneNode(true)
        node.removeAttribute "id"
        base.selectAll(".minimap .panCanvas").remove()
        minimap.node.appendChild node
        targetTransform = getXYFromTranslate(target.attr("transform"))
        translate = d3.svg.transform().translate([(-targetTransform[0] / scale), (-targetTransform[1] / scale)])
        frame.attr("transform", translate)
          .select(".background")
          .attr("width", width / scale)
          .attr "height", height / scale
        frame.node().parentNode.appendChild frame.node()
        d3.select(node).attr("transform", d3.svg.transform().translate([1, 1]))
        toggleMap()
        @

      minimap.update = ->
        frame.attr "transform", d3.svg.transform().translate([frameX, frameY])
        translate = [-frameX * scale, -frameY * scale]
        target.attr "transform", d3.svg.transform().translate(translate).scale(scale)
        zoom.translate translate
        toggleMap()
        @

    minimap.width = (value) ->
      return width unless arguments.length
      width = parseInt(value, 10)
      @

    minimap.height = (value) ->
      return height unless arguments.length
      height = parseInt(value, 10)
      @

    minimap.x = (value) ->
      return frameX unless arguments.length
      frameX = parseInt(value, 10)
      @

    minimap.y = (value) ->
      return frameY unless arguments.length
      frameY = parseInt(value, 10)
      @

    minimap.scale = (value) ->
      return scale unless arguments.length
      scale = value
      frameX /= scale
      frameY /= scale
      @

    minimap.minimapScale = (value) ->
      return minimapScale unless arguments.length
      minimapScale = value
      @

    minimap.zoom = (value) ->
      return zoom unless arguments.length
      zoom = value
      @

    minimap.target = (value) ->
      return target unless arguments.length
      target = value
      width = parseInt(target.attr("width"), 10)
      height = parseInt(target.attr("height"), 10)
      @

    minimap
