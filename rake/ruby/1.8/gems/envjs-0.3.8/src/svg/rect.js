$debug("Defining SVGRect");
var SVGRect = function(x,y,width,height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
};
SVGRect.prototype = {};
__extend__(SVGRect.prototype, {
});

// $w.SVGRect = SVGRect;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
