var $debug = function() {
  // $master["print"].apply(this,arguments);
};

var $warn = function() {
  // $master["print"].apply(this,arguments);
};

var $info = function() {
  // $master["print"].apply(this,arguments);
};

var $error = function() {
  $master["print"].apply(this,arguments);
  if (arguments[0].stack) {
    $master["print"](arguments[0].stack);
  }
};

var __extend__ = function (a,b) {
	for ( var i in b ) {
		var g = b.__lookupGetter__(i), s = b.__lookupSetter__(i);
		if ( g || s ) {
			if ( g ) a.__defineGetter__(i, g);
			if ( s ) a.__defineSetter__(i, s);
		} else
			a[i] = b[i];
	} return a;
};

var __setArray__ = function ( target, array ) {
	// Resetting the length to 0, then using the native Array push
	// is a super-fast way to populate an object with array-like properties
	target.length = 0;
	Array.prototype.push.apply( target, array );
};

function trim( str ){
    return (str || "").replace( /^\s+|\s+$/g, "" );
    
};
