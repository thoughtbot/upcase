//= require jquery
//= require jquery_ujs
//= require jquery-ui

$("#total a").click(function() {
  $(".coupon").show();
  return false;
});

$(".coupon form").submit(function(e) {
  var data = $(this).serializeArray();

  $.ajax({
    url: $(this).attr('action'),
    data: data,
    dataType: 'script',
    type: 'GET'
  });

  e.preventDefault();
  return false;
});

var slideDown = function(pos){
  $('.flash_message').animate({ marginTop: 0 }).delay(3000).animate({ marginTop: -50 });
};

var slideUp = function(){
  $('.flash_message').stop().slideUp();
};

$(function(){
  // Slide down on page load
  slideDown();

  // Slide up when close button is clicked
  $('#flash_close span').click(function(){
    slideUp();
  });
});
