window.SubG ||= {}

class SubG.Tooltip
  @instance: -> @_instance ?= new @(arguments...)

  tooltipWidth: 85
  tooltipHeight: 40
  lineHeight: 14
  textMargin: 5

  @removeExistingTooltips: ->
    d3.selectAll('.tooltip-line').remove()
    d3.selectAll('.tooltip-rect').remove()
    d3.selectAll('.tooltip-text').remove()

  @draw: (svg, x, y, dataPoint, margin) ->
    @removeExistingTooltips()
    tooltip = @instance(svg, margin)
    tooltip.x = x
    tooltip.y = y
    tooltip.draw(dataPoint)

  constructor: (@svg, @margin) ->

  draw: (dataPoint) ->
    @_resetInversion()
    @_drawLine()
    rect = @_drawRect()

    dateTextYPos = @_textYPos(@lineHeight)
    valueTextYPos = @_textYPos(@lineHeight * 2)

    tooltipDateText = @_drawText(dateTextYPos, dataPoint.date.toDateString().slice(3))
    tooltipDateText.classed('tooltip-date-text', true)

    tooltipValueText = @_drawText(valueTextYPos, "#{dataPoint.count} Users")
    tooltipValueText.classed('tooltip-value-text', true)

  _shouldInvert: ->
    @__shouldInvert

  _resetInversion: ->
    @__shouldInvert = false
    if @_outOfBounds()
      @__shouldInvert = true

  _textAnchor: ->
    if @_outOfBounds() then 'start' else 'end'

  _height: ->
    @__height = @svg.attr('height')

  _outOfBounds: ->
    @x < @tooltipWidth || @y > (@_height() - @margin.bottom - @tooltipHeight)

  _drawLine: () ->
    @svg.append('line')
      .classed('tooltip-line', true)
      .attr('x1', @x)
      .attr('x2', @x)
      .attr('y1', @margin.top)
      .attr('y2', @_height() - @margin.bottom)

  _drawRect: ->
    pos = if @_shouldInvert()
      {x: @x, y: @y - @tooltipHeight}
    else
      {x: @x - @tooltipWidth, y: @y}

    @svg.append('rect')
      .classed('tooltip-rect', true)
      .attr('x', pos.x)
      .attr('y', pos.y)
      .attr('width', @tooltipWidth)
      .attr('height', @tooltipHeight)

  _drawText: (yPos, text) ->
    textMarginMultiplier = if @_shouldInvert() then 1 else -1
    x = @x + (textMarginMultiplier * @textMargin)
    @svg.append('text')
      .classed('tooltip-text', true)
      .attr('x', x)
      .attr('y', yPos)
      .attr('text-anchor', @_textAnchor())
      .text(text)

  _textYPos: (lineHeight) ->
    if @_shouldInvert()
      @y + lineHeight - @tooltipHeight
    else
      @y + lineHeight
