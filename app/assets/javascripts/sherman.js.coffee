$ ->

  $("#billing_doc_contact_attributes_name").keyup (e) ->
    name = $("#billing_doc_contact_attributes_name").val()
    path = $('form').attr('action')
    $.post path, {"name": name}, (data) ->
      $("#contact-addition").toggleClass('hide')
      $("#contact-addition").empty().append(data).show()
      $("#add-contact-to-field").click (e) ->
        e.preventDefault()
        name = $("#add-contact-to-field").data("name")
        email = $("#add-contact-to-field").data("email")
        $('#contact-addition').fadeOut('slow').empty()
        $("#billing_doc_contact_attributes_name").empty().val("#{name}")
        $("#billing_doc_contact_attributes_email").empty().val("#{email}")

  $('body').on 'keyup ', ".quantity-field, .price-field", (e) ->
    e.preventDefault()
    if $(this).hasClass('quantity-field') == true
      quantity = parseInt($(this).val())
      price = parseInt($(this).parent().next().children().first().val())
      total = quantity * price
      if total % 1 == 0
        input = $(this).parent().next().next().children().first()
        $(input).empty().val(total).prop('disabled', true)
        sumTotal = 0
        $(".total-field").each (index, element) =>
          sumTotal += parseInt($(element).val())
          console.log(sumTotal)
        $("#sum").empty().append("<h3>Total : $#{sumTotal}</h3>")
    else
      price = parseInt($(this).val())
      quantity = parseInt($(this).parent().prev().children().first().val())
      total = quantity * price
      if total % 1 == 0
        input = $(this).parent().next().children().first()
        $(input).empty().val(total).prop('disabled', true)
        sumTotal = 0
        $(".total-field").each (index, element) =>
          console.log($(element).val())
          sumTotal += parseInt($(element).val())
        $("#sum").empty().append("<h3>Total : $#{sumTotal}</h3>")
    console.log(quantity + " " + price)

  $('.due-date-field').datepicker()

  $('.add-line-item').click (e) ->
    e.preventDefault()
    index = $('.line-item-row').size()
    lineItemRow = $('.line-item-row').first().clone()
    console.log($(lineItemRow).parent())
    $(lineItemRow).find('.note-field').attr('name', "billing_doc[line_items_attributes][#{index}][note]")
    $(lineItemRow).find('.quantity-field').attr('name', "billing_doc[line_items_attributes][#{index}][quantity]").val("")
    $(lineItemRow).find('.price-field').attr('name', "billing_doc[line_items_attributes][#{index}][price]").val("")
    $(lineItemRow).find("#total").val("")
    console.log($(lineItemRow))
    $("#line-items-table tbody").append($(lineItemRow))


  $('body').on 'click',  '.remove-line-item', (e) ->
    e.preventDefault()
    if $('.line-item-row').size() > 1
      console.log('remove')
      total = parseInt($("#sum h3").text().replace( /^\D+/g, ''))
      itemVal = parseInt($(this).parent().prev().children().val())
      console.log(total - itemVal)
      $(this).parent().parent().remove()
      $("#sum h3").empty().append("<h3>Total : $#{total-itemVal}</h3>")


