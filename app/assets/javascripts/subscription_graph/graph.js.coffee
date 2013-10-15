window.SubG ||= {}

class SubG.Graph

  setXScale: =>
    minDate = @data[0].date
    maxDate = @projectedGrowth.projectedDate()
    @xScale = d3.time.scale().domain([minDate, maxDate]).range([@margin.left, @w - @margin.right])

  setYScale: =>
    maxCount = @projectedUserTarget()
    @yScale = d3.scale.linear().domain([0, maxCount]).range([@h - @margin.bottom, @margin.top])

  projectedUserTarget: =>
    @_projectedUserTarget ||= parseInt $('#projected_growth_target').data('count')

  drawTitle: (titleText) =>
    @svg.append('text')
      .classed('graph-title', true)
      .text(titleText)
      .attr('x', @w/2)
      .attr('y', @margin.top)

  drawAxes: =>
    yAxis = d3.svg.axis().scale(@yScale).orient('left').ticks(6)
    xAxis = d3.svg.axis().scale(@xScale).orient('bottom')

    @svg.append('g')
      .attr('transform', "translate(0, #{@h - @margin.bottom})")
      .attr('class', 'axis')
      .call(xAxis)

    @svg.append('g')
      .attr('transform', "translate(#{@margin.left})")
      .attr('class', 'axis')
      .call(yAxis)
