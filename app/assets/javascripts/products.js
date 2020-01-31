function addToCart(product_id) {
  document.getElementById("final_cart").style.display = "none";
  var quantity = $(".product-quantity input#qt-"+ product_id).val();
  document.getElementById("btn-" + product_id).disabled = true;
  
  $.ajax({
    type: "POST",
    url: "http://localhost:3000/products/cart",
    data: JSON.stringify({product: {'id': product_id, 'quantity': quantity}}),
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function(response) {
      // alert('Item successfully added to your cart');
      $('#flash').delay(500).fadeIn('normal', function() {
        $(this).delay(2500).fadeOut();
      });
      document.getElementById("btn-" + product_id).disabled = false;
    }
  });
}

function paymentDetails() {
  var fadeTime = 300;
  var subtotal;
  var discount_price;
  var additial_discount;
  var cart_total;
  
  $.ajax({
    type: "GET",
    url: "http://localhost:3000/products/calculate",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function(response) {
      if(response.success) {
        $('#cart-subtotal').html(response['data']['cart_price']);
        $('#discount').html(response['data']['discount_price']);
        $('#additial-discount').html(response['data']['additional_discount']);
        $('#cart-total').html(response['data']['total']);
        document.getElementById("final_cart").style.display = "block";
      }
    }
  });
}

function clearCart() {
  $.ajax({
    type: "GET",
    url: "http://localhost:3000/products/cart_clear",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function(response) {
    }
  });
}

if (performance.navigation.type == 1) {
  clearCart()
}


