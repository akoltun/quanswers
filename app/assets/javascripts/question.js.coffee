# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


this.editQuestionClicked = (event) ->
  event.preventDefault()
  $('#flash').html('')
  $('#question-itself,#answers,#answers-title,#new-answer').hide()
  $('#question-form').show()

this.questionPublished = (action, question) ->
  switch action
    when 'create' then renderNewQuestion question
    when 'update' then renderExistingQuestion question
    when 'destroy' then $("#question-#{question.id}").remove()
    when 'rating' then $("#question-#{question.id} input.rating").rating('update', question.rating)
    when 'answers_info'
      $("#question-#{question.id} .has-best-answer").toggleClass('hide', question.no_best_answer)
      $("#question-#{question.id} .answers-count").html(question.answers_count)

renderNewQuestion = (question) ->
  unless $("#question-#{question.id}").length
    $('#questions').prepend HandlebarsTemplates['questions/show']
      question: question

renderExistingQuestion = (question) ->
  $("#question-#{question.id} .title a").html(question.title)
  $("#question-#{question.id} div.content").html(question.question)
  $("#question-#{question.id} .meta-info .updated_at").html(question.updated_at)

this.questionFollowingSuccess = (event, data, status, xhr) ->
  $("#follow-question-link").toggleClass('hide', event.data)
  $("#unfollow-question-link").toggleClass('hide', !event.data)

this.questionUnfollowedSuccess = (event, data, status, xhr) ->
  console.log data
  $("#follow-question-link").removeClass('hide')
  $("#unfollow-question-link").addClass('hide')

this.questionFollowingError = (event, xhr, status, error) ->
  $('#flash').html(flashMessage(error, 'error'))
  console.log xhr