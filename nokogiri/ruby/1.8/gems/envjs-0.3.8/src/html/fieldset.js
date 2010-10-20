$debug("Defining HTMLFieldSetElement");
/*
* HTMLFieldSetElement - DOM Level 2
*/
var HTMLFieldSetElement = function(ownerDocument) {
    this.HTMLLegendElement = HTMLLegendElement;
    this.HTMLLegendElement(ownerDocument);
};
HTMLFieldSetElement.prototype = new HTMLLegendElement;
__extend__(HTMLFieldSetElement.prototype, {
    get margin(){
        return this.getAttribute('margin');
    },
    set margin(value){
        this.setAttribute('margin',value);
    }
});

// $w.HTMLFieldSetElement = HTMLFieldSetElement;
