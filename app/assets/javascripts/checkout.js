$(".coupon input[type=submit]").click(function(e) {
  $.ajax({
    url: $(".coupon").data('url'),
    data: {
      'checkout[quantity]': $('#checkout_quantity').val(),
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
$("input#checkout_github_username").blur(checkUsername);

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

function updateCheckoutSubmitText(newText) {
  updateCheckoutSubmit(newText, checkoutSubmitText().amount);
}

function updateCheckoutSubmitAmount(newAmount) {
  updateCheckoutSubmit(checkoutSubmitText().text, newAmount);
}

function checkoutSubmitText() {
  var currentText = $('#checkout_submit_action input').val();
  var parts = currentText.split("—");
  return {
    text: parts[0],
    amount: parts[1]
  }
}

function updateCheckoutSubmit(text, amount) {
  $('#checkout_submit_action input').val(trim(text) + " — " + trim(amount));
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

function updateCheckoutAmountForQuantity() {
  var individualPrice = $('#checkout_quantity_input').data('individual-price');
  var quantity = $('#checkout_quantity').val();
  var newAmount = individualPrice * quantity;
  updateCheckoutSubmitAmount("$" + newAmount + " per month");
}

$(document).ready(function(){
  $(".use_existing_card").click(function(event){
    $("#checkout_cc_input").toggle();
    $("#checkout_expiration_input").toggle();
    $("#checkout_cvc_input").toggle();
  });

  $('#checkout_quantity').change(function() {
    updateCheckoutAmountForQuantity();
  });
  if($('#checkout_quantity').length) {
    updateCheckoutAmountForQuantity();
  }
});
