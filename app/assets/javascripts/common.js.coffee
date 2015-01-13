this.initWidgets = () ->
  $('.wysihtml5').removeClass('wysihtml5').wysihtml5();
  $('#remark-well').on('ajax:error', remarkError)
  $('#edit-question-button').click(editQuestionClicked);
  $('#edit-question-button').click(editQuestionClicked);
  $('.edit-answer-button').click(editAnswerClicked);
  $('.add-remark').click(addRemark);
  $('.edit-remark').click(editRemark);
  $('.best-answer-button').on('ajax:success', setBestAnswerSuccess).on('ajax:error', setBestAnswerError)

$ ->
  initWidgets()
  setQuestionsPub() if $('#questions').length
  questionId = $('#question').data('question-id')
  setQuestionPub(questionId) if questionId
  $(document).on 'confirm', confirmEvent

setQuestionPub = (questionId) ->
  PrivatePub.subscribe "/questions/#{questionId}/new", (data, channel) ->
    remarkAdded($.parseJSON(data['remark'])) if data['remark']

  PrivatePub.subscribe "/questions/#{questionId}/edited", (data, channel) ->
    remarkEdited($.parseJSON(data['remark'])) if data['remark']

  PrivatePub.subscribe "/questions/#{questionId}/deleted", (data, channel) ->
    remarkDeleted($.parseJSON(data['remark'])) if data['remark']

setQuestionsPub = () ->
  PrivatePub.subscribe "/questions/new", (data, channel) ->
    questionAdded($.parseJSON(data['question'])) if data['question']

  PrivatePub.subscribe "/questions/edited", (data, channel) ->
    questionEdited($.parseJSON(data['question'])) if data['question']

  PrivatePub.subscribe "/questions/deleted", (data, channel) ->
    questionDeleted($.parseJSON(data['question'])) if data['question']

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