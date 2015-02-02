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
  $('#follow-question-link').on('ajax:success', true, questionFollowingSuccess).on('ajax:error', questionFollowingError)
  $('#unfollow-question-link').on('ajax:success', false, questionFollowingSuccess).on('ajax:error', questionFollowingError)
  $('.rating-form').on('ajax:success', ratingSaved).on('ajax:error', ratingSaveError)
  $('.rating').on('rating.change', ratingChanged)

  initWidgets()
  $(document).on 'confirm', confirmEvent
  setQuestionsPubs() if $('#questions').length
  questionId = $('#question').data('question-id')
  setQuestionPubs(questionId) if questionId

setQuestionPubs = (questionId) ->
  PrivatePub.subscribe "/questions/#{questionId}", questionPubSubscription
  PrivatePub.subscribe "/signed_in/questions/#{questionId}", questionPubSubscription

setQuestionsPubs = () ->
  PrivatePub.subscribe "/questions", questionsPubSubscription
  PrivatePub.subscribe "/signed_in/questions", questionsPubSubscription

questionsPubSubscription = (data, channel)->
  questionPublished(data.action, data.question) if data.question

questionPubSubscription = (data, channel)->
  answerPublished(data.action, data.answer) if data.answer
  remarkPublished(data.action, data.remark) if data.remark

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

this.errorsList = (errors) ->
  "<ul><li>" +
  (for own key, values of errors
    for value in values
      "#{key.charAt(0).toUpperCase() + key.slice(1)} #{value}").join('</li><li>') +
  "</li></ul>"
