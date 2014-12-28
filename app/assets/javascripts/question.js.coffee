# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
this.cancelEditQuestionDialogYesClicked = (event) ->
  event.preventDefault()
  $.getScript($(this).attr("href"))
  $(document.body).removeClass('modal-open')
  return false

this.editQuestionClicked = (event) ->
  event.preventDefault()
  $('#flash').html('')
  $('#question-itself').hide()
  $('#question-form').show()
  $('#new-answer').hide()

$ ->
  $('#editQuestionButton').click editQuestionClicked
  $('#cancelEditQuestionDialog .yes-button[data-ajax=true]').click cancelEditQuestionDialogYesClicked