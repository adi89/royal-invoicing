$ ->

  # $("#billing_doc_contact_attributes_name").keyup (e) ->
  #   name = $("#billing_doc_contact_attributes_name").val()
  #   path = $('form').attr('action')
  #   $.post path, {"name": name}, (data) ->
  #     $("#contact-addition").toggleClass('hide')
  #     $("#contact-addition").empty().append(data).show()
  #     $("#add-contact-to-field").click (e) ->
  #       e.preventDefault()
  #       name = $("#add-contact-to-field").data("name")
  #       email = $("#add-contact-to-field").data("email")
  #       $('#contact-addition').fadeOut('slow').empty()
  #       $("#billing_doc_contact_attributes_name").empty().val("#{name}")
  #       $("#billing_doc_contact_attributes_email").empty().val("#{email}")

  $('body').on 'keyup ', ".quantity-field, .price-field", (e) ->
    e.preventDefault()
    if $(this).hasClass('quantity-field') == true
      quantity = parseFloat($(this).val())
      price = parseFloat($(this).parent().next().children().first().val())
      total = (quantity * price).toFixed(2)
      console.log(total)
      if isNaN(total) == false
        input = $(this).parent().next().next().children().first()
        $(input).empty().val(total).prop('disabled', true)
        sumTotal = 0
        $(".total-field").each (index, element) =>
          sumTotal += parseFloat($(element).val())
          console.log(sumTotal)
        $("#sum").empty().append("<h3>Total : $#{sumTotal.toFixed(2)}</h3>")
    else
      price = parseFloat($(this).val())
      quantity = parseFloat($(this).parent().prev().children().first().val())
      total = (quantity * price).toFixed(2)
      console.log(total)
      if isNaN(total) == false
        input = $(this).parent().next().children().first()
        $(input).empty().val(total).prop('disabled', true)
        sumTotal = 0
        $(".total-field").each (index, element) =>
          sumTotal += parseFloat($(element).val())
          console.log(sumTotal)
        $("#sum").empty().append("<h3>Total : $#{sumTotal.toFixed(2)}</h3>")
    console.log(quantity + " " + price)

  $('.due-date-field').datepicker()

  $('.add-line-item').click (e) ->
    e.preventDefault()
    index = $('.line-item-row').size()
    lineItemRow = $('.line-item-row').first().clone()
    console.log($(lineItemRow).parent())
    $(lineItemRow).find('.note-field').attr('name', "billing_doc[line_items_attributes][#{index}][note]")
    $(lineItemRow).find('.note-field').val("")
    $(lineItemRow).find('.quantity-field').attr('name', "billing_doc[line_items_attributes][#{index}][quantity]").val("")
    $(lineItemRow).find('.price-field').attr('name', "billing_doc[line_items_attributes][#{index}][price]").val("")
    $(lineItemRow).find("#total").val("")
    console.log($(lineItemRow))
    $("#line-items-table tbody").append($(lineItemRow))


  $('body').on 'click',  '.remove-line-item', (e) ->
    e.preventDefault()
    if $('.line-item-row').size() > 1
      console.log('remove')
      total = parseFloat($("#sum h3").text().replace( /^\D+/g, ''))
      itemVal = parseFloat($(this).parent().prev().children().val())
      console.log(total - itemVal)
      $(this).parent().parent().remove()
      $("#sum h3").empty().append("<h3>Total : $#{total-itemVal}</h3>")


  $('.show-mailer-button').click (e) ->
    e.preventDefault()
    $(this).text('Sent').removeClass('btn btn-default').addClass('sent-show-mailer')
    path = $(this).attr('href')
    $.get path, (data) ->
      console.log(data)

  $('.due-date-sort , .contact-sort, .total-sort, .status.sort').click (e) ->
    e.preventDefault()
    dataType = $(this).data('type')
    category = $(this).data('category')
    path = '/billing_docs/sort'
    $.post path, data:{'type':dataType, 'category':category}, (data) ->
      $(".line-item-show-row").empty()
      $("#invoices-index-table tbody").append($(data))

