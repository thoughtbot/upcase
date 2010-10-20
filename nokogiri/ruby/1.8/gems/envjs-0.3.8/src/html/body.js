$debug("Defining HTMLBodyElement");
/*
* HTMLBodyElement - DOM Level 2
*/
var HTMLBodyElement = function(ownerDocument) {
    this.HTMLElement = HTMLElement;
    this.HTMLElement(ownerDocument);
};
HTMLBodyElement.prototype = new HTMLElement;
__extend__(HTMLBodyElement.prototype, {
    onload: function(event){
        return __eval__(this.getAttribute('onload')||'', this)
    },
    onunload: function(event){
        return __eval__(this.getAttribute('onunload')||'', this)
    }
});

// $w.HTMLBodyElement = HTMLBodyElement;
