$(".coupon input[type=submit]").click(function(e) {
  $.ajax({
    url: $(".coupon").data('url'),
    data: {
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
    container.toggleClass("error", !isValidGithubUsername(element.val()));
  }
}
$("input.github_username").blur(checkUsername);

function isValidGithubUsername(username) {
  var url = "https://api.github.com/users/" + username;
  var req = $.ajax({
    url : url,
      dataType : "jsonp",
      success : function(response) {
        if(response.data.message == "Not Found" || response.data.type == "Organization") {
          return false;
        } else {
          return true;
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

$(document).ready(function(){
  $('#new_purchase').submit(function(){
    var email = $('#purchase_email').val();
    _kmq.push(['identify', email]);
  });
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
});

