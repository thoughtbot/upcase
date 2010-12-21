$debug("Defining HTMLElement");
/*
* HTMLElement - DOM Level 2
*/
var HTMLElement = function(ownerDocument) {
    this.DOMElement = DOMElement;
    this.DOMElement(ownerDocument);
    
    this.$css2props = null;
};
HTMLElement.prototype = new DOMElement;
__extend__(HTMLElement.prototype, {

		get className() { 
		    return this.getAttribute("class")||''; 
	    },
		set className(value) { 
		    return this.setAttribute("class",trim(value)); 
		    
	    },
		get dir() { 
		    return this.getAttribute("dir")||"ltr"; 
		    
	    },
		set dir(val) { 
		    return this.setAttribute("dir",val); 
		    
	    },
		get id(){  
		    return this.getAttribute('id'); 
		    
	    },
		set id(id){  
		    this.setAttribute('id', id); 
            
	    },
		get innerHTML(){  
		    return this.childNodes.xml; 
		    
	    },
		set innerHTML(html){
		    //Should be replaced with HTMLPARSER usage
            //$debug('SETTING INNER HTML ('+this+'+'+html.substring(0,64));
            var doc = new HTMLDocument(this.ownerDocument.implementation,
                                        this.ownerDocument._parentWindow,
                                        "");
// print("innerHTML",html);
// try { throw new Error; } catch(e) { print(e.stack); }
            var docstring = '<html><head></head><body>'+
                '<envjs_1234567890 xmlns="envjs_1234567890">'
                +html+
                '</envjs_1234567890>'+
                '</body></html>';
            doc.in_inner_html = true;
            this.ownerDocument._parentWindow.parseHtmlDocument(docstring,doc,null,null,true);
            var parent = doc.body.childNodes[0];
			while(this.firstChild != null){
			    this.removeChild( this.firstChild );
			}
			var importedNode;

            var pn = this;
            while(pn.parentNode) {
                pn = pn.parentNode;
            }
            // print(this,pn,this.ownerDocument);
            try{
                if (pn === this.ownerDocument) {
                    this.ownerDocument.in_inner_html = true;
                    // print("yup");
                }
			    while(parent.firstChild != null){
	            importedNode = this.importNode( 
	                parent.removeChild( parent.firstChild ), true);
			        this.appendChild( importedNode );   
		        }
            } finally {
                if (pn === this.ownerDocument) {
                    // print("nope");
                    this.ownerDocument.in_inner_html = false;
                }
            }
		    //Mark for garbage collection
		    doc = null;
		},
        get innerText(){
            return __recursivelyGatherText__(this);
        },
        set innerText(newText){
			while(this.firstChild != null){
			    this.removeChild( this.firstChild );
			}
            var text = this.ownerDocument.createTextNode(newText);
            this.appendChild(text);
        },
		get lang() { 
		    return this.getAttribute("lang"); 
		    
	    },
		set lang(val) { 
		    return this.setAttribute("lang",val); 
		    
	    },
		get offsetHeight(){
		    return Number(this.style["height"].replace("px",""));
		},
		get offsetWidth(){
		    return Number(this.style["width"].replace("px",""));
		},
		offsetLeft: 0,
		offsetRight: 0,
		offsetTop: 0,
		get offsetParent(){
		    /* TODO */
		    return;
	    },
		set offsetParent(element){
		    /* TODO */
		    return;
	    },
		scrollTop: 0,
		scrollHeight: 0,
		scrollWidth: 0,
		scrollLeft: 0, 
		scrollRight: 0,
		get style(){
		    if(this.$css2props === null){
	            this.$css2props = new CSS2Properties(this);
	        }
	        return this.$css2props;
		},
        set style(values){
		    __updateCss2Props__(this, values);
        },
		setAttribute: function (name, value) {
            DOMElement.prototype.setAttribute.apply(this,[name, value]);
		    if (name === "style") {
		        __updateCss2Props__(this, value);
		    }
		},
		get title() { 
		    return this.getAttribute("title"); 
		    
	    },
		set title(value) { 
		    return this.setAttribute("title", value); 
		    
	    },
		get tabIndex(){
            var ti = this.getAttribute('tabindex');
            if(ti!==null)
                return Number(ti);
            else
                return 0;
        },
        set tabIndex(value){
            if(value===undefined||value===null)
                value = 0;
            this.setAttribute('tabindex',Number(value));
        },
		//Not in the specs but I'll leave it here for now.
		get outerHTML(){ 
		    return this.xml; 
		    
	    },
	    scrollIntoView: function(){
	        /*TODO*/
	        return;
	    
        },

		onclick: function(event){
            return __eval__(this.getAttribute('onclick')||'', this);
	    },
        

		ondblclick: function(event){
            return __eval__(this.getAttribute('ondblclick')||'', this);
	    },
		onkeydown: function(event){
            return __eval__(this.getAttribute('onkeydown')||'', this);
	    },
		onkeypress: function(event){
            return __eval__(this.getAttribute('onkeypress')||'', this);
	    },
		onkeyup: function(event){
            return __eval__(this.getAttribute('onkeyup')||'', this);
	    },
		onmousedown: function(event){
            return __eval__(this.getAttribute('onmousedown')||'', this);
	    },
		onmousemove: function(event){
            return __eval__(this.getAttribute('onmousemove')||'', this);
	    },
		onmouseout: function(event){
            return __eval__(this.getAttribute('onmouseout')||'', this);
	    },
		onmouseover: function(event){
            return __eval__(this.getAttribute('onmouseover')||'', this);
	    },
		onmouseup: function(event){
            return __eval__(this.getAttribute('onmouseup')||'', this);
	    },

    appendChild: function( newChild, refChild ) {
        var rv = DOMElement.prototype.appendChild.apply(this, arguments);
        var node = newChild;
        var pn = this;
        while(pn.parentNode) {
            pn = pn.parentNode;
        }
        if(pn === node.ownerDocument) { 
           __exec_script_tags__(newChild);
        }
        return rv;
    }
});

var __exec_script_tags__ = function(node) {
    var $env =  __ownerDocument__(node)._parentWindow.$envx;
    var doc = __ownerDocument__(node);
    var type = ( node.type === null ) ? "text/javascript" : node.type;
    // print("check exec",node,node.ownerDocument.in_inner_html);
    // print(node,node.childNodes.length);
    if(node.nodeName.toLowerCase() == 'script' && type == "text/javascript"){
        // print("check",node,node.src,node.text,node.ownerDocument.in_inner_html,doc.parentWindow,node.executed);
        if (node.ownerDocument.in_inner_html) {
            //print("ignore",node);
            node.executed = true;
        } else if (doc.parentWindow &&
                   !node.ownerDocument.in_inner_html &&
                   !node.executed && (
                       (node.src && !node.src.match(/^\s*$/)) ||
                        (node.text && !node.text.match(/^\s*$/))
                   ) ) {
            node.executed = true;
            //p.replaceEntities = true;
            //print("exec",node);
            var okay = $env.loadLocalScript(node, null);
            // only fire event if we actually had something to load
            if (node.src && node.src.length > 0){
                var event = doc.createEvent();
                event.initEvent( okay ? "load" : "error", false, false );
                node.dispatchEvent( event, false );
            }
        }
    }
    for(var i=0; i < node.childNodes.length; i++) {
        __exec_script_tags__(node.childNodes[i]);
    }
};

var __recursivelyGatherText__ = function(aNode) {
    var accumulateText = "";
    var idx; var n;
    for (idx=0;idx < aNode.childNodes.length;idx++){
        n = aNode.childNodes.item(idx);
        if(n.nodeType == DOMNode.TEXT_NODE)
            accumulateText += n.data;
        else
            accumulateText += __recursivelyGatherText__(n);
    }

    return accumulateText;
};
    
var __eval__ = function(script,node){
    if (script == "")
        return undefined;
    try {
        var scope = node;
        var __scopes__ = [];
        var original = script;
        if(scope) {
            // script = "(function(){return eval(original)}).call(__scopes__[0])";
            script = "return (function(){"+original+"}).call(__scopes__[0])";
            while(scope) {
                __scopes__.push(scope);
                scope = scope.parentNode;
                script = "with(__scopes__["+(__scopes__.length-1)+"] ){"+script+"};";
            }
        }
        script = "function(original,__scopes__){"+script+"}";
        // print("scripta",script);
        // print("scriptb",original);
        var original_script_window = $master.first_script_window;
        if ( !$master.first_script_window ) {
            // $master.first_script_window = window;
        }
        // FIX!!!
        var $inner = node.ownerDocument._parentWindow["$inner"];
        var result = $master.evaluate(script,$inner)(original,__scopes__);
        // $master.first_script_window = original_script_window;
        return result;
    }catch(e){
        $warn("Exception during on* event eval: "+e);
        throw e;
    }
};

var __updateCss2Props__ = function(elem, values){
    if(elem.$css2props === null){
        elem.$css2props = new CSS2Properties(elem);
    }
    __cssTextToStyles__(elem.$css2props, values);
};

var __registerEventAttrs__ = function(elm){
    if(elm.hasAttribute('onclick')){ 
        elm.addEventListener('click', elm.onclick ); 
    }
    if(elm.hasAttribute('ondblclick')){ 
        elm.addEventListener('dblclick', elm.onclick ); 
    }
    if(elm.hasAttribute('onkeydown')){ 
        elm.addEventListener('keydown', elm.onclick ); 
    }
    if(elm.hasAttribute('onkeypress')){ 
        elm.addEventListener('keypress', elm.onclick ); 
    }
    if(elm.hasAttribute('onkeyup')){ 
        elm.addEventListener('keyup', elm.onclick ); 
    }
    if(elm.hasAttribute('onmousedown')){ 
        elm.addEventListener('mousedown', elm.onclick ); 
    }
    if(elm.hasAttribute('onmousemove')){ 
        elm.addEventListener('mousemove', elm.onclick ); 
    }
    if(elm.hasAttribute('onmouseout')){ 
        elm.addEventListener('mouseout', elm.onclick ); 
    }
    if(elm.hasAttribute('onmouseover')){ 
        elm.addEventListener('mouseover', elm.onclick ); 
    }
    if(elm.hasAttribute('onmouseup')){ 
        elm.addEventListener('mouseup', elm.onclick ); 
    }
    return elm;
};
	
// non-ECMA function, but no other way for click events to enter env.js
var  __click__ = function(element){
    var event = new Event({
      target:element,
      currentTarget:element
    });
    event.initEvent("click");
    element.dispatchEvent(event);
};
var __submit__ = function(element){
	var event = new Event({
	  target:element,
	  currentTarget:element
	});
	event.initEvent("submit");
	element.dispatchEvent(event);
};
var __focus__ = function(element){
	var event = new Event({
	  target:element,
	  currentTarget:element
	});
	event.initEvent("focus");
	element.dispatchEvent(event);
};
var __blur__ = function(element){
	var event = new Event({
	  target:element,
	  currentTarget:element
	});
	event.initEvent("blur");
	element.dispatchEvent(event);
};

// $w.HTMLElement = HTMLElement;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
