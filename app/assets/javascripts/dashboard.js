$(function() {
  if ($('.card-slider').length) {
    // +4 to account for inline-block 4px space character
    var card_width = $('.product-card:first').outerWidth(true) + 4;

    function slider_at_beginning(slider) {
      return parseInt(slider.find('.product-card:first').css('margin-left'), 10) >= 0;
    }

    function slider_at_end(slider) {
      return (slider.find('.product-card:last').position().left / slider.width()) <= 1;
    }

    function toggle_nav_items(slider) {
      slider.children('.nav').removeClass('disabled');

      if (slider_at_beginning(slider)) {
        slider.children('.prev').addClass('disabled');
      }
      if (slider_at_end(slider)) {
        slider.children('.next').addClass('disabled');
      }
    }

    function slide_one_card(slider, direction) {
      if (direction == 'left') {
        slider.children('.product-card:first').css({
          'margin-left': "-="+card_width+"px"
        });
      }
      if (direction == 'right') {
        slider.children('.product-card:first').css({
          'margin-left': "+="+card_width+"px"
        });
      }
    }

    $('.card-slider').each(function() {
      toggle_nav_items($(this));
    });

    $('.card-slider .nav').on('click', function() {
      var slider = $(this).parent('.card-slider');

      if ($(this).hasClass('next') && !slider_at_end(slider)) {
        slide_one_card(slider, 'left');
      }
      if ($(this).hasClass('prev') && !slider_at_beginning(slider)) {
        slide_one_card(slider, 'right');
      }

      toggle_nav_items(slider);
    });
  }
});
