class @Wistia
  embedVideos: ->
    videos = $('.wistia-video[data-wistia-id]')
    for video in videos
      @_embedIframe(video)

  embedThumbnails: ->
    thumbnails = $('.wistia-thumbnail[data-wistia-id]')
    for thumbnail in thumbnails
      @_insertThumbnailUrl(thumbnail)

  _embedIframe: (video) ->
    $video = $(video)
    width = $video.data('width')
    height = $video.data('height')
    params = "?videoWidth=#{width}&videoHeight=#{height}&controlsVisibleOnLoad=true"
    $.getJSON(@_encodedUrl($video, params), (data) ->
      $video.html(data.html)
    )

  _insertThumbnailUrl: (thumbnail) ->
    $thumbnail = $(thumbnail)
    width = $thumbnail.attr('width')
    height = $thumbnail.attr('height')
    params = "?width=#{width}&height=#{height}"
    self = @
    $.getJSON(@_encodedUrl($thumbnail, params), (data) ->
      $thumbnail.attr('src', data.thumbnail_url)
      minutes = self._convertSecondsToMinutes(data.duration)
      $thumbnail.next().find('em').text("#{minutes} minutes")
    )

  _encodedUrl: ($elem, params) ->
    hashedId = $elem.data('wistia-id')
    baseUrl = Wistia.host + "/oembed.json?url="
    mediaUrl = "http://thoughtbotlearn.wistia.com/medias/#{hashedId}"
    encodedUrl = encodeURIComponent(mediaUrl + params)
    baseUrl + encodedUrl

  _convertSecondsToMinutes: (seconds) ->
    Math.floor(seconds/60)

$ ->
  wistia = new Wistia
  if $('.wistia-video').length
    wistia.embedVideos()
  if $('.wistia-thumbnail').length
    wistia.embedThumbnails()
