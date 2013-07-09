//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require retina
//= require prettify/prettify
//= require prettyprint
//= require jquery.jsPlumb-1.4.0-all-min
//= require waypoints.min
//= require masonry.min.js
//= require prime
//= require slider
//= require topics
//= require checkout

$(function() {
  if ($('.all-trail-map-steps').length) {
    var container = document.querySelector('.all-trail-map-steps');
    var msnry = new Masonry(container, {
      itemSelector: '.trail-map-steps',
      gutter: '.gutter-sizer'
    });
  }
});
