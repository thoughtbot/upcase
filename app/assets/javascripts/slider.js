$(function() {
  if ($('.card-slider').length) {
    // assign every slider item a slider class
    $('.card-slider').children(':not(.nav)').addClass('slider-item');

    // +4 to account for inline-block 4px space character
    var card_width = $('.slider-item:first').outerWidth(true) + 4;

    function slider_at_beginning(slider) {
      return parseInt(slider.find('.slider-item:first').position().left - slider.find('.nav.prev').width(), 10) >= 0;
    }

    function slider_at_end(slider) {
      return (slider.find('.slider-item:last').position().left / slider.width()) <= .9;
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
        var value = 'translateX('+parseInt(- (card_width * 2) * slider.data('index'), 10)+'px)';
        slider.children('.slider-item').css({
          'transform'         : value,
          '-webkit-transform' : value,
          '-moz-transform'    : value,
          '-ms-transform'     : value
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
      slider.children('.slider-item:first').one('webkitTransitionEnd msTransitionEnd transitionend', function() {
        toggle_nav_items(slider);
      });
    });
  }

  if ($('.card-slider.products').length) {
    $('.toggle-slider').click(function() {
      $(this).toggleClass('down');
      $('.card-slider.products').toggleClass('active');
      return false;
    });
  }
});
