if ($('.trail-category').length) {
  $(function() {
    // render dots onto page
    $('.steps-complete').each(function() {
      var complete = $(this).data('complete');
      var total = $(this).data('total');

      // generate html string of dots
      var dots_html = '';
      for (var i = 1; i <= total; i++) {
        dots_html += '<figure class="journey-bullet"></figure>';
      }
      $(this).find('.dots').html(dots_html);

      // place text of number of complete items on the x-axis according to
      // percent complete
      if (complete / total > .75) {
        $(this).find('.text-complete').css({
          'left': 'auto',
          'right': 0
        });
      } else {
        $(this).find('.text-complete').css(
          'left', ((complete - 1) / total * 100) + '%'
        );
      }

      // spread journey bullet evenly along the width of the container
      $(this).find('.journey-bullet').each(function(e) {
        var percentage = $(this).index() / total * 100;
        $(this).css('left', percentage+'%');

        if (e < complete) {
          $(this).addClass('complete');
        }
      });
    });

    // randomize vertical position of dots
    // the more completions there are, the less variance there is between
    // each item. i.e. the more you know, the less disparate all the
    // information seems
    $('.journey-bullet:not(.complete)').each(function() {
      var complete = $(this).parents('.steps-complete').data('complete');
      var total = $(this).parents('.steps-complete').data('total');

      var max = 88; // so the dots don't exceed the parent boundaries
      var tempered_max = max - ((complete/total) * max);
      var height_percentage = Math.floor(Math.random() * tempered_max) + 1;

      var pos_or_neg = Math.random()*2|0 || -1;
      var height_from_center = 50 + pos_or_neg * (height_percentage / 2);

      $(this).css('top', height_from_center+'%');
    });
  });
}
