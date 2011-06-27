jQuery ->
  $('input#investors').autoSuggest(
    '/investors',
    asHtmlID: 'investors'
    selectedValuesProp: 'id'
    selectedItemProp: 'name'
    searchObjProps: 'name'
    preFill: $('input#investors').data('investors')
  )
  $('form.proposal').submit(->
    $('input#investors').attr('value', $('input#as-values-investors').attr('value')[1..-2])
  )
