jQuery ->
  $('.inline_editable .editable').hide()
  $('.profile_team .mini_profile').mouseenter(->
    if $('.inline_editable .closable', @).length > 0
      $('.inline_editable .closable', @).show()
    else
      $('.inline_editable .editable', @).show()
  ).mouseleave(->
    $('.inline_editable .editable', @).not('.closable').hide()
  )

  flip_cancel_label = (parent) ->
    $('a', parent).text(window.label.cancel)
    parent.show().addClass('closable')

  add_action = (parent) ->
    target_link = $('a', parent).attr('href')

    if parent.next().hasClass('inline_edit')
      parent.next().hide().slideDown(->
        flip_cancel_label(parent)
      )
    else
      parent.after('<div class="inline_edit"></div>')

      $.get(target_link, (partial) ->
        parent.next().hide().html(partial).slideDown(->
          flip_cancel_label(parent)
        )
      )

  edit_action = (parent) ->
    edit_target = parent.data('edit_target')
    cached_html = $(edit_target).html()
    target_link = $('a', parent).attr('href')

    $(edit_target).wrapInner('<div class="cached" />') unless $('.cached', edit_target).length > 0
    $('.cached', edit_target).after('<div class="inline_edit"></div>') unless $('.inline_edit', edit_target).length > 0

    $('.inline_edit', edit_target).hide()
    $('.cached', edit_target).slideUp(->
      $.get(target_link, (partial) ->
        $('.inline_edit', edit_target).html(partial).slideDown(->
          flip_cancel_label(parent)
        )
      )
    )

  inline_action = (parent) ->
    target_link = $('a', parent).attr('href')
    edit_target = parent.parent().parent()

    parent.parent().after('<div class="inline_edit inline_popup"></div>') unless $('.inline_edit', edit_target).length > 0

    $.get(target_link, (partial) ->
      $('.inline_edit', edit_target).hide().html(partial).slideDown(->
        parent.parent().show()
        parent.siblings().hide()
      )
      flip_cancel_label(parent)
    )

  $('.editable a').click((e) ->
    parent = $(@).parent()
    unless parent.hasClass('closable')
      add_element     = parent.data('add_element')
      edit_target     = parent.data('edit_target')
      inline_editable = parent.parent().hasClass('inline_editable')

      add_action(parent)    and e.preventDefault() if add_element
      edit_action(parent)   and e.preventDefault() if edit_target
      inline_action(parent) and e.preventDefault() if inline_editable
  )

  $('.closable a').live('click', (e) ->
    parent          = $(@).parent()
    add_element     = parent.data('add_element') and parent.next().parent()
    edit_target     = parent.data('edit_target')
    inline_editable = parent.parent().hasClass('inline_editable') and parent.parent().next().parent()

    $('> .inline_edit', (add_element or edit_target or inline_editable)).slideUp(->
      if add_element
        text_label = window.label.add
      else if edit_target
        text_label = window.label.edit
        $('.cached', parent.data('edit_target')).slideDown()
      else if inline_editable
        text_label = window.label.update
        parent.hide()

      $('a', parent).text(text_label)
      parent.removeClass('closable')
    )

    e.preventDefault()
  )

  $('.inline_edit_container').delegate('form', 'submit', ->
    edit_target = $(@).parent().parent()
    target_link = edit_target.data('render_target')

    $(@).ajaxSubmit(
      success: -> $('.inline_edit', edit_target).slideUp(->
        $.get(target_link, (partial) ->
          $('.cached', edit_target).html(partial)
        ) if target_link
        $('.closable a').click()
      )
    )

    false
  )
