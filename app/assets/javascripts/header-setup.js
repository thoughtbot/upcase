var setupTableOfContents = function() {
  var $tableOfContentsToggle = $('[data-role="table-of-contents-toggle"]');
  var $tableOfContentsClose = $('[data-role="table-of-contents-close"]');
  var $tableOfContents = $('[data-role="table-of-contents"]');
  var $body = $('body');

  var closeTableOfContents = function() {
    $tableOfContents.removeClass('slide-down');
    $tableOfContentsToggle.removeClass('is-open');
    $body.removeClass('u-overflow-hidden');
  };

  var openTableOfContents = function() {
    $tableOfContents.addClass('slide-down');
    $tableOfContentsToggle.addClass('is-open');
    $body.addClass('u-overflow-hidden');
  };

  $tableOfContentsToggle.off('click');
  $tableOfContentsToggle.click(function() {
    if ($tableOfContentsToggle.hasClass('is-open')) {
      closeTableOfContents();
    } else {
      openTableOfContents();
    }
    return false;
  });

  $tableOfContentsClose.click(function() {
    closeTableOfContents();
    return false;
  });
};

$(function() {
  setupTableOfContents();
  var header = '.sticky-header';

  if ($(header).length) {
    new Headhesive(header, {
      offset:  window.stickyHeaderStart || 100,
      onStick: setupTableOfContents,
      onUnstick: setupTableOfContents,
    });
  }
});
