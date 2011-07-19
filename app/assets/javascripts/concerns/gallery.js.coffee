jQuery ->
  $('#slideshow').livequery(->
    $(@).slideshow(
      pauseSeconds: 5
      width: window.settings.group.logo.full.width
      height: window.settings.group.logo.full.height
      caption: false
    )

    $('> a', @).fancybox()
  )
