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

#this.questionAdded = (question) ->
#  unless $("#question-#{question.id}").length
#    $('#questions').prepend("<div id=\"question-#{question.id}\"><div class=\"title\"><hr><h4><a href=\"/questions/#{question.id}\">#{question.title}</a></h4></div><div class=\"content\">#{question.question}</div></div>")
#
#this.questionEdited = (question) ->
#  $("#question-#{question.id} .title a").html(question.title)
#  $("#question-#{question.id} div.content").html(question.question)
#
#this.questionDeleted = (question) ->
#  $("#question-#{question.id}").remove()

renderNewQuestion = (question) ->
  unless $("#question-#{question.id}").length
    $('#questions').prepend HandlebarsTemplates['questions/show']
      question: question

renderExistingQuestion = (question) ->
  $("#question-#{question.id} .title a").html(question.title)
  $("#question-#{question.id} div.content").html(question.question)
