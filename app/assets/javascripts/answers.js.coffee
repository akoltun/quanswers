# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

this.editAnswerClicked = (event) ->
  event.preventDefault()
  $('#flash').html('')
  answerSelector = "#answer-#{$(this).data('answer-id')}"
  $("#{answerSelector} .answer-itself").hide()
  $("#{answerSelector} .answer-form").show()
  $('#new-answer').hide()