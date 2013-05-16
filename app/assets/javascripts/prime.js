if ($('.journey').length) {

  var jsPlumbSettings = jsPlumb.getInstance();

  jsPlumbSettings.Defaults.Container = $('body');
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

  jsPlumb.ready(function() {
    setPlumbSettings();
  });

  $(window).resize(setPlumbSettings);

  $(function() {
    $('.pitch > .two-stacked').waypoint(function(direction) {
      console.dir($(this));
      $(this).children('div').addClass('visible');
    }, { offset: '75%' });
  })
}
