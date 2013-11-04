$(".coupon input[type=submit]").click(function(e) {
  $.ajax({
    url: $(".coupon").data('url'),
    data: {
      'purchase[variant]': $('#purchase_variant').val(),
      'purchase[quantity]': $('#purchase_quantity').val(),
      'coupon[code]': $('#coupon_code').val()
    },
    dataType: 'script',
    type: 'GET'
  });

  return false;
});

$('.coupon-note').click(function() {
  $(this).hide();
  $('.coupon').show();

  return false;
});

function checkUsername() {
  var element = $(this);
  var container = element.parent("li");
  if(element.val() == "") {
    if(element.prop('required')) {
      container.addClass("error");
    }
  } else {
    checkValidGithubUsername(element.val(), element);
  }
}
$("input.github_username").blur(checkUsername);

function checkValidGithubUsername(username, element) {
  var container = element.parent("li");
  var url = "https://api.github.com/users/" + username;
  var req = $.ajax({
    url : url,
      dataType : "jsonp",
      success : function(response) {
        if(response.data.message == "Not Found" || response.data.type == "Organization") {
          container.addClass("error");
        } else {
          container.removeClass("error");
        }
      }
  });
}

function updatePurchaseSubmitText(newText) {
  updatePurchaseSubmit(newText, purchaseSubmitText().amount);
}

function updatePurchaseSubmitAmount(newAmount) {
  updatePurchaseSubmit(purchaseSubmitText().text, newAmount);
}

function purchaseSubmitText() {
  var currentText = $('#purchase_submit_action input').val();
  var parts = currentText.split("—");
  return {
    text: parts[0],
    amount: parts[1]
  }
}

function updatePurchaseSubmit(text, amount) {
  $('#purchase_submit_action input').val(trim(text) + " — " + trim(amount));
}

function trim(text) {
  return text.replace(/^\s+|\s+$/g, '');
}

$('.address-info').hide();
$('.reveal-address').click(function() {
  $(this).hide();
  $('.address-info').show();

  return false;
});

function updatePurchaseAmountForQuantity() {
  var individualPrice = $('#purchase_quantity_input').data('individual-price');
  var quantity = $('#purchase_quantity').val();
  var newAmount = individualPrice * quantity;
  updatePurchaseSubmitAmount("$" + newAmount + " per month");
}

$(document).ready(function(){
  $('#purchase_payment_method_input input').change(function() {
    $("li.stripe").toggle($("#purchase_payment_method_stripe").is(":checked"));
    if($("#purchase_payment_method_stripe").is(":checked")) {
      updatePurchaseSubmitText("Submit Payment");
    } else {
      updatePurchaseSubmitText("Proceed to Checkout");
    }
  });

  $(".use_existing_card").click(function(event){
    $("#purchase_cc_input").toggle();
    $("#purchase_expiration_input").toggle();
    $("#purchase_cvc_input").toggle();
  });

  $('#purchase_quantity').change(function() {
    updatePurchaseAmountForQuantity();
  });
  if($('#purchase_quantity').length) {
    updatePurchaseAmountForQuantity();
  }
});
