var setupTableOfContents = function() {
  var $tocToggle = $('[data-role="table-of-contents-toggle"]');
  var $tocClose = $('[data-role="table-of-contents-close"]');
  var $toc = $('[data-role="table-of-contents"]');
  var $body = $('body');

  var closeToc = function() {
    $toc.removeClass('slide-down');
    $tocToggle.removeClass('is-open');
    $body.removeClass('has-table-of-contents');
  };

  var openToc = function() {
    $toc.addClass('slide-down');
    $tocToggle.addClass('is-open');
    $body.addClass('has-table-of-contents');
  };

  $tocToggle.click(function() {
    if ($(this).hasClass('is-open')) {
      closeToc();
    } else {
      openToc();
    }
    return false;
  });

  $tocClose.click(function() {
    closeToc();
    return false;
  });
};

$(function() {
  setupTableOfContents();
  var header = '.landing [data-role="header"]';

  if ($(header).length) {
    new Headhesive(header, {
      offset:  500,
      onStick: setupTableOfContents,
      onUnstick: setupTableOfContents,
    });
  }
});
