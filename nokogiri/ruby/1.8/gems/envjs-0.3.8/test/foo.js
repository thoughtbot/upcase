debug = this.debug || ( console.log && function(f){console.log(f)} ) || console.debug;
$(function(){
  $("<div id='xx'></div>").appendTo(document.body);
  $("#xx").get(0).innerHTML =
    "<script id='foo0'>debug('shouldnt');</sc"+"ript>";
  v = $("<div></div>").get(0);
  v.innerHTML = "<script id='foo1'>debug('should');</sc"+"ript>";
  $(document.body).append(v);

  n = $("<div>0</div><script id='foo3'>debug('*');</sc"+"ript>");
  m = $("<div>0</div><script src='y.js'></sc"+"ript>"); // debug("**2");
  debug("before add");
  n.appendTo(document.body);
  m.appendTo(document.body);
  // debug(n.get(0).ownerDocument.documentElement.innerHTML);
  debug("after add");
  $("<div>1</div><script id='bar'></sc"+"ript>").appendTo(document.body);
  $("<div>2</div><script id='foobar'></sc"+"ript>").appendTo(document.body);
  $("#bar").attr("src","x.js"); // = debug("**");
  $("#foobar").append(document.createTextNode('debug("***");'));
  setTimeout(function(){
    debug("replace text");
    $("#foobar").text('debug("****");');
    debug("replace attribute");
    $("#bar").attr("src","x.js");
    setTimeout(function(){
      debug("remove attribute");
      $("#bar").attr("src","");
      setTimeout(function(){
        debug("readd attribute");
        $("#bar").attr("src","x.js");
      },100);
    },100);
  },100);
  $("<div id='nope'>huh?</div>").appendTo(document.body);
  $("#nope").get(0).innerHTML = "<script>debug('oops!');</scr"+"ipt>";
  $("#nope script").text("debug('me neither');");
  $("#nope script").attr("src","x.js"); // or me
  debug('loaded');
});
