$debug("Defining HTMLCanvasElement");
/* 
* HTMLCanvasElement - DOM Level 2
*/
var HTMLCanvasElement = function(ownerDocument) {
    this.HTMLElement = HTMLElement;
    this.HTMLElement(ownerDocument);
};
HTMLCanvasElement.prototype = new HTMLElement;
__extend__(HTMLCanvasElement.prototype, {
});

$w.HTMLCanvasElement = HTMLCanvasElement;
	