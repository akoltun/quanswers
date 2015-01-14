# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
this.addRemark = (event) ->
  event.preventDefault()
  $(event.target).hide()
  initRemark(event.target, $(event.target), 'POST', remarkCreated)

this.editRemark = (event) ->
  event.preventDefault()
  $(event.target).parents('.remarks').find('.add-remark').hide()
  initRemark(event.target, $(event.target).parents('.well'), 'PATCH', remarkUpdated)

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

remarkCreated = (event, data, status, xhr) ->
  renderRemark(xhr.responseJSON)
  $('#remark-well').prev().find('.edit-remark').click(editRemark)
  $('#flash').html(flashMessage("You have added a new remark", 'success'))
  closeRemark()

remarkUpdated = (event, data, status, xhr) ->
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

initRemark = (initiator, elem, method, successSaveHandler) ->
  $('#remark-well').insertBefore(elem)
  elem.hide()
  $('#flash').html('')
  $('#new-answer').hide()
  $("#answers .answer-buttons .btn").addClass('disabled')
  $(".edit-remark,.delete-remark").addClass('disabled')
  content = elem.find('.remark-content')?.html()
  $('#remark-textarea').val(content || '').wysihtml5().focus()
  $('#remark-error').addClass('hide')
  $('#remark-well').removeClass('hide').find('form')
  .attr('action', $(initiator).data('action'))
  .attr('method', method)
  .one('ajax:success', successSaveHandler)

closeRemark = () ->
  $('#remark-error').addClass('hide').html('')
  elem = $('#remark-well')
  elem.next().show()
  elem.parents('.remarks').find('.add-remark').show()
  elem.find('div.form-group').html('<div class="form-group"><label class="sr-only control-label" for="remark-textarea">Remark</label><textarea class="form-control" cols="100" id="remark-textarea" name="remark[remark]" rows="15"></textarea></div>')
  elem.addClass('hide').prependTo(document.body)
  $("#answers .answer-buttons .btn").removeClass('disabled')
  $(".edit-remark,.delete-remark").removeClass('disabled')
  $('#new-answer').show()

renderRemark = (remark) ->
  return if $("#remark-#{remark.id}").length

  btnTemplate = if remark.user_id == getUserId() then "<a class=\"btn btn-default edit-remark\" data-action=\"/remarks/#{remark.id}\" href=\"\">Edit</a><a class=\"btn btn-default delete-remark\" data-confirm=\"true\" data-error=\"remarkDeleteError\" data-method=\"DELETE\" data-remote=\"true\" data-success=\"remarkDeleteSuccess\" href=\"/remarks/#{remark.id}\">Delete</a><br><br>" else ""
  remarkTemplate = "<div class=\"well well-sm\" id=\"remark-#{remark.id}\">#{btnTemplate}<div class=\"remark-content\">#{remark.remark}</div></div>"

  remarksElem = if 'Question' == remark.remarkable_type then $("#question-remarks") else $("#answer-#{remark.remarkable_id} .remarks")

  if getUserId()
    remarksElem.find('.add-remark').before(remarkTemplate)
  else
    remarksElem.append(remarkTemplate)

  $("#remark-#{remark.id}").find('.edit-remark').click(editRemark)
