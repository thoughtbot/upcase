/*
*	document.js
*
*	DOM Level 2 /DOM level 3 (partial)
*	
*	This file adds the document object to the window and allows you
*	you to set the window.document using an html string or dom object.
*
*/

$debug("Initializing document.implementation");
var $implementation =  new DOMImplementation();
// $implementation.namespaceAware = false;
$implementation.errorChecking = false;

// read only reference to the Document object
var $document;
{    // a temporary scope, nothing more
  var referrer = "";
  try {
    referrer = $openingWindow.location.href;
  } catch (e){ /* or not */ }
  $document = new HTMLDocument($implementation, $w, referrer);
}

$w.__defineGetter__("document", function(){
	return $document;
});
