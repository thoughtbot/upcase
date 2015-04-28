class @WistiaHelper
  embedVideos: ->
    videos = $('.wistia-video[data-wistia-id]')
    for video in videos
      @_embedVideo(video)

  embedThumbnails: ->
    thumbnails = $('.wistia-thumbnail[data-wistia-id]')
    for thumbnail in thumbnails
      @_insertThumbnailUrl(thumbnail)

  embedSummaries: ->
    summaries = $(".wistia-summary[data-wistia-id]")
    for summary in summaries
      @_insertSummary(summary)

  _embedVideo: (video) ->
    hashedId = $(video).data('wistia-id')
    $(video).prop("id", "wistia_#{hashedId}")
    window.wistiaEmbed = Wistia.embed hashedId,
      controlsVisibleOnLoad: true
      videoFoam: true
    wistiaEmbed.bind "play", ->
      unless wistiaEmbed.started
        $.post "/api/v1/videos/#{hashedId}/status",
          state: "In Progress"
        wistiaEmbed.started = true
    wistiaEmbed.bind "secondchange", (second) =>
      wistiaEmbed.watchedThreshold ||= Math.floor(wistiaEmbed.duration() * 0.8)

      if second > wistiaEmbed.watchedThreshold && !wistiaEmbed.watched
        wistiaEmbed.watched = true
        @_markComplete(hashedId).done ->
          progressBar = $(".trails-progress")
          trail = progressBar.data("trail")
          $.get("/trails/#{trail}/progress_bar").done (progressBar) ->
            progressBar.html(progressBar)

  _markComplete: (wistiaId) ->
    $.post("/api/v1/videos/#{wistiaId}/status", state: "Complete")


  _insertThumbnailUrl: (thumbnail) ->
    $thumbnail = $(thumbnail)
    width = $thumbnail.attr('width')
    height = $thumbnail.attr('height')
    params = "?width=#{width}&height=#{height}"
    self = @
    $.getJSON(@_encodedUrl($thumbnail, params), (data) ->
      $thumbnail.attr('src', data.thumbnail_url)
    )

  _insertSummary: (summary) ->
    $summary = $(summary)
    $.getJSON(@_encodedUrl($summary, ""), (data) =>
      minutes = @_convertSecondsToMinutes(data.duration)
      $summary.find('em').text("#{minutes} minutes")
    )


  _encodedUrl: ($elem, params) ->
    hashedId = $elem.data('wistia-id')
    baseUrl = WistiaHelper.host + "/oembed.json?url="
    mediaUrl = WistiaHelper.host + "/medias/#{hashedId}"
    encodedUrl = encodeURIComponent(mediaUrl + params)
    baseUrl + encodedUrl

  _convertSecondsToMinutes: (seconds) ->
    Math.floor(seconds/60)

$ ->
  wistia = new WistiaHelper
  if $('.wistia-video').length
    wistia.embedVideos()
  if $('.wistia-thumbnail').length
    wistia.embedThumbnails()
  if $(".wistia-summary").length
    wistia.embedSummaries()
