$(document).ready(function() {
  var fadeTime = 300;
 
 
  /* Assign actions */
  $('.product-quantity input').change( function() {
    updateQuantity(this);
  });
   
  $('.product-removal button').click( function() {
    removeItem(this);
  });
 
 
  /* Recalculate cart */
  function recalculateCart()
  {
    var subtotal = 0;
     
    /* Sum up row totals */
    $('.product').each(function () {
      subtotal += parseFloat($(this).children('.product-line-price').text());
    });
     
    /* Calculate totals */
    // var tax = subtotal * taxRate;
    // var shipping = (subtotal > 0 ? shippingRate : 0);
    additionalDiscount(subtotal);
    var total = subtotal; //+ shipping;
     
    /* Update totals display */
    $('.totals-value').fadeOut(fadeTime, function() {
      $('#cart-subtotal').html(subtotal.toFixed(2));
      // $('#additial-discount').html(discount_on_total.toFixed(2));
      // $('#cart-shipping').html(shipping.toFixed(2));
      total_after_discount = total - parseFloat($('#discount').text()) - parseFloat($('#additial-discount').text());
      $('#cart-total').html(total_after_discount.toFixed(2));
      if(total == 0){
        $('.checkout').fadeOut(fadeTime);
      }else{
        $('.checkout').fadeIn(fadeTime);
      }
      $('.totals-value').fadeIn(fadeTime);
    });
  }

  function additionalDiscount(total_price)
  {
    var product_id = document.getElementById("product_id").value
    var quantity = $('.product-quantity input').val();
    discount_text = $('.product-line-price').text();
    var previous_discount = parseFloat(discount_text.match(/[0-9]+/)[0], 10) - parseFloat($('#discount').text());
    $.ajax({
      type: "POST",
      url: "http://localhost:3000/products/cart",
      data: JSON.stringify({product: {'id': product_id, 'quantity': quantity, 'total_price': total_price}}),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function(response) {
        if(response.success == true){
          // $('#additial-discount').html(response['data']['global_discount']);
          // if(response['data']['discount'] != 0) {
          //   $('#discount').html(total_price - response['data']['discount']);
          // }
        }
        else {
          alert('Error');
        }
      }
    });
  }
 
  /* Update quantity */
  function updateQuantity(quantityInput)
  {
    /* Calculate line price */
    var productRow = $(quantityInput).parent().parent();
    var price = parseFloat(productRow.children('.product-price').text());
    var quantity = $(quantityInput).val();
    var linePrice = price * quantity;
    /* Update line price display and recalc cart totals */
    productRow.children('.product-line-price').each(function () {
      $(this).fadeOut(fadeTime, function() {
        $(this).text(linePrice.toFixed(2));
        recalculateCart();
        $(this).fadeIn(fadeTime);
      });
    });  
  }
 
  /* Remove item from cart */
  function removeItem(removeButton)
  {
    /* Remove row from DOM and recalc cart total */
    var productRow = $(removeButton).parent().parent();
    productRow.slideUp(fadeTime, function() {
      productRow.remove();
      recalculateCart();
    });
  }

});
 
