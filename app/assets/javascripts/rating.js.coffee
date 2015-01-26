this.ratingSaved = (event, data, status, xhr) ->
  rating = xhr.responseJSON.rating
  $(event.target).find("input.rating").rating('update', rating).data('initial-value', rating)

this.ratingSaveError = (event, xhr, status, error) ->
  ratingElem = $(event.target).find("input.rating")
  ratingElem.rating('update', ratingElem.data('initial-value'))
  $('#flash').html(flashMessage(error, 'error'))
  console.log xhr

this.ratingChanged = (event, value) ->
  $(event.target).parents('form.rating-form').submit()
