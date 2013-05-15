if ($('.journey').length) {

  var jsPlumbSettings = jsPlumb.getInstance();

  jsPlumbSettings.Defaults.Container = $('.journey');
  jsPlumbSettings.draggable('body');

  var setPlumbSettings = function() {
  jsPlumbSettings.detachEveryConnection();
  jsPlumbSettings.removeAllEndpoints();
  jsPlumbSettings.connect({
    connector:['Bezier', { curviness: 300 }],
    source: 'bullet-1',
    target: 'bullet-2',
    anchors:['Bottom', 'Top'],
      endpoint: ['Dot', { cssClass: 'connector-dot' }]
    });
    jsPlumbSettings.connect({
      connector:['Bezier', { curviness: 420 }],
      source: 'bullet-2',
      target: 'bullet-3',
      anchors:['Bottom', 'Top'],
      endpoint: ['Dot', { cssClass: 'connector-dot' }]
    });
    jsPlumbSettings.connect({
      connector:['Bezier', { curviness: 300 }],
      source: 'bullet-3',
      target: 'bullet-4',
      anchors:['Bottom', 'Top'],
      endpoint: ['Dot', { cssClass: 'connector-dot' }]
    });
    jsPlumbSettings.connect({
      connector:['Bezier', { curviness: 420 }],
      source: 'bullet-4',
      target: 'bullet-5',
      anchors:['Bottom', 'Top'],
      endpoint: ['Dot', { cssClass: 'connector-dot' }]
    });
  };

  var animate_journey = function(e) {
    if ($(e).length) {
      jsPlumbSettings.animate(
        e,
        {
          top: '1rem',
          opacity: '1'
        },
        {
          duration: 300,
          easing: 'easeOutQuart',
          complete: function() {
            animate_journey($(e).parents('.pitch').next().find('.journey-bullet'));
          }
        }
      );
    }
  };

  jsPlumb.ready(function() {
    setPlumbSettings();
    animate_journey($('.journey-bullet:first'));
  });

  $(window).resize(setPlumbSettings);

}
