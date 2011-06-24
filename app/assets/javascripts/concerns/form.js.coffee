jQuery ->
  # new message submission
  $('form#new_message input[type=submit]').hide().bind('hover', ->
    $(@).parent().parent().find('textarea').unbind('blur')
  )
  $('form#new_message textarea').focus(->
    $(@).parent().parent().find('input[type=submit]').slideDown(200)
  ).blur(->
    $(@).parent().parent().find('input[type=submit]').fadeTo(500, 1).slideUp(100)
  )
