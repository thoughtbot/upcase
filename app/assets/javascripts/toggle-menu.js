$(function() {
  var $trigger = $(".js-data-toggle-menu-trigger");

  $trigger.click(function() {
    $("body").toggleClass("open");
  });
});
