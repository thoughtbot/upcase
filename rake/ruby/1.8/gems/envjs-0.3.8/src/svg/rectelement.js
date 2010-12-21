$debug("Defining SVGRectElement");
/*
* SVGRectElement - DOM Level 2
*/
var SVGRectElement = function(ownerDocument) {
    SVGElement.apply(this,arguments);
    SVGStylable.apply(this,arguments);
    SVGTransformable.apply(this,arguments);
};

SVGRectElement.prototype = new SVGElement;
__extend__(SVGRectElement.prototype, SVGStylable.prototype );
__extend__(SVGRectElement.prototype, SVGTransformable.prototype );
__extend__(SVGRectElement.prototype, {
});
SVGRectElement.prototype.constructor = SVGRectElement;

// $w.SVGRectElement = SVGRectElement;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
