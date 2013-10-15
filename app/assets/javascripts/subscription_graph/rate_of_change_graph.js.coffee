window.SubG ||= {}

class SubG.RateOfChangeGraph extends SubG.Graph
  constructor: (@svg, @data, @w, @h, @projectedGrowth, @margin) ->
    @setXScale()
    @setYScale()
    @drawAxes()
    @drawTitle('Rate of Change')
    @drawRateOfChange()

  setYScale: =>
    ratesOfChange = @ratesOfChange()
    min = d3.min(ratesOfChange, (d) -> d.rate)
    max = d3.max(ratesOfChange, (d) -> d.rate)
    @yScale = d3.scale.linear().domain([min, max]).range([@h - @margin.bottom, @margin.top])

  ratesOfChange: =>
    mspd = 24*60*60*1000
    span = 30
    _.map [0..(@data.length - 1)], (i) =>
      range = SubG.Util.sliceBehind(@data, i, span)
      reg = SubG.Util.regression(range, SubG.Util.dateAndCountFormatter)
      date: @data[i].date, rate: (reg.slope * mspd)

  drawRateOfChange: =>
    line = d3.svg.line()
      .x((d) => @xScale(d.date))
      .y((d) => @yScale(d.rate))

    @svg.append('path')
      .attr('d', line(@ratesOfChange()))
      .classed('rate-of-change-line', true)
      .attr('transform', 'translate(2)')
