window.SubG ||= {}

class SubG.ProjectedGrowthGraph extends SubG.Graph
  constructor: (@svg, @data, @w, @h, @margin) ->
    @setProjectedPoints()
    @setXScale()
    @setYScale()
    @drawProjection()
    @drawProjectedDate()

  setProjectedPoints: =>
    regressionDays = 30
    subscribersGoal = @projectedUserTarget()
    days = @data.slice(-regressionDays)
    reg = SubG.Util.regression(days, SubG.Util.dateAndCountFormatter)
    @_projectedDate = new Date((subscribersGoal - reg.intercept) / reg.slope)
    @projectedPoints = [days[0], {count: subscribersGoal, date: @_projectedDate}]

  drawProjection: =>
    line = d3.svg.line()
      .x((d) => @xScale(d.date))
      .y((d) => @yScale(d.count))

    @svg.append('path')
      .classed('projected-growth-line', true)
      .attr('d', line(@projectedPoints))

  setXScale: =>
    minDate = @data[0].date
    maxDate = @projectedDate()
    @xScale = d3.time.scale().domain([minDate, maxDate]).range([@margin.left, @w - @margin.right])

  drawProjectedDate: =>
    svgNode = $(@svg.node())
    dateString = @projectedDate().toDateString().slice(3)
    svgNode.parent().append("<p class='projected-date'><strong>Estimated Date for #{@projectedUserTarget()} Users</strong>: #{dateString}</p>")

  projectedDate: =>
    @_projectedDate
