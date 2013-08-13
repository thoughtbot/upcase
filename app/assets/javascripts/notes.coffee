$('.add-note').on 'click', (event)->
  $('.add-note-form').slideToggle 250, ->
    $(this).find('textarea').focus()
  event.preventDefault()

