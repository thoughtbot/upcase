//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.ba-throttle-debounce
//= require jquery.jsPlumb-1.4.0-all-min
//= require highlight.min
//= require upcase
//= require dismiss-flashes
//= require plans
//= require checkout
//= require header-toggle
//= require autoresize
//= require wistia_helper
//= require headhesive.min.js
//= require header-setup
//= require fastclick
//= require readmore
//= require extended_description
//= require tapas

$(function() {
  hljs.initHighlightingOnLoad();

  $('textarea').autosize();

  FastClick.attach(document.body);

  Upcase.dismissFlashesOnClick();
});
