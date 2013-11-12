$ ->
  $.ajaxSetup beforeSend: (xhr) ->
    xhr.setRequestHeader "Accept", "text/javascript"

  gModal = $('#gmodal')

  $('a[data-gmodal=true]').click (e) ->
    e.preventDefault()
    triggerModal($(this).prop('href'), $(this).prop('title'))

  openModal = (title, content) ->
    dialog = gModal.children('.modal-dialog').children('.modal-content')
    dialog.children('.modal-body').html(content)
    dialog.children('.modal-header').children('.modal-title').text(title)
    gModal.modal('show')

  triggerModal = (path, title) ->
    $.get path, (data)  ->
      openModal(title, data)