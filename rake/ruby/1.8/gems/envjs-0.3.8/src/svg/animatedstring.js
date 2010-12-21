$debug("Defining SVGAnimatedString");
var SVGAnimatedString = function() {
    this.__baseVal__ = "";
};

__extend__(SVGAnimatedString.prototype, {
    get baseVal() {
        return this.__baseVal__;
    },
    set baseVal(v) {
        this.__baseVal__ = v;
        this.__callback__ && this.__callback__(v);
    },
    toString : function(){
        return "SVGAnimatedString "+this.baseVal;
    }
});

// $w.SVGAnimatedString = SVGAnimatedString;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
