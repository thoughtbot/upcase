#= require jquery
#= require d3
#= require underscore
#= require subscription_graph/util
#= require subscription_graph/mouse_tracker
#= require subscription_graph/tooltip
#= require subscription_graph/graph
#= require subscription_graph/projected_growth_graph
#= require subscription_graph/rate_of_change_graph
#= require subscription_graph/current_growth_graph
#= require subscription_graph/significant_events_markers

w = 300 * 3
h = 250


parseData = (entry) =>
  {
    date: new Date(entry.date),
    count: parseInt(entry.count)
  }

d3.csv 'https://s3.amazonaws.com/thoughtbot-books/reports/subscriptions.csv', (error, data) =>
  svg = d3.select('#growth_graph')
          .append('svg')
          .attr('width', w)
          .attr('height', h)

  svgLower = d3.select("#rate_of_growth_graph")
    .append('svg')
    .attr('width', w)
    .attr('height', h)

  $ ->
    data = $.map(data, parseData)

    margin = {
      left: 35
      right: 30
      top: 15
      bottom: 30
    }

    projectedGrowthGraph = new SubG.ProjectedGrowthGraph(svg, data, w, h, margin)
    new SubG.CurrentGrowthGraph(svg, data, w, h, projectedGrowthGraph, margin)
    new SubG.RateOfChangeGraph(svgLower, data, w, h/2, projectedGrowthGraph, margin)

    d3.csv '/learn-events.csv', (error, learnEvents) ->
      new SubG.SignificantEventMarkers(svgLower, learnEvents, w, h/2, projectedGrowthGraph, margin)
      new SubG.SignificantEventMarkers(svg, learnEvents, w, h, projectedGrowthGraph, margin)
