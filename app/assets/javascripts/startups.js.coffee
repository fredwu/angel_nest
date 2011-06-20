jQuery ->
  $('.inline_editable').hide()
  $('.profile_team .mini_profile').mouseenter(->
    $('.inline_editable', this).show()
  ).mouseleave(->
    $('.inline_editable').hide()
  )