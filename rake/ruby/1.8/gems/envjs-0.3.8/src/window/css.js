/*
*	css.js
*/
$debug("Initializing Window CSS");
// returns a CSS2Properties object that represents the style
// attributes and values used to render the specified element in this
// window.  Any length values are always expressed in pixel, or
// absolute values.

$w.getComputedStyle = function(elt, pseudo_elt){
  //TODO
  //this is a naive implementation
  $debug("Getting computed style");
  return elt?elt.style:new CSS2Properties({cssText:""});
};