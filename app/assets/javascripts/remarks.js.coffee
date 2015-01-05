# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
this.addRemark = (event) ->
  event.preventDefault()
  $(event.target).hide()
  initRemark(event.target, $(event.target), 'POST', remarkCreated)

this.editRemark = (event) ->
  event.preventDefault()
  initRemark(event.target, $(event.target).parent('.well'), 'PATCH', remarkUpdated)

this.cancelRemark = (event) ->
  event.preventDefault()
  $('#confirmation-dialog').modal('hide')
  closeRemark()

remarkCreated = (event, data, status, xhr) ->
  $('#remark-well').before("<div class=\"well well-sm\"><a class=\"btn btn-default edit-remark\" data-action=\"/remarks/#{xhr.responseJSON.id}\" href=\"\">Edit</a><a class=\"btn btn-default delete-remark\" data-confirm=\"true\" data-error=\"remarkDeleteError\" data-method=\"DELETE\" data-remote=\"true\" data-success=\"remarkDeleteSuccess\" href=\"/remarks/#{xhr.responseJSON.id}\">Delete</a><br><br><div class=\"remark-content\">#{xhr.responseJSON.remark}</div></div>")
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
  console.log xhr

flashMessage = (message, type) ->
  switch type
    when 'success' then "<div class=\"alert alert-success\"><strong>Success!&nbsp;</strong>#{message}</div>"
    when 'error'   then "<div class=\"alert alert-danger\"><strong>Alert!&nbsp;</strong>#{message}</div>"
    else message

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
  elem.find('.wysihtml5-toolbar').remove()
  elem.find('iframe').remove()
  elem.find('input[name="_wysihtml5_mode"]').remove()
  elem.find('textarea').val('').show()
  elem.next().show()
  elem.addClass('hide').prependTo(document.body)
  $("#answers .answer-buttons .btn").removeClass('disabled')
  $(".edit-remark,.delete-remark").removeClass('disabled')
  $('#new-answer').show()
