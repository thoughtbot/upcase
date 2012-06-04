//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .

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
  $('input#search').domsearch('ul#topics');

  // Slide down on page load
  slideDown();

  // Slide up when close button is clicked
  $('#flash_close span').click(function(){
    slideUp();
  });
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

