# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
this.addRemark = (event) ->
  event.preventDefault()
  $(event.target).hide()
  $('#remark-well').insertBefore(event.target)
  initRemark(remarkCreated)

this.cancelRemark = (event) ->
  event.preventDefault()
  $('#confirmation-dialog').modal('hide')
  closeRemark()

remarkCreated = (event, data, status, xhr) ->
  $('#remark-well').before('<div class="well well-sm">' + xhr.responseJSON.remark + '</div>')
  $('#flash').html('<div class="alert alert-success"><strong>Success!&nbsp;</strong>You have added a new remark</div>')
  closeRemark()

remarkError = (event, xhr, status, error) ->
  $('#remark-error').removeClass('hide').html('<ul><li>' + (if xhr.status == 422 then xhr.responseJSON.join('</li><li>') else error) + '</li></ul>')
  $('#remark-well').one('ajax:error', remarkError)

initRemark = (successSaveHandler) ->
  $('#flash').html('')
  $('#new-answer').hide()
  $("#answers .answer-buttons .btn").addClass('disabled')
  remarkWell = $('#remark-well')
  remarkWell.removeClass('hide')
  $('#remark-textarea').val('').wysihtml5().focus()
  $('#remark-error').addClass('hide')
  remarkWell.find('form').attr('action', remarkWell.parent().data('action'))
  .one('ajax:success', successSaveHandler)
  .one('ajax:error', remarkError)


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
  $('#new-answer').show()
