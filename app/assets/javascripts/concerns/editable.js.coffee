jQuery ->

  flip_cancel_label = (parent) ->
    $('a', parent).text(window.label.cancel)
    $(parent).addClass('closable')

  add_action = (parent) ->
    target_link = $('a', parent).attr('href')

    if $(parent).next().hasClass('inline_edit')
      $(parent).next().hide().slideDown(->
        flip_cancel_label(parent)
      )
    else
      $(parent).after('<div class="inline_edit"></div>')

      $.get(target_link, (partial) ->
        $(parent).next().hide().html(partial).slideDown(->
          flip_cancel_label(parent)
        )
      )

  edit_action = (edit_target, parent) ->
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

  $('.editable a').click((e) ->
    parent = $(@).parent()
    unless parent.hasClass('closable')
      add_element = parent.data('add_element')
      edit_target = parent.data('edit_target')

      add_action(parent)               and e.preventDefault() if add_element
      edit_action(edit_target, parent) and e.preventDefault() if edit_target
  )

  $('.closable a').live('click', (e) ->
    parent      = $(@).parent()
    edit_target = parent.data('edit_target') or $(parent).next().parent()

    $('.inline_edit', edit_target).slideUp(->
      text_label = if parent.data('edit_target') then window.label.edit else window.label.add
      $('.cached', parent.data('edit_target')).slideDown()
      $('a', parent).text(text_label)
      $(parent).removeClass('closable')
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
