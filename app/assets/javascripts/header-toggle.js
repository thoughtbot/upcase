$(function() {
  var $toggle = $(".nav-toggle");
  var nav = $(".header-wrapper nav");

  $toggle.click(function() {
    nav.toggleClass("closed");
  });
});
