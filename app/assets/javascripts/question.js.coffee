# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


this.editQuestionClicked = (event) ->
  event.preventDefault()
  $('#flash').html('')
  $('#question-itself').hide()
  $('#question-form').show()
  $('#answers').hide()
  $('#new-answer').hide()