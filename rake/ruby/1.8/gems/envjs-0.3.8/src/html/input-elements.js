/*
 *  a set of convenience classes to centralize implementation of
 * properties and methods across multiple in-form elements
 *
 *  the hierarchy of related HTML elements and their members is as follows:
 *
 *
 *    HTMLInputCommon:  common to all elements
 *       .form
 *
 *    <legend>
 *          [common plus:]
 *       .align
 *
 *    <fieldset>
 *          [identical to "legend" plus:]
 *       .margin
 *
 *
 *  ****
 *
 *    <label>
 *          [common plus:]
 *       .dataFormatAs
 *       .htmlFor
 *       [plus data properties]
 *
 *    <option>
 *          [common plus:]
 *       .defaultSelected
 *       .index
 *       .label
 *       .selected
 *       .text
 *       .value   // unique implementation, not duplicated
 *
 *  ****
 *
 *    HTMLTypeValueInputs:  common to remaining elements
 *          [common plus:]
 *       .name
 *       .type
 *       .value
 *       [plus data properties]
 *
 *
 *    <select>
 *       .length
 *       .multiple
 *       .options[]
 *       .selectedIndex
 *       .add()
 *       .remove()
 *       .item()                                       // unimplemented
 *       .namedItem()                                  // unimplemented
 *       [plus ".onchange"]
 *       [plus focus events]
 *       [plus data properties]
 *       [plus ".size"]
 *
 *    <button>
 *       .dataFormatAs   // duplicated from above, oh well....
 *       [plus ".status", ".createTextRange()"]
 *
 *  ****
 *
 *    HTMLInputAreaCommon:  common to remaining elements
 *       .defaultValue
 *       .readOnly
 *       .handleEvent()                                // unimplemented
 *       .select()
 *       .onselect
 *       [plus ".size"]
 *       [plus ".status", ".createTextRange()"]
 *       [plus focus events]
 *       [plus ".onchange"]
 *
 *    <textarea>
 *       .cols
 *       .rows
 *       .wrap                                         // unimplemented
 *       .onscroll                                     // unimplemented
 *
 *    <input>
 *       .alt
 *       .accept                                       // unimplemented
 *       .checked
 *       .complete                                     // unimplemented
 *       .defaultChecked
 *       .dynsrc                                       // unimplemented
 *       .height
 *       .hspace                                       // unimplemented
 *       .indeterminate                                // unimplemented
 *       .loop                                         // unimplemented
 *       .lowsrc                                       // unimplemented
 *       .maxLength
 *       .src
 *       .start                                        // unimplemented
 *       .useMap
 *       .vspace                                       // unimplemented
 *       .width
 *       .onclick
 *       [plus ".size"]
 *       [plus ".status", ".createTextRange()"]

 *    [data properties]                                // unimplemented
 *       .dataFld
 *       .dataSrc

 *    [status stuff]                                   // unimplemented
 *       .status
 *       .createTextRange()

 *    [focus events]
 *       .onblur
 *       .onfocus

 */




$debug("Defining input element 'mix in' objects");
var inputElements_dataProperties = {};
var inputElements_status = {};

var inputElements_onchange = {
    onchange: function(event){
        return __eval__(this.getAttribute('onchange')||'', this);
    }
};

var inputElements_size = {
    get size(){
        return Number(this.getAttribute('size'));
    },
    set size(value){
        this.setAttribute('size',value);
    }
};

var inputElements_focusEvents = {
    blur: function(){
        __blur__(this);

        if (this._oldValue != this.value){
            var event = this.ownerDocument.createEvent();
            event.initEvent("change");
            this.dispatchEvent( event );
        }
    },
    focus: function(){
        __focus__(this);
        this._oldValue = this.value;
    }
};


$debug("Defining HTMLInputCommon");

/*
* HTMLInputCommon - convenience class, not DOM
*/
var HTMLInputCommon = function(ownerDocument) {
    this.HTMLElement = HTMLElement;
    this.HTMLElement(ownerDocument);
};
HTMLInputCommon.prototype = new HTMLElement;
__extend__(HTMLInputCommon.prototype, {
    get form(){
        var parent = this.parentNode;
        while(parent && parent.nodeName.toLowerCase() != 'form'){
            parent = parent.parentNode;
        }
        return parent;
    },
    get accessKey(){
        return this.getAttribute('accesskey');
    },
    set accessKey(value){
        this.setAttribute('accesskey',value);
    },
    get access(){
        return this.getAttribute('access');
    },
    set access(value){
        this.setAttribute('access', value);
    },
    get disabled(){
        return (this.getAttribute('disabled')=='disabled');
    },
    set disabled(value){
        this.setAttribute('disabled', (value ? 'disabled' :''));
    }
});

// $w.HTMLInputCommon = HTMLInputCommon;


$debug("Defining HTMLTypeValueInputs");

/*
* HTMLTypeValueInputs - convenience class, not DOM
*/
var HTMLTypeValueInputs = function(ownerDocument) {
    this.HTMLInputCommon = HTMLInputCommon;
    this.HTMLInputCommon(ownerDocument);

    this._oldValue = "";
};
HTMLTypeValueInputs.prototype = new HTMLInputCommon;
__extend__(HTMLTypeValueInputs.prototype, inputElements_size);
__extend__(HTMLTypeValueInputs.prototype, inputElements_status);
__extend__(HTMLTypeValueInputs.prototype, inputElements_dataProperties);
__extend__(HTMLTypeValueInputs.prototype, {
    get defaultValue(){
        return this.getAttribute('defaultValue');
    },
    set defaultValue(value){
        this.setAttribute('defaultValue', value);
    },
    get name(){
        return this.getAttribute('name')||'';
    },
    set name(value){
        this.setAttribute('name',value);
    },
    get type(){
        return this.getAttribute('type');
    },
    set type(type){
        return this.setAttribute('type', type);
    },
    get value(){
        return this.getAttribute('value')||'';
    },
    set value(newValue){
        this.setAttribute('value',newValue);
    },
    setAttribute: function(name, value){
        if (this.type == "radio" && name == "checked" && value && this.name) {
            // HTMLElement.prototype.setAttribute.apply(this, ["checked", "checked"]);
            // return;
            var parent = this.parentNode;
            while(parent != this.ownderDocument) {
                if(parent.tagName == "FORM") {
                    break;
                }
                parent = parent.parentNode;
            }
            if(parent && parent.tagName == "FORM") {
                var xpath = './/input[@type="radio" and @name="'+this.name+'"]';
                var nodes =
                    this.ownerDocument.evaluate(xpath,parent, null, XPathResult.ANY_TYPE,null );
                while(( node = nodes.iterateNext() )) {
                    // FIX? events when we short circuit like this?
                    if (node === this) {
                        HTMLElement.prototype.setAttribute.call(node, "checked", "checked");
                    } else {
                        HTMLElement.prototype.removeAttribute.call(node, "checked");
                    }
                }
            }
        }
        if(name == 'value' && !this.defaultValue){
            this.defaultValue = value;
        }
        HTMLElement.prototype.setAttribute.apply(this, [name, value]);
    }
});

// $w.HTMLTypeValueInputs = HTMLTypeValueInputs;



$debug("Defining HTMLInputAreaCommon");

/*
* HTMLInputAreaCommon - convenience class, not DOM
*/
var HTMLInputAreaCommon = function(ownerDocument) {
    this.HTMLTypeValueInputs = HTMLTypeValueInputs;
    this.HTMLTypeValueInputs(ownerDocument);
};
HTMLInputAreaCommon.prototype = new HTMLTypeValueInputs;
__extend__(HTMLInputAreaCommon.prototype, inputElements_focusEvents);
__extend__(HTMLInputAreaCommon.prototype, inputElements_onchange);
__extend__(HTMLInputAreaCommon.prototype, {
    get readOnly(){
        return (this.getAttribute('readonly')=='readonly');
    },
    set readOnly(value){
        this.setAttribute('readonly', (value ? 'readonly' :''));
    },
    select:function(){
        __select__(this);

    }
});

// $w.HTMLInputAreaCommon = HTMLInputAreaCommon;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
