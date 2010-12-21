$debug("Defining SVGTransformable");
var SVGTransformable = function() {
    SVGLocatable.apply(this,arguments);
};
SVGTransformable.prototype = new SVGLocatable;
__extend__(SVGLocatable.prototype, {
});

// $w.SVGTransformable = SVGTransformable;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
