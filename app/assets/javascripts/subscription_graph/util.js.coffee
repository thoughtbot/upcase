window.SubG ||= {}

window.SubG.Util =

  # Based on this algorithm: http://math.stackexchange.com/questions/204020/
  regression: (data, pointFormatter) ->
    if data.length <= 1
      return slope: 0, intercept: 0
    [sigX, sigY, sigXY, sigXsquared] = [0, 0, 0, 0]
    for d in data
      point = pointFormatter(d)
      sigX += point.x
      sigY += point.y
      sigXY += (point.x * point.y)
      sigXsquared += (point.x * point.x)
    count = data.length
    slope = ( count * sigXY - (sigX * sigY)) / (count * sigXsquared - (sigX * sigX))
    intercept = (sigY - slope * sigX) / count
    slope: slope, intercept: intercept

  sliceBehind: (data, index, count) ->
    if (count - 1) > index
      data.slice(0, index + 1)
    else
      data.slice(index - count + 1, index + 1)

  dateAndCountFormatter: (d) -> 
    {x: d.date.getTime(), y: d.count}

