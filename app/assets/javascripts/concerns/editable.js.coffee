jQuery ->
  $('.editable a').click((e) ->
    parent = $(@).parent()
    unless parent.hasClass('closable')
      edit_target = parent.data('edit_target')

      if edit_target
        cached_html = $(edit_target).html()
        target_link = $('a', parent).attr('href')

        $(edit_target).wrapInner('<div class="cached" />') unless $('.cached', edit_target).length > 0
        $('.cached', edit_target).after('<div class="edits"></div>') unless $('.edits', edit_target).length > 0

        $('.edits', edit_target).hide()
        $('.cached', edit_target).slideUp(->
          $.get(target_link, (partial) ->
            $('.edits', edit_target).html(partial).slideDown()
            $('a', parent).text(window.label.cancel)
            $(parent).addClass('closable')
          )
        )

        e.preventDefault()
  )

  $('.closable a').live('click', (e) ->
    parent      = $(@).parent()
    edit_target = parent.data('edit_target')

    $('.edits', edit_target).slideUp(->
      $('.cached', edit_target).slideDown()
      $('a', parent).text(window.label.edit)
      $(parent).removeClass('closable')
    )

    e.preventDefault()
  )

  $('.inline_edit').delegate('form', 'submit', ->
    edit_target = $(@).parent().parent()
    target_link = edit_target.data('render_target')

    $(@).ajaxSubmit(
      success: -> $('.edits', edit_target).slideUp(->
        $.get(target_link, (partial) ->
          $('.cached', edit_target).html(partial)
          $('.closable a').click()
        )
      )
    )

    false
  )
