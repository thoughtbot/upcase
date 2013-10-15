window.SubG ||= {}

class SubG.SignificantEventMarkers extends SubG.Graph
  constructor: (@svg, @eventData, @w, @h, @projectedGrowth, @margin) ->
    @data = @projectedGrowth.data
    @setXScale()

    @_drawAxisCircles()

  _drawAxisCircles: =>
    @svg.selectAll('circle.event-markers')
      .data(@eventData).enter()
      .append('circle')
      .attr(
        cx: (d) => @xScale(Date.parse(d.date))
        cy: @h - @margin.bottom
      )
      .attr('r', 3)
      .style(
        stroke: 'black'
      )
      .classed('event-markers', true)
      .on('mouseover', @_axisCircleMouseOver)
      .on('mouseout', @_clear)

  _axisCircleMouseOver: (d) =>
    @_drawLine(d)
    @_drawText(d)

  _clear: =>
    @svg.selectAll('.event-marker').remove()

  _drawLine: (d) =>
    @svg
      .append('line')
      .attr(
        x1: @xScale(Date.parse(d.date))
        x2: @xScale(Date.parse(d.date))
        y1: @margin.top
        y2: @h - @margin.top
      )
      .style(
        stroke: 'black'
        'stroke-dasharray': '3,5'
      )
      .classed('event-marker', true)

  _drawText: (d) =>
    @svg
      .append('text')
      .attr(
        x: @xScale(Date.parse(d.date)) + 5
        y: @h/2
      )
      .text(d.event_description)
      .attr('font-size', 12)
      .classed('event-marker', true)
