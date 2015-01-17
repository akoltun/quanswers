this.initWidgets = () ->
  $('.wysihtml5').removeClass('wysihtml5').wysihtml5();
  $('#edit-question-button').click(editQuestionClicked);
  $('.best-answer-button').on('ajax:success', setBestAnswerSuccess).on('ajax:error', setBestAnswerError)

  $('#answer-form').on('ajax:success', answerSaved).on('ajax:error', answerSaveError)
  $('.edit-answer-button').click(editAnswer);

  $('#remark-well form').on('ajax:success', remarkSaved).on('ajax:error', remarkError)
  $('.add-remark').click(addRemark);
  $('.edit-remark').click(editRemark);


$ ->
  initWidgets()
  $(document).on 'confirm', confirmEvent
  setQuestionsPub() if $('#questions').length
  questionId = $('#question').data('question-id')
  setQuestionPub(questionId) if questionId

setQuestionPub = (questionId) ->
  PrivatePub.subscribe "/questions/#{questionId}", (data, channel) ->
    answerPublished(data.action, data.answer) if data.answer
    remarkPublished(data.action, data.remark) if data.remark

#  PrivatePub.subscribe "/questions/#{questionId}/new", (data, channel) ->
#    answerAdded($.parseJSON(data['answer'])) if data['answer']
#    remarkAdded($.parseJSON(data['remark'])) if data['remark']

#  PrivatePub.subscribe "/questions/#{questionId}/edited", (data, channel) ->
#    answerEdited($.parseJSON(data['answer'])) if data['answer']
#    setBestAnswer($.parseJSON(data['best_answer']).id) if data['best_answer']
#    remarkEdited($.parseJSON(data['remark'])) if data['remark']

#  PrivatePub.subscribe "/questions/#{questionId}/deleted", (data, channel) ->
#    answerDeleted($.parseJSON(data['answer'])) if data['answer']
#    remarkDeleted($.parseJSON(data['remark'])) if data['remark']

setQuestionsPub = () ->
  PrivatePub.subscribe "/questions", (data, channel) ->
    questionPublished(data.action, data.question) if data.question

#  PrivatePub.subscribe "/questions/new", (data, channel) ->
#    questionAdded($.parseJSON(data['question'])) if data['question']
#
#  PrivatePub.subscribe "/questions/edited", (data, channel) ->
#    questionEdited($.parseJSON(data['question'])) if data['question']
#
#  PrivatePub.subscribe "/questions/deleted", (data, channel) ->
#    questionDeleted($.parseJSON(data['question'])) if data['question']

confirmEvent = (e) ->
  elem = $(e.target)
  confirmation = elem.data('confirm')
  return true unless confirmation

  $('#confirmation-dialog-label').text(if confirmation == true then "Are you sure?" else confirmation)

  elemYes = $('#confirmation-dialog-yes-button')
  copyAttrs(elem, elemYes, 'href', 'data-method', 'data-remote', 'data-type')

  if elem.data('remote')
    elemYes.attr
      'data-remote': true
      'data-dismiss': 'modal'

  attachEvent(elem, elemYes, 'click', 'click')
  attachEvent(elem, elemYes, 'ajax:success', 'success')
  attachEvent(elem, elemYes, 'ajax:error', 'error')

  $('#confirmation-dialog').modal('show')
  false

copyAttrs = (source, target, attrs...) ->
  attrs.forEach (attr)->
    val = source.attr(attr)
    if val == undefined
      target.removeAttr(attr)
    else
      target.attr(attr, val)

attachEvent = (source, target, eventName, dataAttr) ->
  event = source.data(dataAttr)
  target.one(eventName, source, window[event]) if event && window[event]

this.flashMessage = (message, type) ->
  switch type
    when 'success' then "<div class=\"alert alert-success\"><strong>Success!&nbsp;</strong>#{message}</div>"
    when 'error'   then "<div class=\"alert alert-danger\"><strong>Alert!&nbsp;</strong>#{message}</div>"
    else message

