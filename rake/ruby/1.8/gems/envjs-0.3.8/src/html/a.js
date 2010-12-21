$debug("Defining HTMLAnchorElement");
/* 
* HTMLAnchorElement - DOM Level 2
*/
var HTMLAnchorElement = function(ownerDocument) {
    //$log("creating anchor element");
    this.HTMLElement = HTMLElement;
    this.HTMLElement(ownerDocument);
};
HTMLAnchorElement.prototype = new HTMLElement;
__extend__(HTMLAnchorElement.prototype, {
	get accessKey() { 
	    return this.getAttribute("accesskey"); 
	    
    },
	set accessKey(val) { 
	    return this.setAttribute("accesskey",val); 
	    
    },
	get charset() { 
	    return this.getAttribute("charset"); 
	    
    },
	set charset(val) { 
	    return this.setAttribute("charset",val); 
	    
    },
	get coords() { 
	    return this.getAttribute("coords"); 
	    
    },
	set coords(val) { 
	    return this.setAttribute("coords",val); 
	    
    },
	get href() { 
	    return this.getAttribute("href"); 
	    
    },
	set href(val) { 
	    return this.setAttribute("href",val); 
	    
    },
	get hreflang() { 
	    return this.getAttribute("hreflang"); 
	    
    },
	set hreflang(val) { 
	    return this.setAttribute("hreflang",val); 
	    
    },
	get name() { 
	    return this.getAttribute("name"); 
	    
    },
	set name(val) { 
	    return this.setAttribute("name",val); 
	    
    },
	get rel() { 
	    return this.getAttribute("rel"); 
	    
    },
	set rel(val) { 
	    return this.setAttribute("rel",val); 
	    
    },
	get rev() { 
	    return this.getAttribute("rev"); 
	    
    },
	set rev(val) { 
	    return this.setAttribute("rev",val); 
	    
    },
	get shape() { 
	    return this.getAttribute("shape"); 
	    
    },
	set shape(val) { 
	    return this.setAttribute("shape",val); 
	    
    },
	get target() { 
	    return this.getAttribute("target"); 
	    
    },
	set target(val) { 
	    return this.setAttribute("target",val); 
	    
    },
	get type() { 
	    return this.getAttribute("type"); 
	    
    },
	set type(val) { 
	    return this.setAttribute("type",val); 
	    
    },
	blur:function(){
	    __blur__(this);
	    
    },
	focus:function(){
	    __focus__(this);
	    
    }
});

// $w.HTMLAnchorElement = HTMLAnchorElement;