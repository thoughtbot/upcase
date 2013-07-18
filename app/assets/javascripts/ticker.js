$(function() {
  $('.new-products-workshops-show section').waypoint(function(direction) {
    if (direction === 'down') {
      var id = $(this).attr('id');
      $('.new-products-workshops-show nav a').removeClass('inview');
      $('.new-products-workshops-show nav a[href="#'+id+'"]').addClass('inview');
    }
  }, { offset: '20%' });

  $('.new-products-workshops-show section').waypoint(function(direction) {
    if (direction === 'up') {
      var id = $(this).attr('id');
      $('.new-products-workshops-show nav a').removeClass('inview');
      $('.new-products-workshops-show nav a[href="#'+id+'"]').addClass('inview');
    }
  }, { offset: '-20%' });

  $('.new-products-workshops-show .summary').waypoint(function(direction) {
    $('body').css('background', '#fff');
  }, { offset: '10%' });
});
