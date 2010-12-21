$debug("Defining SVGStylable");
/*
* SVGStylable - DOM Level 2
*/
var SVGStylable = function(ownerDocument,name) {
    var self = this;
    (this.__className__ = new SVGAnimatedString).__callback__ = function(v) {
        SVGElement.prototype.setAttribute.call(self,"class",v);
    };
};

SVGStylable.prototype = {};
__extend__(SVGStylable.prototype, {
    setAttribute: function(k,v) {
        if(k === "class") {
            this.__className__.__baseVal__ = v;
        }
        SVGElement.prototype.setAttribute.apply(this,arguments);
    },
    removeAttribute: function(k) {
        if(k === "class") {
            this.__className__.baseVal = "";
        }
        SVGElement.prototype.removeAttribute.apply(this,arguments);
    },
    setAttributeNS: function(ns,k,v) {
        if(k === "class") {
            this.__className__.__baseVal__ = v;
        }
        SVGElement.prototype.setAttributeNS.apply(this,arguments);
    },
    removeAttributeNS: function(ns,k) {
        if(k === "class") {
            this.__className__.baseVal = "";
        }
        SVGElement.prototype.removeAttributeNS.apply(this,arguments);
    },
	get className() { 
		return this.__className__;
	}
});

// $w.SVGStylable = SVGStylable;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
