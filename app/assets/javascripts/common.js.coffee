this.initWidgets = () ->
  $('.wysihtml5').removeClass('wysihtml5').wysihtml5();
  $('#remark-well').on('ajax:error', remarkError)
  $('#edit-question-button').click(editQuestionClicked);
  $('#edit-question-button').click(editQuestionClicked);
  $('.edit-answer-button').click(editAnswerClicked);
  $('.add-remark').click(addRemark);
  $('.edit-remark').click(editRemark);

$ ->
  initWidgets()

  $(document).on 'confirm', (e) ->
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