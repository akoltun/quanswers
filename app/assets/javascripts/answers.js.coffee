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

this.answerPublished = (action, answer) ->
  switch action
    when 'create' then renderNewAnswer answer
    when 'update' then renderExistingAnswer answer
    when 'destroy' then $("#answer-#{answer.id}").remove()
    when 'set_as_best' then setBestAnswer answer.id

this.answerAdded = (answer) ->
  renderNewAnswer answer

this.answerEdited = (answer) ->
  renderExistingAnswer answer

this.answerDeleted = (answer) ->
  $("#answer-#{answer.id}").remove()

this.setBestAnswerSuccess = (event, data, status, xhr) ->
  setBestAnswer xhr.responseJSON.id

this.setBestAnswerError = (event, xhr, status, error) ->
  $('#flash').html(flashMessage(error, 'error'))
  console.log xhr

this.setBestAnswer = (id) ->
  $('.best-answer-button').show()
  $('.best-answer').hide()
  $("#answer-#{id} .best-answer").show()
  $("#answer-#{id} .best-answer-button").hide()

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
  $('#answer-error').removeClass('hide').html if 422 != +xhr.status
    "<strong>Alert!&nbsp;</strong>#{error}"
  else
    errorsList(xhr.responseJSON.errors)
#    "<ul><li>#{xhr.responseJSON.errors.join('</li><li>')}</li></ul>"

this.answerDeleteSuccess = (event, data, status, xhr) ->
  $("#answer-#{xhr.responseJSON.id}").remove()
  $('#flash').html(flashMessage("You have deleted the answer", 'success'))

this.answerDeleteError = (event, xhr, status, error) ->
  $('#flash').html(flashMessage(error, 'error'))

prepareAnswerForm = (answerElem) ->
  $("#question .btn,#answers .btn").addClass('disabled')
  answerForm = $('#answer-form')
  answerForm.insertBefore(answerElem)
  answerForm.find('div.form-group:first').replaceWith(HandlebarsTemplates['answers/textarea']())
  attachments = HandlebarsTemplates['attachments/list_form']
    type: 'answer'
    attachments: $.map answerElem.find('.attachments a'), (elem, index) ->
      id: $(elem).data('id')
      link: $(elem).prop('outerHTML')
  answerForm.find('div.form-group:last').html(attachments)
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
  $('#answer-attachment-form-new').html('')
  $('#new-answer').append(answerForm)
  answerForm.find('div.form-group:first').replaceWith(HandlebarsTemplates['answers/textarea']())
  $('#answer_answer').val('').removeClass('wysihtml5').wysihtml5();
  $("#question .btn,#answers .btn").removeClass('disabled')

renderNewAnswer = (answer) ->
  return if $("#answer-#{answer.id}").length

  addAttachmentsNames(answer.attachments ||= [])
  template = $ HandlebarsTemplates['answers/show']
    thisUserQuestion: getUserId() == getQuestionUserId()
    thisUserAnswer: getUserId() == answer.user_id
    answer: answer

  $('#answers').prepend(template)
  template.find('.edit-answer-button').click(editAnswer);
  template.find('.add-remark').click(addRemark);
  template.find('.best-answer-button').on('ajax:success', setBestAnswerSuccess).on('ajax:error', setBestAnswerError)


renderExistingAnswer = (answer) ->
  $("#answer-#{answer.id} .answer-content").html(answer.answer)
  $("#answer-#{answer.id} .meta-info .updated_at").html(answer.updated_at)
  addAttachmentsNames(answer.attachments ||= [])
  $("#answer-#{answer.id} .attachments").html HandlebarsTemplates['attachments/index']
    attachments: answer.attachments

addAttachmentsNames = (attachments) ->
  attachments.forEach (attachment) ->
    attachment.file.name = attachment.file.url.slice(attachment.file.url.lastIndexOf('/') + 1)
