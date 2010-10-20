$debug("Defining HTMLFormElement");
/* 
* HTMLFormElement - DOM Level 2
*/
var HTMLFormElement = function(ownerDocument){
    this.HTMLElement = HTMLElement;
    this.HTMLElement(ownerDocument);
};
HTMLFormElement.prototype = new HTMLElement;
__extend__(HTMLFormElement.prototype,{
    get acceptCharset(){ 
        return this.getAttribute('accept-charset');
        
    },
    set acceptCharset(acceptCharset){
        this.setAttribute('accept-charset', acceptCharset);
        
    },
    get action(){
        return this.getAttribute('action');
        
    },
    set action(action){
        this.setAttribute('action', action);
        
    },
    get elements() {
        return this.getElementsByTagName("*");
        
    },
    get enctype(){
        return this.getAttribute('enctype');
        
    },
    set enctype(enctype){
        this.setAttribute('enctype', enctype);
        
    },
    get length() {
        return this.elements.length;
        
    },
    get method(){
        return this.getAttribute('method');
        
    },
    set method(action){
        this.setAttribute('method', action);
        
    },
	get name() {
	    return this.getAttribute("name"); 
	    
    },
	set name(val) { 
	    return this.setAttribute("name",val); 
	    
    },
	get target() { 
	    return this.getAttribute("target"); 
	    
    },
	set target(val) { 
	    return this.setAttribute("target",val); 
	    
    },
	submit:function(){
	    __submit__(this);
	    
    },
	reset:function(){
	    __reset__(this);
	    
    },
    onsubmit:function(){
        var v;
        if ((v = __eval__(this.getAttribute('onsubmit')||'', this)) != false) {
            // this.submit();
        }
        return v;
    },
    onreset:function(){
        var v;
        if ((v = __eval__(this.getAttribute('onreset')||'', this)) != false) {
            this.reset();
        }
        return v;
    }
});

// $w.HTMLFormElement	= HTMLFormElement;

/**
 * Form Submissions
 * 
 * This code is borrow largely from jquery.params and jquery.form.js
 * 
 * formToArray() gathers form element data into an array of objects that can
 * be passed to any of the following ajax functions: $.get, $.post, or load.
 * Each object in the array has both a 'name' and 'value' property.  An example of
 * an array for a simple login form might be:
 *
 * [ { name: 'username', value: 'jresig' }, { name: 'password', value: 'secret' } ]
 *
 * It is this array that is passed to pre-submit callback functions provided to the
 * ajaxSubmit() and ajaxForm() methods.
 *
 * The semantic argument can be used to force form serialization in semantic order.
 * This is normally true anyway, unless the form contains input elements of type='image'.
 * If your form must be submitted with name/value pairs in semantic order and your form
 * contains an input of type='image" then pass true for this arg, otherwise pass false
 * (or nothing) to avoid the overhead for this logic.
 *
 *
 * @name formToArray
 * @param semantic true if serialization must maintain strict semantic ordering of elements (slower)
 * @type Array<Object>
 */
var __formToArray__ = function(form, semantic, boundary) {
    var array = [],
        elements = semantic ? form.getElementsByTagName('*') : form.elements,
        element,
        i,j,imax, jmax,
        name,
        value;
        
    if (!elements) 
        return array;
    
    imax = elements.length;
    for(i=0; i < imax; i++) {
        element = elements[i];
        name = element.name;
        if (!name) 
            continue;

        if (semantic && form.clk && element.type == "image") {
            // handle image inputs on the fly when semantic == true
            if(!element.disabled && form.clk == element) {
                if (form.clk_x) { 
                    array.push({
                        name: name+'.x', 
                        value: form.clk_x
                    });
                }
                if (form.clk_y) {
                    array.push({
                        name: name+'.y', 
                        value: form.clk_y
                    });
                }
            }
            continue;
        }

        value = __fieldValue__(element, true);
        if (value && value.constructor == Array) {
            jmax = value.length;
            for(j=0; j < jmax; j++){
                // FIX: handle uploads with the same name
                array.push({name: name, value: value[j]});
            }
        } else if (value !== null && typeof value != 'undefined'){
            array.push({name: name, value: value});
            if(element.type == "file") {
                var v = array[array.length-1];
                v.filename = element.value || null;
            }
        }
    }

    if (!semantic && form.clk) {
        // input type=='image' are not found in elements array! handle them here
        elements = form.getElementsByTagName("input");
        imax = imax=elements.length;
        for(i=0; i < imax; i++) {
            element = elements[i];
            name = element.name;
            if(name && !element.disabled && element.type == "image" && form.clk == element)
                if (form.clk_x)
                    array.push({name: name+'.x', value: form.clk_x});
                if (form.clk_y)
                    array.push({name: name+'.y', value: form.clk_y});
        }
    }
    return array;
};


/**
 * Serializes form data into a 'submittable' string. This method will return a string
 * in the format: name1=value1&amp;name2=value2
 *
 * The semantic argument can be used to force form serialization in semantic order.
 * If your form must be submitted with name/value pairs in semantic order then pass
 * true for this arg, otherwise pass false (or nothing) to avoid the overhead for
 * this logic (which can be significant for very large forms).
 *
 *
 * @name formSerialize
 * @param semantic true if serialization must maintain strict semantic ordering of elements (slower)
 * @type String
 */
var __formSerialize__ = function(form, semantic,boundary) {
    //hand off to param for proper encoding
    v = __param__(__formToArray__(form, semantic,boundary),boundary);
    // print("v",v);
    return v;
};
this.__formSerialize__ = __formSerialize__;

/**
 * Serializes all field elements inputs Array into a query string.
 * This method will return a string in the format: name1=value1&amp;name2=value2
 *
 * The successful argument controls whether or not serialization is limited to
 * 'successful' controls (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
 * The default value of the successful argument is true.
 *
 *
 * @name fieldSerialize
 * @param successful true if only successful controls should be serialized (default is true)
 * @type String
 */
var __fieldSerialize__ = function(inputs, successful) {
    var array = [],
        input,
        name,
        value,
        i,j, imax, jmax;
        
    imax = inputs.length;
    for(i=0; i<imax; i++){
        input = inputs[i];
        name = input.name;
        if (!name) 
            return;
        value = __fieldValue__(input, successful);
        if (value && value.constructor == Array) {
            jmax = value.length;
            for (j=0; j < max; j++){
                array.push({
                    name: name, 
                    value: value[j]
                });
            }
        }else if (value !== null && typeof value != 'undefined'){
            array.push({
                name: input.name, 
                value: value
            });
        }
    };
    //hand off  for proper encoding
    return __param__(array);
};


/**
 * Returns the value(s) of the element in the matched set.  For example, consider the following form:
 *
 *
 * The successful argument controls whether or not the field element must be 'successful'
 * (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
 * The default value of the successful argument is true.  If this value is false the value(s)
 * for each element is returned.
 *
 * Note: This method *always* returns an array.  If no valid value can be determined the
 *       array will be empty, otherwise it will contain one or more values.
 *
 *
 * @name fieldValue
 * @param Boolean successful true if only the values for successful controls 
 *        should be returned (default is true)
 * @type Array<String>
 */
var __fieldValues__ = function(inputs, successful) {
    var i, 
        imax = inputs.length,
        element,
        values = [],
        value;
    for (i=0; i < imax; i++) {
        element = inputs[i];
        value = __fieldValue__(element, successful);
        if (value === null || typeof value == 'undefined' || 
            (value.constructor == Array && !value.length))
            continue;
        value.constructor == Array ? 
            Array.prototype.push(values, value) : 
            values.push(value);
    }
    return values;
};

/**
 * Returns the value of the field element.
 *
 * The successful argument controls whether or not the field element must be 'successful'
 * (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
 * The default value of the successful argument is true.  If the given element is not
 * successful and the successful arg is not false then the returned value will be null.
 *
 * Note: If the successful flag is true (default) but the element is not successful, the return will be null
 * Note: The value returned for a successful select-multiple element will always be an array.
 * Note: If the element has no value the return value will be undefined.
 *
 * @name fieldValue
 * @param Element el The DOM element for which the value will be returned
 * @param Boolean successful true if value returned must be for a successful controls (default is true)
 * @type String or Array<String> or null or undefined
 */
var __fieldValue__ = function(element, successful) {
    var name = element.name, 
        type = element.type, 
        tag = element.tagName.toLowerCase(),
        index,
        array,
        options,
        option,
        one,
        i, imax,
        value;
    if (typeof successful == 'undefined') successful = true;

    // NOTE: changed to default to first selected: could do this when building the DOM?
    // Probably, but a little unclear ...

    if (successful && (!name || element.disabled || type == 'reset' || type == 'button' ||
             (type == 'checkbox' || type == 'radio') &&  !element.checked || 
             (type == 'submit' || type == 'image') && 
             element.form && element.form.clk != element || (false && tag == 'select' && 
             element.selectedIndex == -1)))
            return null;

    if (tag == 'select') {
        index = element.selectedIndex;
        // print("i",index);
        if (index < 0) 
            // return null;
            index = 0;
        array = [];
        options = element.options;
        one = (type == 'select-one');
        imax = (one ? index+1 : options.length);
        i = (one ? index : 0);
        for( i; i < imax; i++) {
            option = options[i];
            if (option && option.selected) {
                value = option.value;
                if (one) 
                    return value;
                array.push(value);
            }
        }
        if (array.length === 0) {
            if (element.options[0]) {
                array.push( element.options[0].value );
            }
        }
        return array;
    }
    
    // print("**",tag,type,element.value,element.innerText);

    if (type == "file") {
        return Ruby.File.basename(element.value);
    }
    
    if (tag == "textarea") {
        return element.innerText;
    }
    
    return element.value;
};


/**
 * Clears the form data.  Takes the following actions on the form's input fields:
 *  - input text fields will have their 'value' property set to the empty string
 *  - select elements will have their 'selectedIndex' property set to -1
 *  - checkbox and radio inputs will have their 'checked' property set to false
 *  - inputs of type submit, button, reset, and hidden will *not* be effected
 *  - button elements will *not* be effected
 *
 *
 * @name clearForm
 */
var __clearForm__ = function(form) {
    var i, 
        j, jmax,
        elements,
        resetable = ['input','select','textarea'];
    for(i=0; i<resetable.lenth; i++){
        elements = form.getElementsByTagName(resetable[i]);
        jmax = elements.length;
        for(j=0;j<jmax;j++){
            __clearField__(elements[j]);
        }
    }
};

/**
 * Clears the selected form element.  Takes the following actions on the element:
 *  - input text fields will have their 'value' property set to the empty string
 *  - select elements will have their 'selectedIndex' property set to -1
 *  - checkbox and radio inputs will have their 'checked' property set to false
 *  - inputs of type submit, button, reset, and hidden will *not* be effected
 *  - button elements will *not* be effected
 *
 * @name clearFields
 */
var __clearField__ = function(element) {
    var type = element.type, 
        tag = element.tagName.toLowerCase();
    if (type == 'text' || type == 'password' || tag == 'textarea')
        element.value = '';
    else if (type == 'checkbox' || type == 'radio')
        element.checked = false;
    else if (tag == 'select')
        element.selectedIndex = -1;
};


// Serialize an array of key/values into a query string
var __param__= function( array, boundary ) {
    var serialized = [];
    if(boundary) {
        for(i=0; i<array.length; i++){
            if (array[i].filename === null) {
                continue;
            }
            serialized.push( "--"+boundary + "\r\n" );
            var fn = array[i].filename ? '; filename="'+array[i].value+'"' : "";
            if (fn) {
                var mime_type = "text/plain";
                var transfer_encoding;
                if (array[i].filename.match(/\.jpe?g$/)) {
                    mime_type = "image/jpeg";
                    transfer_encoding = "base64";
                }
                var content;
                if (transfer_encoding === "base64") {
                    Ruby.require("base64");
                    content = Ruby.eval("lambda { |fn| Base64.encode64(File.read(fn)) }").call(array[i].filename);
                } else {
                    content = Ruby.File.read(array[i].filename);
                }
                // FIX: better mime types
                array[i].value = [ "Content-Type: "+mime_type ];
                if(transfer_encoding) {
                    array[i].value.push("Content-Transfer-Encoding: "+transfer_encoding);
                }
                array[i].value.push("Content-Length: "+content.length);
                array[i].value.push("");
                array[i].value.push(content);
                array[i].value = array[i].value.join("\r\n");
            }
            serialized.push('Content-Disposition: form-data; name="'+array[i].name+'"'+fn+'\r\n\r\n');
            serialized.push(array[i].value);
            serialized.push( "\r\n" );
        }
        serialized.push( "--"+boundary + "--\r\n" );
        var v = serialized.join("");
        // print("vvvv",v);
        return v;
    } else {
        // Serialize the key/values
        for(i=0; i<array.length; i++){
            serialized[ serialized.length ] = 
                encodeURIComponent(array[i].name) + '=' + 
                encodeURIComponent(array[i].value);
        }

        // Return the resulting serialization
        return serialized.join("&").replace(/%20/g, "+");
    }
};

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
