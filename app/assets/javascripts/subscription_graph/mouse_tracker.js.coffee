window.SubG ||= {}

SubG.MouseTracker =
  position: (@svg, @xScale, @yScale, @data, @margin) ->
    xPos = @_xPos()
    closestPoint = @_closestPoint(xPos)
    yPos = @_yPos(closestPoint)
    { x: xPos, y: yPos, datapoint: closestPoint }

  _closestPoint: (xPos) ->
    xValue = @xScale.invert(xPos)
    _.find @data, (d) -> xValue < d.date

  _xPos: ->
    mouse = d3.mouse(@svg[0][0])
    xPos = mouse[0]

    if xPos < @margin.left
      xPos = @margin.left
    xPos

  _yPos: (closestPoint) ->
    return undefined unless closestPoint?
    @yScale(closestPoint.count)
