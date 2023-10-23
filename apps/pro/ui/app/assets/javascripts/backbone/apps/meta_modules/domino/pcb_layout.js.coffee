define [
  'd3_min'
], (d3) ->

  #
  # Some D3 helper functions copied from the D3 Source
  #

  # Post-order traversal.
  d3_layout_hierarchyVisitAfter = (node, callback) ->
    nodes = [node]
    nodes2 = []
    while (node = nodes.pop())?
      nodes2.push node
      if (children = node.children) and (n = children.length)
        i = -1
        nodes.push children[i]  while ++i < n
    callback node  while (node = nodes2.pop())?

  #
  # Implements a cluster-like layout that maximizes aspect ratio space
  #

  # TODO: Dry this up to use same code as `visualization_views.js.coffee`
  MAX_NODE_RADIUS = 100
  MIN_NODE_RADIUS = 60
  MIN_DEPTH_PAD = 100
  calculateCircleRadius = (depth, maxDepth) ->
    # exponentially decrease radius with depth.
    maxDepth++
    Math.floor(Math.max(MAX_NODE_RADIUS-(depth/maxDepth)*(MAX_NODE_RADIUS-MIN_NODE_RADIUS), MIN_NODE_RADIUS))

  PcbLayout = ->

    hierarchy = d3.layout.hierarchy().value(null).sort(null)
    size = [ 1, 1 ]
    iterations = 0

    cluster = (d, i) ->
      nodes     = hierarchy.call(@, d, i)
      root      = nodes[0]
      maxDepth  = 0
      depthMap  = []
      levelMap  = []
      nodeCount = 0
      fits      = false
      layout    = null
      w         = Math.max(size[0], 600)
      h         = Math.max(size[1], 600)

      # We need to calculate a few aggregate properties:
      # maxDepth, nodeCount, and depthPopulationMap
      _.each nodes, (d) ->
        maxDepth = Math.max(maxDepth, d.depth)
        depthMap[d.depth] ||= []
        depthMap[d.depth].push(d)
        nodeCount++

      # Enter an adjust-and-try-again loop
      # TODO: Unroll this into an O(1) function.
      iterations = 0
      until fits or iterations > 1000

        # Calculate the minimum space required for each bucket in our scheme
        depthWidths = new Array(maxDepth)
        depthDimensions = new Array(maxDepth)
        totalWidthNecessary = 0
        c = false
        _.times maxDepth+1, (idx) ->
          return if c
          nodeSize = Math.max(calculateCircleRadius(idx,maxDepth)*2-iterations, 5)

          # IMPORTANT: this code assumes the horizontal layout, even though we switched
          # to using the vertical by default. that's okay as the d3 diagonal remaps
          # the coordinates for us, but it makes the code a bit confusing.
          nodesPerCol = Math.max(Math.floor(h/nodeSize), 1)
          nodesPerRow = Math.ceil(depthMap[idx].length / nodesPerCol)
          if nodesPerRow == 1 and nodesPerCol > 200
            # prevent a silly-looking explosion in width
            nodesPerRow = Math.max(Math.floor(w/(maxDepth+1)/nodeSize),1)
            nodesPerCol = Math.ceil(depthMap[idx].length / nodesPerRow)

          if nodesPerRow > 1 and depthMap[idx].length < 5 and iterations < 400
            c = true
            iterations++
            return

          depthWidths[idx] = nodesPerRow * nodeSize
          depthDimensions[idx] = [nodesPerRow, nodesPerCol] # <width,height>
          totalWidthNecessary += depthWidths[idx]
          levelMap[idx] = Math.floor(depthMap[idx].length / nodesPerRow)

        continue if c
        fits = totalWidthNecessary < (w-MIN_DEPTH_PAD)
        unless fits
          iterations++
          w += 5
          h += 5

      availableDepthPadding = (w - totalWidthNecessary) / maxDepth
      if _.isFinite(availableDepthPadding)
        availableDepthPadding = Math.min(availableDepthPadding, 400)
      else
        availableDepthPadding = w/2

      # first, the nodes are separated out by X value
      depthIndices = {}
      xForNode = (node) ->
        x = 0
        _.times node.depth, (i) -> x += depthWidths[i]+availableDepthPadding
        x + availableDepthPadding

      d3_layout_hierarchyVisitAfter root, (node) ->
        depthIndices[node.depth] ||= []
        siblings = depthIndices[node.depth]
        nodeSize = Math.max(calculateCircleRadius(node.depth,maxDepth)*2-iterations, 5)
        prevSize = Math.max(calculateCircleRadius(node.depth,maxDepth-1)*2-iterations, 5)

        node.radius = nodeSize / 2
        siblingIdx = siblings.length
        
        # create a clustered grid
        top = Math.floor(siblingIdx/depthDimensions[node.depth][0]) % depthDimensions[node.depth][1]
        left = Math.floor(siblingIdx % depthDimensions[node.depth][0])

        # Add the in/out weaving
        if left % 2 == 1
          top += .5

        push = MAX_NODE_RADIUS/6
        # space out vertically
        if depthMap[node.depth].length <= depthDimensions[node.depth][1]
          # space them out evenly across the y
          partitionHeight = h / (depthMap[node.depth].length+1)
          node.x = push + partitionHeight*(siblingIdx+1) - nodeSize/2
        else
          levels = levelMap[node.depth]
          realLevels = Math.floor(depthMap[node.depth].length / depthDimensions[node.depth][0])
          currLevel = Math.floor(siblingIdx / depthDimensions[node.depth][1])
          padding = (h - levels * nodeSize)
          currOffset = (padding/levels)*currLevel
          if _.isNaN(currOffset) then currOffset = 0
          node.x = push+top*padding/levels + nodeSize * top + (levels-realLevels)*((padding/levels)+nodeSize)/2

        node.y = xForNode(node) + (left * nodeSize)

        siblings.push(node)

      nodes

    cluster.size = (x) ->
      return size unless arguments.length
      size = x
      @

    cluster.iterations = -> iterations

    cluster.links = (nodes) ->
      d3.merge _.map(nodes, ((parent) ->
        (parent.children or []).map (child) ->
          source: parent
          target: child
      ))

    d3.rebind(cluster, hierarchy, "sort", "children", "value")
    # Add an alias for nodes and links, for convenience.
    cluster.nodes = cluster
    cluster
