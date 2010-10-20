/*
*	window.js
*   - this file will be wrapped in a closure providing the window object as $w
*/
// a logger or empty function available to all modules.
var $log = $env.log,
    $debug = $env.debug,
    $info = $env.info,
    $warn = $env.warn,
    $error = $env.error;
    
//The version of this application
var $version = "0.1";
//This should be hooked to git or svn or whatever
var $revision = "0.0.0.0";

//These descriptions of window properties are taken loosely David Flanagan's
//'JavaScript - The Definitive Guide' (O'Reilly)

/**> $cookies - see cookie.js <*/
// read only boolean specifies whether the window has been closed
var $closed = false;

// a read/write string that specifies the default message that appears in the status line 
var $defaultStatus = "Done";

// a read-only reference to the Document object belonging to this window
/**> $document - See document.js <*/

//IE only, refers to the most recent event object - this maybe be removed after review
var $event = null;

//A read-only array of window objects
//var $frames = [];    // TODO: since window.frames can be accessed like a
                       //   hash, will need an object to really implement

// a read-only reference to the History object
/**>  $history - see location.js <**/

// read-only properties that specify the height and width, in pixels
var $innerHeight = 600, $innerWidth = 800;

// a read-only reference to the Location object.  the location object does expose read/write properties
/**> $location - see location.js <**/

// The name of window/frame.  Set directly, when using open(), or in frameset.
// May be used when specifying the target attribute of links
var $name;

// a read-only reference to the Navigator object
/**> $navigator - see navigator.js <**/

// a read/write reference to the Window object that contained the script that called open() to 
//open this browser window.  This property is valid only for top-level window objects.

var $opener = $openingWindow = options.opener;

// Read-only properties that specify the total height and width, in pixels, of the browser window.
// These dimensions include the height and width of the menu bar, toolbars, scrollbars, window
// borders and so on.  These properties are not supported by IE and IE offers no alternative 
// properties;
var $outerHeight = $innerHeight, $outerWidth = $innerWidth;

// Read-only properties that specify the number of pixels that the current document has been scrolled
//to the right and down.  These are not supported by IE.
var $pageXOffset = 0, $pageYOffset = 0;


// A read-only reference to the Window object that contains this window
// or frame.  If the window is a top-level window, parent refers to
// the window itself.  If this window is a frame, this property refers
// to the window or frame that conatins it.
var $parent = options.parent || window;
try {
    if ($parentWindow.$thisWindowsProxyObject)
        $parent = $parentWindow.$thisWindowsProxyObject;
} catch(e){}



// a read-only refernce to the Screen object that specifies information about the screen: 
// the number of available pixels and the number of available colors.
/**> $screen - see screen.js <**/
// read only properties that specify the coordinates of the upper-left corner of the screen.
var $screenX = 0, $screenY = 0;
var $screenLeft = $screenX, $screenTop = $screenY;

// a read/write string that specifies the current contents of the status line.
var $status = '';

// a read-only reference to the top-level window that contains this window.  If this
// window is a top-level window it is simply a refernce to itself.  If this window 
// is a frame, the top property refers to the top-level window that contains the frame.
var $top = $parent && $parent.top || this;

// the window property is identical to the self property and to this obj
var $window = $w;
try {
    if ($w.$thisWindowsProxyObject)
        $window = $w.$thisWindowsProxyObject;
} catch(e){}
options.proxy && ( $window = options.proxy );

$debug("Initializing Window.");
__extend__($w,{
  get closed(){return $closed;},
  get defaultStatus(){return $defaultStatus;},
  set defaultStatus(_defaultStatus){$defaultStatus = _defaultStatus;},
  //get document(){return $document;}, - see document.js
  get event(){return $event;},

  get frames(){return undefined;}, // TODO: not yet any code to maintain list
  get length(){return undefined;}, //   should be frames.length, but.... TODO

  //get history(){return $history;}, - see history.js
  get innerHeight(){return $innerHeight;},
  get innerWidth(){return $innerWidth;},
  get clientHeight(){return $innerHeight;},
  get clientWidth(){return $innerWidth;},
  //get location(){return $location;}, see location.js
  get name(){return $name;},
  set name(newName){ $name = newName; },
  //get navigator(){return $navigator;}, see navigator.js
  get opener(){return $opener;},
  get outerHeight(){return $outerHeight;},
  get outerWidth(){return $outerWidth;},
  get pageXOffest(){return $pageXOffset;},
  get pageYOffset(){return $pageYOffset;},
  get parent(){return $parent;},
  //get screen(){return $screen;}, see screen.js
  get screenLeft(){return $screenLeft;},
  get screenTop(){return $screenTop;},
  get screenX(){return $screenX;},
  get screenY(){return $screenY;},
  get self(){return $window;},
  get status(){return $status;},
  set status(_status){$status = _status;},
  get top(){return $top || $window;},
  get window(){return $window;},

  // DOM0

  Image: function() {
    return document.createElement("img");
  }
  /*,
  toString : function(){
      return '[object Window]';
  } FIX SMP */
});

$w.open = function(url, name, features, replace){
  if (features)
    $env.warn("'features' argument for 'window.open()' not yet implemented");
  if (replace)
    $env.warn("'replace' argument for 'window.open()' not yet implemented");

  var undef;
  if(url === undef || url === "") {
    url = "about:blank";
  }

  var newWindow = $env.newwindow(this, null, url);
  newWindow.$name = name;
  return newWindow;
};

$w.close = function(){
  $env.unload($w);
  $closed = true;
};     

$env.unload = function(windowToUnload){
  try {
    var event = windowToUnload.document.createEvent();
    event.initEvent("unload");
    windowToUnload.document.getElementsByTagName('body')[0].
      dispatchEvent(event, false);
  }
  catch (e){}   // maybe no/bad document loaded, ignore

  var event = windowToUnload.document.createEvent();
  event.initEvent("unload");
  windowToUnload.dispatchEvent(event, false);
};
  
  
$env.load = function(url,xhr_options){
    $location = $env.location(url);
    __setHistory__($location);
try{
    $w.document.load($location,xhr_options);
}catch(e){
  $warn("Exception while loading window: "+e);
  throw e;
}
};


/* Time related functions - see timer.js
*   - clearTimeout
*   - clearInterval
*   - setTimeout
*   - setInterval
*/

/*
* Events related functions - see event.js
*   - addEventListener
*   - attachEvent
*   - detachEvent
*   - removeEventListener
*   
* These functions are identical to the Element equivalents.
*/

/*
* UIEvents related functions - see uievent.js
*   - blur
*   - focus
*
* These functions are identical to the Element equivalents.
*/

/* Dialog related functions - see dialog.js
*   - alert
*   - confirm
*   - prompt
*/

/* Screen related functions - see screen.js
*   - moveBy
*   - moveTo
*   - print
*   - resizeBy
*   - resizeTo
*   - scrollBy
*   - scrollTo
*/

/* CSS related functions - see css.js
*   - getComputedStyle
*/

/*
* Shared utility methods
*/
// Helper method for extending one object with another.  
function __extend__(a,b) {
	for ( var i in b ) {
		var g = b.__lookupGetter__(i), s = b.__lookupSetter__(i);
		if ( g || s ) {
			if ( g ) a.__defineGetter__(i, g);
			if ( s ) a.__defineSetter__(i, s);
		} else
			a[i] = b[i];
	} return a;
};
	

// from ariel flesler http://flesler.blogspot.com/2008/11/fast-trim-function-for-javascript.html
// this might be a good utility function to provide in the env.core
// as in might be useful to the parser and other areas as well
function trim( str ){
    return (str || "").replace( /^\s+|\s+$/g, "" );
    
};
/*function trim( str ){
    var start = -1,
    end = str.length;
    /*jsl:ignore*
    while( str.charCodeAt(--end) < 33 );
    while( str.charCodeAt(++start) < 33 );
    /*jsl:end*
    return str.slice( start, end + 1 );
};*/

//from jQuery
function __setArray__( target, array ) {
	// Resetting the length to 0, then using the native Array push
	// is a super-fast way to populate an object with array-like properties
	target.length = 0;
	Array.prototype.push.apply( target, array );
};
