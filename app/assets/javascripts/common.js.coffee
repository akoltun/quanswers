$ ->
  initWidgets()

  $(document).on 'confirm', (e) ->
    console.log 'confirm event'
    elem = $(e.target)
    confirmation = elem.data('confirm')
    return true unless confirmation

    $('#confirmation-dialog-label').text(if confirmation == true then "Are you sure?" else confirmation)
    elemYes = $('#confirmation-dialog-yes-button')
    elemYes.attr
      href: elem.attr('href') || ''
      'data-method': elem.data('method')
    if elem.data('remote')
      elemYes.attr
        'data-remote': true
        'data-dismiss': 'modal'

    $('#confirmation-dialog').modal('show')
    false

this.initWidgets = () ->
  $('.wysihtml5').removeClass('wysihtml5').wysihtml5();
  $('#edit-question-button').click(editQuestionClicked);
  $('.edit-answer-button').click(editAnswerClicked);