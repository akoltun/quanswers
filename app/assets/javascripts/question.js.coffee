# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


this.editQuestionClicked = (event) ->
  event.preventDefault()
  $('#flash').html('')
  $('#question-itself').hide()
  $('#question-form').show()
  $('#answers').hide()
  $('#new-answer').hide()

this.questionAdded = (question) ->
  unless $("#question-#{question.id}").length
    $('#questions').prepend("<div id=\"question-#{question.id}\"><hr><h4><a href=\"/questions/#{question.id}\">#{question.title}</a></h4><p>#{question.question}</p></div>")

this.questionEdited = (question) ->
  $("#question-#{question.id} a").html(question.title)
  $("#question-#{question.id} p").html(question.question)

this.questionDeleted = (question) ->
  $("#question-#{question.id}").remove()