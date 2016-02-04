Template.Labels.onRendered ->

  $('input#text').focus()
  $('select[name="color"]').simplecolorpicker('selectColor', _randomColor($('select[name="color"]')))


Template.Labels.helpers

  labels: ->
    Collection.Label.find()


Template.Labels.events

  'keypress input#text': (event) ->
    if event.keyCode is 13
      $('.create-label').trigger 'click'

  'click .create-label': (event) ->
    text = $('input#text').val()
    color = $('select[name="color"]').val()
    if not text
      Materialize.toast 'please provide text', 4000, 'error'
      return
    if not color
      Materialize.toast 'please provide a color', 4000, 'error'
      return
    existingLabel = Collection.Label.findOne
      text: text
    if existingLabel
      Materialize.toast 'duplicates not allowed', 4000, 'error'
      $('input#text').focus()
      return

    newLabel = new Model.Label
      text: text
      color: color
    newLabel.save (err, id) ->
      if err
        console.log(err)
        Materialize.toast 'error saving label', 4000, 'error'
      else
        Materialize.toast 'label saved', 4000, 'success'
        $('input#text').val('')
        $('select[name="color"]').simplecolorpicker('selectColor', _randomColor($('select[name="color"]')))
        $('input#text').focus()


  'click .remove-label, mousedown .label.chip': (event) ->
    if event.type is 'mousedown'
      if event.originalEvent.button is 1
        console.log("womp")

        $(event.currentTarget).find('.remove-label').trigger 'click'
        event.stopPropagation()
        return
      else
        return


    @blogPostLabels().forEach (label) -> label.remove()
    @remove (err) ->
      if err
        event.stopPropagation()
        Materialize.toast 'error removing label', 4000, 'error'

_randomColor = (picker, exclude=[]) ->
  colors = picker.find('> option').map ->
    $(this).data("color")
  _.sample _.difference(colors.get(), exclude)
