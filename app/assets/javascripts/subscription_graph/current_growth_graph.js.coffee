window.SubG ||= {}

class SubG.CurrentGrowthGraph extends SubG.Graph
  constructor: (@svg, @data, @w, @h, @projectedGrowth, @margin) ->
    @setXScale()
    @setYScale()
    @drawGrowthCurve()
    @drawTitle('Current and Projected Growth')
    @drawAxes()

  drawGrowthCurve: =>
    barChartHeight = @h - @margin.bottom

    area = d3.svg.area()
      .x((d) => @xScale(d.date))
      .y0(barChartHeight)
      .y1((d) => @yScale(d.count))

    @svg.append('g')
      .classed('growth-area', true)
      .append('path')
      .attr('d', area(@data))

    lineGenerator = d3.svg.line()
      .x((d) => @xScale(d.date))
      .y((d) => @yScale(d.count))

    @svg.append('path')
      .attr('d', lineGenerator(@data))
      .classed('growth-line', true)

    @svg
      .on('mousemove', @drawTooltip)
      .on('mouseout', @removeTooltip)

  drawTooltip: =>
    mouseTracker = SubG.MouseTracker.position(@svg, @xScale, @yScale, @data, @margin)
    return unless mouseTracker.datapoint?

    SubG.Tooltip.draw(@svg, mouseTracker.x, mouseTracker.y, mouseTracker.datapoint, @margin)

  removeTooltip: =>
    SubG.Tooltip.removeExistingTooltips()
