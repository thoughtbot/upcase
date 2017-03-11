$(".js-toggle-close-trigger").on("click", function() {
  event.preventDefault();

  var targetSelector = $(this).data().target;

  $(targetSelector).toggleClass("is-open");
});
