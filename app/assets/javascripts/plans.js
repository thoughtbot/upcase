$(function() {
  showFeatureDetail('.upcase-mentor figure[data-target=mentoring]');
});

$('.plan .features figure:not(.inactive)').on('click', function() {
  showFeatureDetail($(this));
});

function showFeatureDetail(feature) {
  var plan = $(feature).parents('.plan');
  var targetClass = $(feature).data('target');
  plan.find('.feature-details').addClass('active');
  $(feature).addClass('active').siblings('figure').removeClass('active');
  plan.find('[data-target-id='+targetClass+']').addClass('active').siblings('.feature-detail').removeClass('active');
};
