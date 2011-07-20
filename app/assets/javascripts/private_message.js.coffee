jQuery ->
  $('#contact_founder').hide()
  $('input[rel=contact_founder]').click((e) ->
    $('#contact_founder').slideDown()
    e.preventDefault()
  )