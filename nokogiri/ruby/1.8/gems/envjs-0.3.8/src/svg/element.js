$debug("Defining SVGElement");
/*
* SVGElement - DOM Level 2
*/
var SVGElement = function(ownerDocument,name) {
    DOMElement.apply(this,arguments);
};

SVGElement.prototype = new DOMElement();
__extend__(SVGElement.prototype, {
    toString : function(){
        return "SVGElement #"+this._id + " "+ this.tagName + (this.id?" => "+this.id:'');
    }
});

// $w.SVGElement = SVGElement;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
