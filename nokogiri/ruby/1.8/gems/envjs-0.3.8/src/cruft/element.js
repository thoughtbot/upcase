/*
* HTMLElement - DOM Level 2
*/
$w.__defineGetter__("HTMLElement", function(){
  return function(){
    throw new Error("Object cannot be created in this context");
  };
});

var Element = function(node){
  var $dom = node, 
      $id = createGUID();
      
$w.__defineGetter__("Element", function(){
	var $dom, $id;
	return function(elem){
	  $dom = elem;
	  $id = createGUID();
	  __extend__(this, new DOMNode($dom));
		
		// A lot of the methods defined below belong in HTML specific
		// subclasses.  This is already unwieldy since most of these
		//methods are meant for general xml consumption
		__extend__(this, {
  		get nodeName(){
  			return this.tagName;
  		},
  		get tagName(){
  			return $dom.getTagName().toUpperCase();
  		},
  		toString: function(){
  			return "<" + this.tagName + (this.id ? "#" + this.id : "" ) + ">";
  		},
  		get outerHTML(){
  			var ret = "<" + this.tagName, attr = this.attributes;
  			
  			for ( var i in attr )
  				ret += " " + i + "='" + attr[i] + "'";
  				
  			if ( this.childNodes.length || this.nodeName == "SCRIPT" )
  				ret += ">" + this.childNodes.outerHTML + 
  					"</" + this.tagName + ">";
  			else
  				ret += "/>";
  			
  			return ret;
  		},
  		
  		get attributes(){
  			var attr = {}, attrs = $dom.getAttributes();
  			for ( var i = 0; i < attrs.getLength(); i++ ){
  				attr[ attrs.item(i).nodeName ] = attrs.item(i).nodeValue;
				}return attr;
  		},
  		
  		get innerHTML(){
  			return this.childNodes.outerHTML;	
  		},
  		set innerHTML(html){
  			html = html.replace(/<\/?([A-Z]+)/g, function(m){
  				return m.toLowerCase();
  			}).replace(/&nbsp;/g, " ");
  			
  			var dom = new DOMParser().parseFromString("<wrap>" + html + "</wrap>");
  			var nodes = this.ownerDocument.importNode( dom.documentElement,  true ).childNodes;
  				
  			while (this.firstChild){
  				this.removeChild( this.firstChild );
				}
  			
  			for ( var i = 0; i < nodes.length; i++ )
  				this.appendChild( nodes[i] );
  		},
  		
  		get textContent(){
  			function nav(nodes){
  				var str = "";
  				for ( var i = 0; i < nodes.length; i++ ){
  					if ( nodes[i].nodeType == 3 ){
  						str += nodes[i].nodeValue;
  					}else if ( nodes[i].nodeType == 1 ){
  						str += nav(nodes[i].childNodes);
  					}
  				} return str;
  			} return nav(this.childNodes);
  		},
  		set textContent(text){
  			while (this.firstChild)
  				this.removeChild( this.firstChild );
  			this.appendChild( this.ownerDocument.createTextNode(text));
  		},
  		
  		style: {},
  		clientHeight: 0,
  		clientWidth: 0,
  		offsetHeight: 0,
  		offsetWidth: 0,
  		
  		get disabled() {
  			var val = this.getAttribute("disabled");
  			return val != "false" && !!val;
  		},
  		set disabled(val) { return this.setAttribute("disabled",val); },
  		
  		get checked() {
  			var val = this.getAttribute("checked");
  			return val != "false" && !!val;
  		},
  		set checked(val) { return this.setAttribute("checked",val); },
  		
  		get selected() {
  			if ( !this._selectDone ) {
  				this._selectDone = true;
  				
  				if ( this.nodeName == "OPTION" && !this.parentNode.getAttribute("multiple") ) {
  					var opt = this.parentNode.getElementsByTagName("option");
  					
  					if ( this == opt[0] ) {
  						var select = true;
  						
  						for ( var i = 1; i < opt.length; i++ ){
  							if ( opt[i].selected ) {
  								select = false;
  								break;
  							}
  						}
  						if ( select ){ this.selected = true; }
  					}
  				}
  			}
  			
  			var val = this.getAttribute("selected");
  			return val != "false" && !!val;
  		},
  		set selected(val) { return this.setAttribute("selected",val); },
  
  		get className() { return this.getAttribute("class") || ""; },
  		set className(val) {
  			return this.setAttribute("class",
  				val.replace(/(^\s*|\s*$)/g,""));
  		},
  		
  		get type() { return this.getAttribute("type") || ""; },
  		set type(val) { return this.setAttribute("type",val); },
  
  		get defaultValue() { return this.getAttribute("defaultValue") || ""; },
  		set defaultValue(val) { return this.setAttribute("defaultValue",val); },
  
  		get value() { return this.getAttribute("value") || ""; },
  		set value(val) { return this.setAttribute("value",val); },
  		
  		get src() { return this.getAttribute("src") || ""; },
  		set src(val) { return this.setAttribute("src",val); },
  		
  		get id() { return this.getAttribute("id") || ""; },
  		set id(val) { return this.setAttribute("id",val); },
  		
  		getAttribute: function(name){
  			return $dom.hasAttribute(name) ?
  				new String( $dom.getAttribute(name) ) :
  				null;
  		},
  		setAttribute: function(name,value){
  			$dom.setAttribute(name,value);
  		},
  		removeAttribute: function(name){
  			$dom.removeAttribute(name);
  		},
  		
  		get childNodes(){
  			return new DOMNodeList( $dom.getChildNodes() );
  		},
  		get firstChild(){
  			return makeNode( $dom.getFirstChild() );
  		},
  		get lastChild(){
  			return makeNode( $dom.getLastChild() );
  		},
  		appendChild: function(node){
  		  //Because the dom implementation is private in scope now,
  		  //we will need to fix these to use some innerHtml etc
  		  //if required
  			$dom.appendChild( $nodeImplCache[node.__guid__] );
  		},
  		insertBefore: function(node,before){
  			$dom.insertBefore( $nodeImplCache[node.__guid__], before ? $nodeImplCache[before.__guid__] : before );
  			
  			execScripts( node );
  			
  			function execScripts( node ) {
  				if ( node.nodeName == "SCRIPT" ) {
  					if ( !node.getAttribute("src") ) {
  						eval.call( window, node.textContent );
  					}
  				} else {
  					var scripts = node.getElementsByTagName("script");
  					for ( var i = 0; i < scripts.length; i++ ) {
  						execScripts( node );
  					}
  				}
  			}
  		},
  		removeChild: function(node){
  			$dom.removeChild( $nodeImplCache[node.__guid__] );
  		},
  
  		getElementsByTagName: function(name){
  		  // why can't we just do ?: 
  			//var elems = $dom.getElementsByTagName(name), ret = [];
  			var elems = $dom.getElementsByTagName("*"), ret = [];
  			ret.item = function(i){ return this[i]; };
  			ret.getLength = function(){ return this.length; };
  			for ( var i = 0; i < elems.length; i++ ) {
  				var elem = elems.item(i);
  				if ( elem.getAttribute("name") == name )
  					ret.push( elem );
  			}return new DOMNodeList( ret );
			},
  		
  		addEventListener: window.addEventListener,
  		removeEventListener: window.removeEventListener,
  		dispatchEvent: window.dispatchEvent,
  		
  		click: function(){
  			var event = document.createEvent();
  			event.initEvent("click");
  			this.dispatchEvent(event);
  		},
  		submit: function(){
  			var event = document.createEvent();
  			event.initEvent("submit");
  			this.dispatchEvent(event);
  		},
  		focus: function(){
  			var event = document.createEvent();
  			event.initEvent("focus");
  			this.dispatchEvent(event);
  		},
  		blur: function(){
  			var event = document.createEvent();
  			event.initEvent("blur");
  			this.dispatchEvent(event);
  		},
  		get contentWindow(){
  			return this.nodeName == "IFRAME" ? {
  				document: this.contentDocument
  			} : null;
  		},
  		get contentDocument(){
  			if ( this.nodeName == "IFRAME" ) {
  				if ( !this._doc )
  					this._doc = HTMLtoDOM("<html><head><title></title></head><body></body></html>");
  				return this._doc;
  			} else { return null; }
    	},
  		get __guid__(){return $id;}
		});
		
	  //All this constructor stuff belond in the HTML subclasses
	  //and even more generally in the HTML specific element
	  //subclass otherwise its going to become a mess
  	this.style = {
  		get opacity(){ return this._opacity; },
  		set opacity(val){ this._opacity = val + ""; }
  	};
		
		// Load CSS info
		var styles = (this.getAttribute("style") || "").split(/\s*;\s*/);
		for ( var i = 0; i < styles.length; i++ ) {
			var style = styles[i].split(/\s*:\s*/);
			if ( style.length == 2 )
				this.style[ style[0] ] = style[1];
		}
		
		if ( this.nodeName == "FORM" ) {
			this.__defineGetter__("elements", function(){
				return this.getElementsByTagName("*");
			});
			this.__defineGetter__("length", function(){
				var elems = this.elements;
				for ( var i = 0; i < elems.length; i++ ) {
					this[i] = elems[i];
				}
				return elems.length;
			});
		}

		if ( this.nodeName == "SELECT" ) {
			this.__defineGetter__("options", function(){
				return this.getElementsByTagName("option");
			});
		}

		this.defaultValue = this.value;
		return this;
	};
});