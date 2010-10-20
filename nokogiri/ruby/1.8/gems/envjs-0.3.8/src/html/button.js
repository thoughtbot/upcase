$debug("Defining HTMLButtonElement");
/*
* HTMLButtonElement - DOM Level 2
*/
var HTMLButtonElement = function(ownerDocument) {
    this.HTMLTypeValueInputs = HTMLTypeValueInputs;
    this.HTMLTypeValueInputs(ownerDocument);
};
HTMLButtonElement.prototype = new HTMLTypeValueInputs;
__extend__(HTMLButtonElement.prototype, inputElements_status);
__extend__(HTMLButtonElement.prototype, {
    get dataFormatAs(){
        return this.getAttribute('dataFormatAs');
    },
    set dataFormatAs(value){
        this.setAttribute('dataFormatAs',value);
    }
});

// $w.HTMLButtonElement = HTMLButtonElement;

