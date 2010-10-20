$debug("Defining SVGLocatable");
var SVGLocatable = function() {
};
SVGLocatable.prototype = {};
__extend__(SVGLocatable.prototype, {
    getBBox: function() {
        return new SVGRect(0,0,1,1);
    }
});

// $w.SVGLocatable = SVGLocatable;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
