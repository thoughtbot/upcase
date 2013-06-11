if $(".trail-category").length
  $ ->
    completionView = new CompletionView
    completionView.fetchCompletions(completionView.renderBullets)

if $(".topics-show").length
  $ ->
    completionView = new CompletionView
    completionView.fetchCompletions(completionView.initializeCompletionEditor)

class CompletionView
  fetchCompletions: (callback) ->
    window.completions = []
    $.ajax "/api/v1/completions", 
      success: (data) ->
        window.completions = data.completions
        callback()
      error: ->
        window.completions = []
        callback()

  renderBullets: =>
    for step in $(".steps-complete")
      step = $(step)
      complete = @calculateAndMarkComplete(step)
      @centerCompletionText(step, complete)

    @scatterIncompleteBullets()

  calculateAndMarkComplete: (step) ->
    complete = 0
    total = step.data("total")
    for bullet in step.find(".journey-bullet")
      bullet = $(bullet)
      percentage = bullet.index() / total * 100
      bullet.css "left", percentage + "%"
      if $.inArray(bullet.data("id"), window.completions) > -1
        bullet.addClass "complete"
        complete++
    step.data "complete", complete
    complete

  centerCompletionText: (step, complete) ->
    total = step.data("total")
    step.find(".text-complete").text complete + "/" + total + " complete"
    if complete / total > .75
      step.find(".text-complete").css
        left: "auto"
        right: 0
    else
      step.find(".text-complete").css "left", ((complete - 1) / total * 100) + "%"

  scatterIncompleteBullets: ->
    $(".journey-bullet:not(.complete)").each (index, bullet) ->
      bullet = $(bullet)
      complete = bullet.parents(".steps-complete").data("complete")
      total = bullet.parents(".steps-complete").data("total")
      max = 88
      tempered_max = max - ((complete / total) * max)
      height_percentage = Math.floor(Math.random() * tempered_max) + 1
      pos_or_neg = Math.random() * 2 | 0 or -1
      height_from_center = 50 + pos_or_neg * (height_percentage / 2)
      bullet.css "top", height_from_center + "%"

  initializeCompletionEditor: ->
    for completion in window.completions
      $("#" + completion).prop "checked", true
    $("input[type=checkbox]").on "change", ->
      checkbox = $(@)
      if checkbox.prop("checked")
        $.post "/api/v1/completions",
          trail_object_id: checkbox.attr("id")
          trail_name: checkbox.parents(".trail-map-steps").data("name")
      else
        $.ajax
          url: "/api/v1/completions/" + checkbox.attr("id")
          type: "DELETE"
