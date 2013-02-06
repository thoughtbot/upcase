//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require retina

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
  $('.expand-bio a').live('click', function() {
    $(this).parent().parent().children('.bio').height('auto');
    $(this).text('...less');
    $(this).parent().addClass('minimize-bio').removeClass('expand-bio');
    return false;
  });

  $('.minimize-bio a').live('click', function() {
    $(this).parent().parent().children('.bio').removeAttr('style');
    $(this).text('more...');
    $(this).parent().addClass('expand-bio').removeClass('minimize-bio');
    return false;
  });
});
