this.setBestAnswerSuccess = (event, data, status, xhr) ->
  $('.best-answer-button').show().prev().hide()
  $(event.target).hide().prev().show()

this.setBestAnswerError = (event, xhr, status, error) ->
  $('#flash').html(flashMessage(error, 'error'))
  console.log xhr