//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.observe_field

function searchTopics(text) {
  if(/\S/.test(text)) {
    $('.search').hide();
    $('.clear-search').hide();
    $('.spinner').show();

    $.get('/topics/' + text, {}, function(data) {
      var results = $(data).filter(".results");
      var title = $(results).attr('data-title');
      var url = $(results).attr('data-url');
      $('.results').replaceWith(results);

      $('.search').hide();
      $('.spinner').hide();
      $('.clear-search').show();

      if(window.history.pushState) {
        document.title = title;
        if(url) {
          window.history.pushState({}, title, url);
        }
      } else {
        document.title = title;
      }
    });
  }
}

$(function(){
  $(".search-bar input").observe_field(0.1, function() {
    searchTopics(this.value);
  });

  $("li.more a").click(function() {
    $(this).parent().siblings("li.additional").show();
    $(this).parent().hide();
  })

  $("section.popular li a").click(function() {
    $(".search-bar input").val($(this).text());
    return false;
  });
});

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

  $('.search-bar .search').live('click', function() {
    searchTopics($(this).siblings('input').val());
    return false;
  });

  $('.search-bar .clear-search').live('click', function() {
    $(this).siblings('input').val('');
    $(this).siblings('.search').show();
    $(this).hide();
  });
});
