/*
*	dom.js
*
*	DOM Level 2 /DOM level 3 (partial)
*	
*	The DOMDocument is now private in scope but you can create new
*	DOMDocuments via document.implementation.createDocument which
*	now also exposes the DOM Level 3 function 'load(uri)'.
*
*/

  // Helper method for generating the right
	// DOM objects based upon the type
	/*var obj_nodes = {};

	function makeNode(node){
	  $log("Making Node");
		if ( node ) {
			if ( !obj_nodes[node]){
				obj_nodes[node] = node.getNodeType() == 1 ? new DOMElement( node ) :
					(node.getNodeType() == 8 ? new DOMComment( node ) : new DOMNode( node )) ;
  		}
			return obj_nodes[node];
		} else
			return null;
	};*/
	// Helper method for generating the right
	// DOM objects based upon the type
	
	var $nodeCache = {};//caches a reference to our implementation of the node
	var $nodeImplCache = {};//reverse look-up : caches a reference to the env supplied implementors dom node
	var $guid = (-1)*Math.pow(2,31);
  function createGUID(){
    return String(++$guid);
  };
	
	function makeNode(node){
		if ( node ) {
			if ( !$nodeCache[ $env.hashCode(node) ] ){
				if( node.getNodeType() == 1){
				  $nodeCache[$env.hashCode(node)] = new DOMElement( node );
				  $nodeImplCache[$nodeCache[$env.hashCode(node)].__guid__] = node;
				}else{
				  if(node.getNodeType() == 8){
				    $nodeCache[$env.hashCode(node)] = new DOMComment( node );
				    $nodeImplCache[$nodeCache[$env.hashCode(node)].__guid__] = node;
				  }else{
				    $nodeCache[$env.hashCode(node)] = new DOMNode( node );
				    $nodeImplCache[$nodeCache[$env.hashCode(node)].__guid__] = node;
			    }
				}
			}
			return $nodeCache[$env.hashCode(node)];
		} else{ 
		  return null;
	  }
	}
	
	//DOMImplementation
	var DOMImplementation = function(){
		return {
			hasFeature: function(feature, version){
				//TODO
				return false;
			},
			createDocumentType: function(qname, publicId, systemId){
				//TODO
			},
			createDocument:function(namespace, qname, docType){
				return new DOMDocument();
			},
			getFeature:function(feature, version){
				//TODO or TODONT?
			}
		};
	};
	
	// DOM Document
$w.__defineGetter__('DOMDocument', function(){
  var $dom, $id, $url;
  return function(){
    $id = createGUID();
    return __extend__(this,{
  		load: function(url){
  		  $log("Loading url into DOM Document: "+ url + " - (Asynch? "+$w.document.async+")");
  			var _this = this;
  			var xhr = new XMLHttpRequest();
  			xhr.open("GET", url, $w.document.async);
  			xhr.onreadystatechange = function(){
				  try{
					  _this.loadXML(xhr.responseText);
				  }catch(e){
				    $error("Error Parsing XML - ",e);
	          _this.loadXML(
	            "<html><head></head><body>"+
	              "<h1>Parse Error</h1>"+
	              "<p>"+e.toString()+"</p>"+  
	            "</body></html>");
			    }
  			  $url = url;
      		if ( !$nodeCache[$dom] ){
      			$nodeCache[$dom] = _this;
    			}
  				$log("Sucessfully loaded document.");
  				var event = document.createEvent();
  				event.initEvent("load");
  				$w.dispatchEvent( event );
  			};
  			xhr.send();
  		},
  		//This is actuall IE specific but still convenient
  		loadXML: function(xmlString){
  		  $dom = $env.parseXML(xmlString);
  		  return this;
  		},
  		get nodeType(){
  			return 9;
  		},
  		createTextNode: function(text){
  			return makeNode( $dom.createTextNode(
  				text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")) );
  		},
  		createElement: function(name){
  			return makeNode( $dom.createElement(name.toLowerCase()) );
  		},
  		getElementsByTagName: function(name){
  			return new DOMNodeList( 
  			  $dom.getElementsByTagName(
  				  name.toLowerCase()) );
  		},
  		getElementsByName: function(name){
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
  		getElementById: function(id){
  		  // why can't we just do ?: 
  		  //return makeNode($dom.getElementById(id));
  		  var elems = $dom.getElementsByTagName("*");
  			
  			for ( var i = 0; i < elems.length; i++ ) {
  				var elem = elems.item(i);
  				if ( elem.getAttribute("id") == id )
  					return makeNode(elem);
  			}
  			
  			return null;
  		},
  		get body(){
  			return this.getElementsByTagName("body")[0];
  		},
  		get documentElement(){
  			return makeNode( $dom.getDocumentElement() );
  		},
  		get ownerDocument(){
  			return null;
  		},
  		addEventListener: window.addEventListener,
  		removeEventListener: window.removeEventListener,
  		dispatchEvent: window.dispatchEvent,
  		get nodeName() {
  			return "#document";
  		},
  		importNode: function(node, deep){
  		  //need to replace this with some innerHtml magic
  		  //because the ._dom is private in scope now
  			return makeNode( $dom.importNode($nodeImplCache[node.__guid__], deep) );
  		},
  		toString: function(){
  			return "Document" + 
  			  (typeof $url == "string" ? ": " + $url : "");
  		},
  		get innerHTML(){
  			return this.documentElement.outerHTML;
  		},
  		
  		get defaultView(){
  			return {
  				getComputedStyle: function(elem){
  					return {
  						getPropertyValue: function(prop){
  							prop = prop.replace(/\-(\w)/g,function(m,c){
  								return c.toUpperCase();
  							});
  							var val = elem.style[prop];
  							if ( prop === "opacity" && val === "" ){
  								val = "1";
  							}return val;
  						}
  					};
  				}
  			};
  		},
  		
  		createEvent: function(){
  			return {
  				type: "",
  				initEvent: function(type){
  					this.type = type;
  				}
  			};
  		},
  		get __guid__(){return $id;}
    });
  };
});

function getDocument(node){
	return $nodeCache[node];
}
	
	// DOM NodeList

$w.__defineGetter__("DOMNodeList", function(){
  var $dom;
  return function(list){
		$dom = list;
		this.length = list.getLength();
		
		for ( var i = 0; i < this.length; i++ ) {
			var node = list.item(i);
			this[i] = makeNode( node );
		}
		return __extend__(this,{
  		toString: function(){
  			return "[ " +
  				Array.prototype.join.call( this, ", " ) + " ]";
  		},
  		get outerHTML(){
  			return Array.prototype.map.call(
  				this, function(node){return node.outerHTML;}).join('');
  		}
		});
	};
});
	
	// DOM Node
	
$w.__defineGetter__("DOMNode", function(){
  var $dom, $id;
  return function(node){
    $id = createGUID();
	  $dom = node;
	  return __extend__(this, {
  		get nodeType(){
  			return $dom.getNodeType();
  		},
  		get nodeValue(){
  			return $dom.getNodeValue();
  		},
  		get nodeName() {
  			return $dom.getNodeName();
  		},
  		get childNodes(){
  			return new DOMNodeList( $dom.getChildNodes() );
  		},
  		cloneNode: function(deep){
  			return makeNode( $dom.cloneNode(deep) );
  		},
  		get ownerDocument(){
  			return getDocument( $dom.ownerDocument );
  		},
  		get documentElement(){
  			return makeNode( $dom.documentElement );
  		},
  		get parentNode() {
  			return makeNode( $dom.getParentNode() );
  		},
  		get nextSibling() {
  			return makeNode( $dom.getNextSibling() );
  		},
  		get previousSibling() {
  			return makeNode( $dom.getPreviousSibling() );
  		},
  		toString: function(){
  			return '"' + this.nodeValue + '"';
  		},
  		get outerHTML(){
  			return this.nodeValue;
  		},
  		get __guid__(){return $id;}
	  });
  };
});

  // DOMComment

$w.__defineGetter__("DOMComment", function(){
	  $id = createGUID();
  return function(node){
    return __extend__(this, __extend__(new DOMNode(node),{
      get nodeType(){
  			return 8;
  		},
  		get outerHTML(){
  			return "<!--" + this.nodeValue + "-->";
  		}
    }));
  };
});

	// DOM Element

$w.__defineGetter__("DOMElement", function(){
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

$w.__defineGetter__('DOMParser', function(){
  return function(){
    return __extend__(this, {
      parseFromString: function(xmlString){
        return document.implementation.createDocument().loadXML(xmlString);
      }
    });
  };
});
	
	