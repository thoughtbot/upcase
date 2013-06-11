//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require retina
//= require prettify/prettify
//= require jquery.jsPlumb-1.4.0-all-min
//= require waypoints.min
//= require masonry.min.js
//= require prime.js
//= require slider.js
//= require topics

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

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

$(function() {
  $('pre').addClass('prettyprint');

  if ($('.card-slider.products').length) {
    $('.toggle-slider').click(function() {
      $(this).toggleClass('down');
      $('.card-slider.products').toggleClass('active');
      return false;
    });
  }

  if ($('.all-trail-map-steps').length) {
    var container = document.querySelector('.all-trail-map-steps');
    var msnry = new Masonry(container, {
      itemSelector: '.trail-map-steps',
      gutter: '.gutter-sizer'
    });
  }

  prettyPrint();
});
