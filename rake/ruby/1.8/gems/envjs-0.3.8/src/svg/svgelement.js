$debug("Defining SVGSVGElement");
/*
* SVGSVGElement - DOM Level 2
*/
var SVGSVGElement = function(ownerDocument) {
    SVGElement.apply(this,arguments);
    SVGStylable.apply(this,arguments);
};

SVGSVGElement.prototype = new SVGElement;
__extend__(SVGSVGElement.prototype, SVGStylable.prototype );
__extend__(SVGSVGElement.prototype, {
});
SVGSVGElement.prototype.constructor = SVGSVGElement;

// $w.SVGSVGElement = SVGSVGElement;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
