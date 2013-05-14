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
    connector:['Bezier', { curviness: 440 }],
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
};

var animate_journey = function(e) {
  if ($(e).length) {
    jsPlumbSettings.animate(
      e,
      {
        top: '0',
        opacity: '1'
      },
      {
        duration: 800,
        easing: 'easeOutBack',
        complete: function() {
          animate_journey($(e).parent().next().children('.journey-bullet'));
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
