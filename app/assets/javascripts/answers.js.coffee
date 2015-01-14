# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

this.editAnswer = (event) ->
  event.preventDefault()
  $('#flash').html('')
  prepareAnswerForm($(this).parents('.answer'))

this.cancelAnswer = (event) ->
  event.preventDefault()
  $('#confirmation-dialog').modal('hide')
  unprepareAnswerForm()

this.answerSaved = (event, data, status, xhr) ->
  answer = xhr.responseJSON
  if $("#answer-#{answer.id}").length
    unprepareAnswerForm()
    renderExistingAnswer(answer)
    $('#flash').html(flashMessage("You have updated the answer", 'success'))
  else
    $('#answer-error').addClass('hide')
    renderNewAnswer(answer)
    $('#flash').html(flashMessage("You have created a new answer", 'success'))
    $('#answer_answer').data("wysihtml5").editor.setValue('')

this.answerSaveError = (event, xhr, status, error) ->
  $('#flash').html('')
  $('#answer-error').removeClass('hide').html if xhr.status != 422
    flashMessage(error.message, 'error')
  else
    "<ul><li>#{xhr.responseJSON.join('</li><li>')}</li></ul>"

this.answerDeleteSuccess = (event, data, status, xhr) ->
  $("#answer-#{xhr.responseJSON.id}").remove()
  $('#flash').html(flashMessage("You have deleted the answer", 'success'))

this.answerDeleteError = (event, xhr, status, error) ->
  $('#flash').html(flashMessage(error, 'error'))

prepareAnswerForm = (answerElem) ->
  $("#question .btn,#answers .btn").addClass('disabled')
  answerForm = $('#answer-form')
  answerForm.insertBefore(answerElem)
  answerForm.find('div.form-group').replaceWith(HandlebarsTemplates['answers/textarea']())
  $('#answer_answer').val(answerElem.find('.answer-content').html()).removeClass('wysihtml5').wysihtml5();
  answerForm.attr('action', "/answers/#{answerElem.attr('id').slice(7)}")
  answerForm.find('div:first').append('<input name="_method" type="hidden" value="patch">')
  answerElem.hide()

unprepareAnswerForm = () ->
  $('#flash').html('')
  $('#answer-error').addClass('hide')
  answerForm = $('#answer-form')
  answerForm.next().show()
  answerForm.find('div:first input[value=patch]').remove()
  answerForm.attr('action', "/questions/#{$('#question').data('question-id')}/answers")
  $('#new-answer').append(answerForm)
  answerForm.find('div.form-group').replaceWith(HandlebarsTemplates['answers/textarea']())
  $('#answer_answer').val('').removeClass('wysihtml5').wysihtml5();
  $("#question .btn,#answers .btn").removeClass('disabled')

renderNewAnswer = (answer) ->
  return if $("#answer-#{answer.id}").length

  template = $ HandlebarsTemplates['answers/show']
    thisUserQuestion: getUserId() == getQuestionUserId()
    thisUserAnswer: getUserId() == answer.user_id
    answer: answer

  $('#answers').prepend(template)
  template.find('.edit-answer-button').click(editAnswer);
  template.find('.add-remark').click(addRemark);

renderExistingAnswer = (answer) ->
  $("#answer-#{answer.id} .answer-content").html(answer.answer)