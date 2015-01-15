# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
this.addRemark = (event) ->
  event.preventDefault()
  $(event.target).hide()
  initRemark(event.target, $(event.target), 'POST')

this.editRemark = (event) ->
  event.preventDefault()
  $(event.target).parents('.remarks').find('.add-remark').hide()
  initRemark(event.target, $(event.target).parents('.well'), 'PATCH')

this.cancelRemark = (event) ->
  event.preventDefault()
  $('#confirmation-dialog').modal('hide')
  closeRemark()

this.remarkAdded = (remark) ->
  renderRemark(remark)

this.remarkEdited = (remark) ->
  $("#remark-#{remark.id}").show().find(".remark-content").html(remark.remark)

this.remarkDeleted = (remark) ->
  $("#remark-#{remark.id}").remove()

this.remarkSaved = (event, data, status, xhr) ->
  if 201 == xhr.status
    renderRemark(xhr.responseJSON)
    $('#flash').html(flashMessage("You have added a new remark", 'success'))
  else
    $('#remark-well').next().find('.remark-content').html(xhr.responseJSON.remark)
    $('#flash').html(flashMessage("You have updated the remark", 'success'))
  closeRemark()

this.remarkError = (event, xhr, status, error) ->
  $('#remark-error').removeClass('hide').html if xhr.status != 422
    flashMessage(error.message, 'error')
  else
    "<ul><li>#{xhr.responseJSON.join('</li><li>')}</li></ul>"

this.remarkDeleteSuccess = (event, data, status, xhr) ->
  event.data.parent('.well').remove()
  $('#flash').html(flashMessage("You have deleted the remark", 'success'))

this.remarkDeleteError = (event, xhr, status, error) ->
  $('#flash').html(flashMessage(error.message, 'error'))

initRemark = (initiator, elem, method) ->
  $("#question .btn,#answers .btn").addClass('disabled')
  $('#remark-well').insertBefore(elem)
  elem.hide()
  $('#flash').html('')
  $('#new-answer').hide()
  content = elem.find('.remark-content')?.html()
  $('#remark-textarea').val(content || '').wysihtml5().focus()
  $('#remark-error').addClass('hide')
  $('#remark-well').removeClass('hide').find('form')
  .attr('action', $(initiator).data('action'))
  .attr('method', method)

closeRemark = () ->
  $('#remark-error').addClass('hide').html('')
  elem = $('#remark-well')
  elem.next().show()
  elem.parents('.remarks').find('.add-remark').show()
  elem.find('div.form-group').html(HandlebarsTemplates['remarks/textarea'])
  elem.addClass('hide').prependTo(document.body)
  $('#new-answer').show()
  $("#question .btn,#answers .btn").removeClass('disabled')

renderRemark = (remark) ->
  return if $("#remark-#{remark.id}").length

  template = $ HandlebarsTemplates['remarks/show']
    thisUserRemark: getUserId() == remark.user_id
    remark: remark

  remarksElem = if 'Question' == remark.remarkable_type then $("#question-remarks") else $("#answer-#{remark.remarkable_id} .remarks")

  if getUserId()
    remarksElem.find('.add-remark').before(template)
  else
    remarksElem.append(template)

  $("#remark-#{remark.id}").find('.edit-remark').click(editRemark)
