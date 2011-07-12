jQuery ->
  # auto-sizing textareas
  $('textarea').elastic()

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

  # AutoSuggest
  $('.multi_add input').autoSuggest(
    '/' + $('.multi_add').data('target'),
    asHtmlID: $('.multi_add').data('target')
    startText: $('.multi_add').data('start_text')
    selectionLimit: ($('.multi_add').data('selection_limit') || false)
    limitText: window.label.no_more_selections_allowed
    selectedValuesProp: 'id'
    selectedItemProp: 'name'
    searchObjProps: 'name'
    preFill: $('.multi_add input').data('source')
  )
  $('.multi_add').parents('form').submit(->
    $('.multi_add input').attr('value', $('input#as-values-' + $('.multi_add').data('target')).attr('value')[1..-2])
  )

  # read only forms
  $('.read_only form :input:not([type=submit])').attr('disabled', 'disabled')
