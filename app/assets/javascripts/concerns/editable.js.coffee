jQuery ->
  $('.editable').click((e) ->
    unless $(@).hasClass('closable')
      self        = @
      edit_target = $(@).data('edit_target')

      if edit_target
        edit_label  = $(@).text()
        cached_html = $(edit_target).html()
        target_link = $('a', @).attr('href')

        $(edit_target).wrapInner('<div class="cached" />') unless $('.cached', edit_target).length > 0
        $('.cached', edit_target).after('<div class="edits"></div>') unless $('.edits', edit_target).length > 0

        $('.edits', edit_target).hide()
        $('.cached', edit_target).slideUp(->
          $.get(target_link, (partial) ->
            $('.edits', edit_target).html(partial).slideDown()
            $('a', self).text(window.label.cancel)
            $(self).addClass('closable')
          )
        )

        e.preventDefault()
  )

  $('.closable').live('click', (e) ->
    self        = @
    edit_target = $(@).data('edit_target')

    $('.edits', edit_target).slideUp(->
      $('.cached', edit_target).slideDown()
      $('a', self).text(window.label.edit)
      $(self).removeClass('closable')
    )

    e.preventDefault()
  )

  $('.inline_edit').delegate('form', 'submit', ->
    edit_target = $(@).parent()
    target_link = edit_target.data('render_target')

    $(@).ajaxSubmit(
      success: -> edit_target.slideUp(->
        $.get(target_link, (partial) ->
          $(edit_target).html(partial).slideDown()
        )
      )
    )

    false
  )
