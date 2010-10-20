$debug("Defining HTMLSelectElement");
/*
* HTMLSelectElement - DOM Level 2
*/
var HTMLSelectElement = function(ownerDocument) {
    this.HTMLTypeValueInputs = HTMLTypeValueInputs;
    this.HTMLTypeValueInputs(ownerDocument);

    this._oldIndex = -1;
};
HTMLSelectElement.prototype = new HTMLTypeValueInputs;
__extend__(HTMLSelectElement.prototype, inputElements_dataProperties);
__extend__(HTMLButtonElement.prototype, inputElements_size);
__extend__(HTMLSelectElement.prototype, inputElements_onchange);
__extend__(HTMLSelectElement.prototype, inputElements_focusEvents);
__extend__(HTMLSelectElement.prototype, {
    setAttributeNS : function(namespaceURI, qualifiedName, value) {
        if (namespaceURI) {
            throw new Error("unexpected namespaceURI");
        }
        this.setAttribute(qualifiedName, value);
    },
    getAttributeNS : function(namespaceURI, qualifiedName) {
        if (namespaceURI) {
            throw new Error("unexpected namespaceURI");
        }
        return this.getAttribute(qualifiedName);
    },
    setAttribute: function(name, value){
        // This is a workaround for now for copying nodes in 
        if (name === "type") {
            if (!this.ownerDocument._performingImportNodeOperation) {
                throw new Error("cannot set readonly attribute: "+name);
            }
        } else if (name === "multiple") {
            HTMLInputCommon.prototype.
                setAttribute.call(this, "type", value ? "select-multiple" : "select-one");
            HTMLInputCommon.prototype.setAttribute.call(this, "multiple", !!value);
        } else if (name === "value") {
            var options = this.options,
                i, index;
            for (i=0; i<options.length; i++) {
                if (options[i].value == value) {
                    index = i;
                    break;
                }
            }
            if (index !== undefined) {
                HTMLInputCommon.prototype.setAttribute.call(this, "value", value);
                this.selectedIndex = index;

                var event = this.ownerDocument.createEvent();
                event.initEvent("change");
                this.dispatchEvent( event );
            }
        } else {
            HTMLInputCommon.prototype.setAttribute.apply(this, arguments);
        }
    },
    getAttribute: function(name){
        if (name === "type") {
            return HTMLInputCommon.prototype.getAttribute.apply(this, arguments) || this.multple ? "select-multiple" : "select-one";
        } else if (name === "value") {
            var value = HTMLInputCommon.prototype.getAttribute.apply(this, arguments);
            if (value === undefined || value === null) {
                var index = this.selectedIndex;
                return (index != -1) ? this.options[index].value :
                    ( this.multiple ? "" :
                      ( this.options[0] ? this.options[0].value : "" ) );
            } else {
                return value;
            }
        } else {
            return HTMLInputCommon.prototype.getAttribute.apply(this, arguments);
        }
    },
    // over-ride the value setter in HTMLTypeValueInputs
    set value(newValue) {
        this.setAttribute("value",newValue);
    },
    get value() {
        return this.getAttribute("value");
    },
    get length(){
        return this.options.length;
    },
    get multiple(){
        return this.getAttribute('multiple');
    },
    set multiple(value){
        this.setAttribute('multiple',value);
    },
    get options(){
        return this.getElementsByTagName('option');
    },
    get selectedIndex(){
        var options = this.options;
        for(var i=0;i<options.length;i++){
            if(options[i].selected){
                return i;
            }
        };
        return -1;
    },
    
    set selectedIndex(value) {
        var i;
        for (i=0; i<this.options.length; i++) {
            this.options[i].selected = this.multiple ?
                (i == Number(value) || this.options[i].selected) :
                (i == Number(value));
        }
    },
    get type(){
        return this.getAttribute('type');
    },

    add : function(){
        __add__(this);
    },
    remove : function(){
        __remove__(this);
    }
});

// $w.HTMLSelectElement = HTMLSelectElement;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
