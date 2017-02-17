$(function() {
  var $trigger = $(".js-toggle-menu-trigger");

  $trigger.click(function() {
    $("body").toggleClass("is-open");
  });
});
