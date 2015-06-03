//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.ba-throttle-debounce
//= require jquery.jsPlumb-1.4.0-all-min
//= require highlight.min
//= require plans
//= require checkout
//= require header-toggle
//= require autoresize
//= require wistia_helper
//= require headhesive.min.js
//= require fastclick

$(function() {
  hljs.initHighlightingOnLoad();

  $('textarea').autosize();

  if ($('.landing #header-wrapper').length) {
    var header = new Headhesive('.landing #header-wrapper', { offset: 500 });
  }

  FastClick.attach(document.body);
});
