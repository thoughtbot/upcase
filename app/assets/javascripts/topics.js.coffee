if $(".trail-category").length
  $ ->
    completionView = new CompletionView
    completionView.fetchCompletions(completionView.renderBullets)

if $(".topics-show").length
  $ ->
    completionView = new CompletionView
    completionView.fetchCompletions(completionView.renderCompletionsAndBullets)

class CompletionView
  fetchCompletions: (callback) ->
    window.completions = []
    $.ajax "/api/v1/completions", 
      success: (data) ->
        window.loggedIn = true
        window.completions = data.completions
        callback()
      statusCode:
        401: ->
          window.loggedIn = false
          window.completions = []
          callback()

  renderBullets: =>
    for step in $(".steps-complete")
      step = $(step)
      complete = @calculateScatterAndMarkComplete(step)
      @writeCompletionText(step, complete)

    @scatterIncompleteBullets()

  renderBulletsList: =>
    for list in $(".trail-map-steps")
      @markListItemsComplete($(list))

  markListItemsComplete: (list) ->
    for checkbox in list.find("input[type=checkbox]")
      checkbox = $(checkbox)
      if checkbox.is(':checked')
        checkbox.parents('li').addClass 'complete'

  calculateScatterAndMarkComplete: (step) ->
    complete = 0
    total = step.data("total")
    for bullet in step.find(".trail-bullet")
      bullet = $(bullet)
      percentage = bullet.index() / total * 100
      bullet.css "left", percentage + "%"
      if $.inArray(bullet.data("id"), window.completions) > -1
        bullet.addClass "complete"
        complete++
      else
        bullet.removeClass "complete"

    step.data "complete", complete
    complete

  writeCompletionText: (step, complete) ->
    total = step.data("total")
    step.find(".text-complete").text complete + "/" + total + " complete"

  scatterIncompleteBullets: ->
    $(".trail-bullet:not(.complete)").each (index, bullet) ->
      bullet = $(bullet)
      complete = bullet.parents(".steps-complete").data("complete")
      total = bullet.parents(".steps-complete").data("total")
      max = 88
      tempered_max = max - ((complete / total) * max)
      height_percentage = Math.floor(Math.random() * tempered_max) + 1
      pos_or_neg = Math.random() * 2 | 0 or -1
      height_from_center = 50 + pos_or_neg * (height_percentage / 2)
      bullet.css "top", height_from_center + "%"

  renderCompletionsAndBullets: =>
    @renderBullets()
    @initializeCompletionEditor()
    @renderBulletsList()

  initializeCompletionEditor: =>
    for completion in window.completions
      $("#" + completion).prop "checked", true
    $(".trail-map-steps .trail-bullet-hit-area").on "click", ->
      $(@).siblings('input[type=checkbox]').trigger('click')
      if $(@).siblings('input[type=checkbox]:checked').length
        $(@).parents('li').addClass 'complete'
      else
        $(@).parents('li').removeClass 'complete'
    $("input[type=checkbox]").on "change", ->
      checkbox = $(@)
      if window.loggedIn
        if checkbox.prop("checked")
          $.post "/api/v1/completions",
            trail_object_id: checkbox.attr("id")
            trail_name: checkbox.parents(".trail-map-steps").data("name")
          .done ->
            completionView = new CompletionView
            completionView.fetchCompletions(completionView.renderBullets)
        else
          $.ajax
            url: "/api/v1/completions/" + checkbox.attr("id")
            type: "DELETE"
          .done ->
            completionView = new CompletionView
            completionView.fetchCompletions(completionView.renderBullets)
