$debug("Defining SVGDocument");
/*
* SVGDocument - DOM Level 2
*/
/**
 * @class  SVGDocument - The Document interface represents the entire SVG or XML document.
 *   Conceptually, it is the root of the document tree, and provides the primary access to the document's data.
 *
 * @extends DOMDocument
 */
var SVGDocument = function() {
  throw new Error("SVGDocument() not implemented");
};
SVGDocument.prototype = new DOMDocument();
__extend__(SVGDocument.prototype, {
  createElement: function(tagName){
    $debug("SVGDocument.createElement( "+tagName+" )");
    var node;
    if(tagName === "rect") {node = new SVGRectElement(this);}
    else {node = new SVGSVGElement(this);}
    node.tagName  = tagName;
    return node;
  }});

// $w.SVGDocument = SVGDocument;
