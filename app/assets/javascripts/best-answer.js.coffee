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