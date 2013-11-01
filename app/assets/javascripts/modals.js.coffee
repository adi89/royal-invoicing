$ ->
  $.ajaxSetup beforeSend: (xhr) ->
    xhr.setRequestHeader "Accept", "text/javascript"

  # $(form).bind "ajax:success", ->
  #   $(this).data("remotipartSubmitted")

  gModal = $('#gmodal')

  $('a[data-gmodal=true]').click (e) ->
    e.preventDefault()
    console.log($(this).prop('href'))
    console.log($(this).prop('title'))
    triggerModal($(this).prop('href'), $(this).prop('title'))

  openModal = (title, content) ->
    dialog = gModal.children('.modal-dialog').children('.modal-content')
    dialog.children('.modal-body').html(content)
    dialog.children('.modal-header').children('.modal-title').text(title)
    gModal.modal('show')

  # gModal.on 'click', '.create-contact-button', (e) ->
  #   e.preventDefault()
  #   form = $('form#new_contact')
  #   console.log(form)
  #   path = form.attr('action')
  #   $.post path, form.serialize(), (data) ->
  #     $('#create').hide()
  #     $('#added-contact').html data
  #     $('#added-contact').show()

  triggerModal = (path, title) ->
    $.get path, (data)  ->
      openModal(title, data)