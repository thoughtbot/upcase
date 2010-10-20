// faux-intro ...
// (function(){
//   (function(){
//     function(){

      // User accesible interface ...
      var Envjs = $w.Envjs = $env.Envjs = function(){
        if(arguments.length === 2){
          for ( var i in arguments[1] ) {
    	    var g = arguments[1].__lookupGetter__(i), 
            s = arguments[1].__lookupSetter__(i);
    	    if ( g || s ) {
    	      if ( g ) $env.__defineGetter__(i, g);
    	      if ( s ) $env.__defineSetter__(i, s);
    	    } else
    	      $env[i] = arguments[1][i];
          }
        }
        if (arguments[0] != null && arguments[0] != "")
          window.location = arguments[0];
      };
      Envjs.$env = $env;
      Envjs.wait = $env.wait;
      Envjs.interpreter = window.whichInterpreter;
      Envjs.evaluate = $env.$master.evaluate;
  
      // $w.__loadAWindowsDocument__(options.url || "about:blank");

      (function(){
          var fns = [];
          for(var key in $master["static"]) {
              if(key.match(/^envjs_init_\d+$/)){
                  fns.push(key);
              }
          }
          fns.sort();
          var nu = this.__nu__ = {};
          nu.base = '';
          nu.metaProps = {};
          for(var i in fns) {
              // print(fns[i]);
              // print($master["static"][fns[i]]);
              $master["static"][fns[i]](this,this.document);
          }
      }());

      $env.load(options.url || "about:blank", options.xhr);
    };

    return $env;

  })(); // close function definition begun in 'intro.js'

  // Initial window setup
  var init = $env.init;
  init();

} catch(e) {
    // $warn("Exception during load: "+e);
    throw e;
}

})();

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// mode:auto-revert
// End:
