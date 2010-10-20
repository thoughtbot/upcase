$debug("Defining HTMLOptionElement");
/*
* HTMLOptionElement - DOM Level 2
*/
var HTMLOptionElement = function(ownerDocument) {
    this.HTMLInputCommon = HTMLInputCommon;
    this.HTMLInputCommon(ownerDocument);
};
HTMLOptionElement.prototype = new HTMLInputCommon;
__extend__(HTMLOptionElement.prototype, {
    setAttributeNS : function(namespaceURI, qualifiedName, value) {
        if (namespaceURI) {
            throw new Error("unexpected namespaceURI");
        }
        this.setAttribute(qualifiedName, value);
    },
    setAttribute: function(name, value){
        if (name != "selected") {
            HTMLInputCommon.prototype.setAttribute.apply(this, arguments);
        } else {
            if(this.defaultSelected===null && this.selected!==null){
                this.defaultSelected = this.selected;
            }
            var selectedValue = (value ? 'selected' : '');
            if (this.getAttribute('selected') == selectedValue) {
                // prevent inifinite loops (option's selected modifies 
                // select's value which modifies option's selected)
                return;
            }
            HTMLInputCommon.prototype.setAttribute.call(this, 'selected', selectedValue);
            var parent = this.parentNode;
            while (parent && parent.tagName === "OPTGROUP") {
                parent = parent.parentNode;
            }
            if (value) {
                // set select's value to this option's value (this also 
                // unselects previously selected value)
                parent && (parent.value = this.value);
            } else {
                // if no other option is selected, select the first option in the select
                var i, anythingSelected;
                if (parent.options) {
                    for (i=0; i<parent.options.length; i++) {
                        if (parent.options[i].selected) {
                            anythingSelected = true;
                            break;
                        }
                    }
                }
                if (!anythingSelected && parent.options) {
                    parent.value = parent.options[0].value;
                }
            }
        }
    },
    get defaultSelected(){
        return this.getAttribute('defaultSelected');
    },
    set defaultSelected(value){
        this.setAttribute('defaultSelected',value);
    },
    get index(){
        var options = this.parent.childNodes;
        for(var i; i<options.length;i++){
            if(this == options[i])
                return i;
        }
        return -1;
    },
    get label(){
        return this.getAttribute('label');
    },
    set label(value){
        this.setAttribute('label',value);
    },
    get selected(){
        return (this.getAttribute('selected')=='selected');
    },
    set selected(value){
        this.setAttribute('selected',value);
    },
    get text(){
         return ((this.nodeValue === null) ||  (this.nodeValue ===undefined)) ?
             this.innerHTML :
             this.nodeValue;
    },
    get value(){
        return ((this.getAttribute('value') === undefined) || (this.getAttribute('value') === null)) ?
            this.text :
            this.getAttribute('value');
    },
    set value(value){
        this.setAttribute('value',value);
    }
});

// $w.HTMLOptionElement = HTMLOptionElement;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
