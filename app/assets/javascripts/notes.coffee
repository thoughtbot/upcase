$('.add-note').on 'click', (event)->
  $('.add-note-form').slideToggle()
  event.preventDefault()

