$(function() {
  if ($('.card-slider').length) {
    // add for to account for inline-block 4px space character
    var card_width = $('.product-card:first').outerWidth(true) + 4;

    function slider_not_at_beginning(slider) {
      return parseInt(slider.find('.product-card:first').css('margin-left'), 10) < 0;
    }

    function slider_not_at_end(slider) {
      return (slider.find('.product-card:last').position().left / slider.width()) > 1;
    }

    $('.card-slider .nav').on('click', function() {
      if ($(this).hasClass('next') &&
          slider_not_at_end($(this).parent('.card-slider'))) {
        $(this).siblings('.product-card:first').css({
          'margin-left': "-="+card_width+"px"
        });
      }
      else if ($(this).hasClass('prev') && 
               slider_not_at_beginning($(this).parent('.card-slider'))) {
        $(this).siblings('.product-card:first').css({
          'margin-left': "+="+card_width+"px"
        });
      }
    });
  }
});
