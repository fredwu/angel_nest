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

  # multistage form
  $('ul.multistage_selector li a').click((e) ->
    $('fieldset', 'form.multistage').hide()
    $('fieldset' + $(@).attr('href'), 'form.multistage').fadeIn()
    e.preventDefault()
  )
  $('form.multistage fieldset:first').show()
  $('form .grouped_buttons input.navigation').click((e) ->
    parent = $(@).parent().parent()
    parent.hide()

    if $(@).hasClass('prev')
      parent.prev().fadeIn()
    else if $(@).hasClass('next')
      parent.next().fadeIn()

    e.preventDefault()
  )