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

    function slide_one_card(slider) {
      if (!slider_at_end(slider) || !slider_at_beginning(slider)) {
        slider.children('.product-card:first').css({
          'margin-left': parseInt(- card_width * slider.data('index'), 10)+'px'
        });
      }
    }

    $('.card-slider').each(function() {
      toggle_nav_items($(this));
      $(this).data('index', 0);
    });

    $('.card-slider .nav').on('click', function() {
      var slider = $(this).parent('.card-slider');

      if ($(this).hasClass('next') && !slider_at_end(slider)) {
        slider.data('index', slider.data('index') + 1);
      }
      if ($(this).hasClass('prev') && !slider_at_beginning(slider)) {
        slider.data('index', slider.data('index') - 1);
      }

      slide_one_card(slider);

      // trigger navigation check after transition end
      slider.children('.product-card:first').one('webkitTransitionEnd msTransitionEnd transitionend', function() {
        toggle_nav_items(slider);
      });
    });
  }
});
