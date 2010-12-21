$debug("Defining HTMLDocument");
/*
* HTMLDocument - DOM Level 2
*/
/**
 * @class  HTMLDocument - The Document interface represents the entire HTML or XML document.
 *   Conceptually, it is the root of the document tree, and provides the primary access to the document's data.
 *
 * @extends DOMDocument
 */
var HTMLDocument = function(implementation, docParentWindow, docReferrer) {
  this.DOMDocument = DOMDocument;
  this.DOMDocument(implementation, docParentWindow);

  this._referrer = docReferrer;
  this._domain;
  this._open = false;
  this.$async = false;
};
HTMLDocument.prototype = new DOMDocument;
__extend__(HTMLDocument.prototype, {
    loadXML : function(xmlString, url) {
        if (url) {
            var $env =  this._parentWindow.$envx;
            $env.__url(url);
        }

        // create DOM Document
/*
        if(this === $document){
            $debug("Setting internal window.document");
            $document = this;
        }
*/
        // populate Document with Parsed Nodes
        try {
            // make sure thid document object is empty before we try to load ...
            this.childNodes      = new DOMNodeList(this, this);
            this.firstChild      = null;
            this.lastChild       = null;
            this.attributes      = new DOMNamedNodeMap(this, this);
            this._namespaces     = new DOMNamespaceNodeMap(this, this);
            this._readonly = false;
            
//          var now = Date.now();
// print("begin parse");
try{
            this._parentWindow.parseHtmlDocument(xmlString, this, null, null);
}catch(e){
  print("oopsd",e);
  throw e;
}
// print("end parse");
//          print("parse time: "+(Date.now() - now)/1000.);
//          print("parse: "+xmlString.substring(0,80));

            
        } catch (e) {
            $error(e);
        }

        // set parseComplete flag, (Some validation Rules are relaxed if this is false)
        this._parseComplete = true;
        return this;
    },
    createElement: function(tagName){
          var node;
          //print('createElement :'+tagName);
          // throw Exception if the tagName string contains an illegal character
          if (__ownerDocument__(this).implementation.errorChecking && 
                (!__isValidName__(tagName))) {
              throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
          }
          var originalName = tagName;
          tagName = tagName.toUpperCase();
          // create DOMElement specifying 'this' as ownerDocument
          //This is an html document so we need to use explicit interfaces per the 
          if(     tagName.match(/^A$/))                 {node = new HTMLAnchorElement(this);}
          else if(tagName.match(/^AREA$/))              {node = new HTMLAreaElement(this);}
          else if(tagName.match(/BASE/))                {node = new HTMLBaseElement(this);}
          else if(tagName.match(/BLOCKQUOTE|Q/))        {node = new HTMLQuoteElement(this);}
          else if(tagName.match(/BODY/))                {node = new HTMLBodyElement(this);}
          else if(tagName.match(/BR/))                  {node = new HTMLElement(this);}
          else if(tagName.match(/BUTTON/))              {node = new HTMLButtonElement(this);}
          else if(tagName.match(/CAPTION/))             {node = new HTMLElement(this);}
          else if(tagName.match(/COL|COLGROUP/))        {node = new HTMLTableColElement(this);}
          else if(tagName.match(/DEL|INS/))             {node = new HTMLModElement(this);}
          else if(tagName.match(/DIV/))                 {node = new HTMLDivElement(this);}
          else if(tagName.match(/DL/))                  {node = new HTMLElement(this);}
          else if(tagName.match(/FIELDSET/))            {node = new HTMLFieldSetElement(this);}
          else if(tagName.match(/FORM/))                {node = new HTMLFormElement(this);}
          else if(tagName.match(/^FRAME$/))             {node = new HTMLFrameElement(this);}
          else if(tagName.match(/FRAMESET/))            {node = new HTMLFrameSetElement(this);}
          else if(tagName.match(/H1|H2|H3|H4|H5|H6/))   {node = new HTMLElement(this);}
          else if(tagName.match(/HEAD/))                {node = new HTMLHeadElement(this);}
          else if(tagName.match(/HR/))                  {node = new HTMLElement(this);}
          else if(tagName.match(/HTML/))                {node = new HTMLElement(this);}
          else if(tagName.match(/IFRAME/))              {node = new HTMLIFrameElement(this);}
          else if(tagName.match(/IMG/))                 {node = new HTMLImageElement(this);}
          else if(tagName.match(/INPUT/))               {node = new HTMLInputElement(this);}
          else if(tagName.match(/LABEL/))               {node = new HTMLLabelElement(this);}
          else if(tagName.match(/LEGEND/))              {node = new HTMLLegendElement(this);}
          else if(tagName.match(/^LI$/))                {node = new HTMLElement(this);}
          else if(tagName.match(/LINK/))                {node = new HTMLLinkElement(this);}
          else if(tagName.match(/MAP/))                 {node = new HTMLMapElement(this);}
          else if(tagName.match(/META/))                {node = new HTMLMetaElement(this);}
          else if(tagName.match(/OBJECT/))              {node = new HTMLObjectElement(this);}
          else if(tagName.match(/OL/))                  {node = new HTMLElement(this);}
          else if(tagName.match(/OPTGROUP/))            {node = new HTMLOptGroupElement(this);}
          else if(tagName.match(/OPTION/))              {node = new HTMLOptionElement(this);;}
          else if(tagName.match(/^P$/))                 {node = new HTMLElement(this);}
          else if(tagName.match(/PARAM/))               {node = new HTMLParamElement(this);}
          else if(tagName.match(/PRE/))                 {node = new HTMLElement(this);}
          else if(tagName.match(/SCRIPT/))              {node = new HTMLScriptElement(this);}
          else if(tagName.match(/SELECT/))              {node = new HTMLSelectElement(this);}
          else if(tagName.match(/STYLE/))               {node = new HTMLStyleElement(this);}
          else if(tagName.match(/TABLE/))               {node = new HTMLTableElement(this);}
          else if(tagName.match(/TBODY|TFOOT|THEAD/))   {node = new HTMLTableSectionElement(this);}
          else if(tagName.match(/TD|TH/))               {node = new HTMLTableCellElement(this);}
          else if(tagName.match(/TEXTAREA/))            {node = new HTMLTextAreaElement(this);}
          else if(tagName.match(/TITLE/))               {node = new HTMLTitleElement(this);}
          else if(tagName.match(/TR/))                  {node = new HTMLTableRowElement(this);}
          else if(tagName.match(/UL/))                  {node = new HTMLElement(this);}
          else{
            node = new HTMLElement(this);
          }
        
          // assign values to properties (and aliases)
          node.tagName  = tagName; // originalName;
          return node;
    },
    createElementNS : function (uri, local) {
        //print('createElementNS :'+uri+" "+local);
        if(!uri){
            return this.createElement(local);
        }else if ("http://www.w3.org/1999/xhtml" == uri) {
             return this.createElement(local);
        } else if ("http://www.w3.org/1998/Math/MathML" == uri) {
          if (!this.mathplayerinitialized) {
              var obj = this.createElement("object");
              obj.setAttribute("id", "mathplayer");
              obj.setAttribute("classid", "clsid:32F66A20-7614-11D4-BD11-00104BD3F987");
              this.getElementsByTagName("head")[0].appendChild(obj);
              this.namespaces.add("m", "http://www.w3.org/1998/Math/MathML", "#mathplayer");  
              this.mathplayerinitialized = true;
          }
          return this.createElement("m:" + local);
        } else {
            return DOMDocument.prototype.createElementNS.apply(this,[uri, local]);
        }
    },
    get anchors(){
        return new HTMLCollection(this.getElementsByTagName('a'), 'Anchor');
        
    },
    get applets(){
        return new HTMLCollection(this.getElementsByTagName('applet'), 'Applet');
        
    },
    get body(){ 
        var nodelist = this.getElementsByTagName('body');
        return nodelist.item(0);
        
    },
    set body(html){
        return this.replaceNode(this.body,html);
        
    },

    get title(){
        var titleArray = this.getElementsByTagName('title');
        if (titleArray.length < 1)
            return "";
        return titleArray[0].text;
    },
    set title(titleStr){
        titleArray = this.getElementsByTagName('title');
        if (titleArray.length < 1){
            // need to make a new element and add it to "head"
            var titleElem = new HTMLTitleElement(this);
            titleElem.text = titleStr;
            var headArray = this.getElementsByTagName('head');
	    if (headArray.length < 1)
                return;  // ill-formed, just give up.....
            headArray[0].appendChild(titleElem);
        }
        else {
            titleArray[0].text = titleStr;
        }
    },

    //set/get cookie see cookie.js
    get domain(){
        return this._domain||this._parentWindow.location.domain;
        
    },
    set domain(){
        /* TODO - requires a bit of thought to enforce domain restrictions */ 
        return; 
        
    },
    get forms(){
      return new HTMLCollection(this.getElementsByTagName('form'), 'Form');
    },
    get images(){
        return new HTMLCollection(this.getElementsByTagName('img'), 'Image');
        
    },
    get lastModified(){ 
        /* TODO */
        return this._lastModified; 
    
    },
    get links(){
        return new HTMLCollection(this.getElementsByTagName('a'), 'Link');
        
    },
    get location(){
        return this._parentWindow.location
    },
    get referrer(){
        return this._referrer;
    },
	close : function(){ 
	    /* TODO */ 
	    this._open = false;
    },
	getElementsByName : function(name){
        //returns a real Array + the DOMNodeList
        var retNodes = __extend__([],new DOMNodeList(this, this.documentElement)),
          node;
        // loop through all Elements in the 'all' collection
        var all = this.all;
        for (var i=0; i < all.length; i++) {
            node = all[i];
            if (node.nodeType == DOMNode.ELEMENT_NODE && node.getAttribute('name') == name) {
                retNodes.push(node);
            }
        }
        return retNodes;
	},
	open : function(){ 
	    /* TODO */
	    this._open = true;  
    },
	write: function(htmlstring){ 
	    /* TODO */
	    return; 
	
    },
	writeln: function(htmlstring){ 
	    this.write(htmlstring+'\n'); 
    },
	toString: function(){ 
	    return "HTMLDocument" +  (typeof this._url == "string" ? ": " + this._url : ""); 
    },
	get innerHTML(){ 
	    return this.documentElement.outerHTML; 
	    
    },
	get __html__(){
	    return true;
	    
    },
    get async(){ return this.$async;},
    set async(async){ this.$async = async; },
    get baseURI(){
      var $env =  this.ownerDocument._parentWindow.$envx;
      return $env.location('./');
    },
    get URL(){ return this._parentWindow.location.href;  },
    set URL(url){ this._parentWindow.location.href = url;  },
});

var __elementPopped__ = function(ns, name, node){
try{
    var $env =  __ownerDocument__(node)._parentWindow.$envx;
    // $error('Element Popped: '+ns+" "+name+ " "+ node+" " +node.type+" "+node.nodeName);
    var doc = __ownerDocument__(node);
    // SMP: subtle issue here: we're currently getting two kinds of script nodes from the html5 parser.
    // The "fake" nodes come with a type of undefined. The "real" nodes come with the type that's given,
    // or null if not given. So the following check has the side-effect of ignoring the "fake" nodes. So
    // something to watch for if this code changes.
    var type = ( node.type === null ) ? "text/javascript" : node.type;
    try{
        if(node.nodeName.toLowerCase() == 'script' && type == "text/javascript"){
            // print(node,doc.in_inner_html);
            if (doc.in_inner_html) {
                // this is a fib, but ...
                // print("ignore",node);
                // node.executed = true;
            } else {
                //$env.debug("element popped: script\n"+node.xml);
                // unless we're parsing in a window context, don't execute scripts
                // this probably doesn't do anything ...
                if (true /*doc.parentWindow && !node.ownerDocument.is_innerHTML*/){
                    //p.replaceEntities = true;
                    var okay = $env.loadLocalScript(node, null);
                    // only fire event if we actually had something to load
                    if (node.src && node.src.length > 0){
                            var event = doc.createEvent();
                        event.initEvent( okay ? "load" : "error", false, false );
                        node.dispatchEvent( event, false );
                    }
                }
            }
        }
        else if (node.nodeName.toLowerCase() == 'frame' ||
                 node.nodeName.toLowerCase() == 'iframe'   ){
            
            //$env.debug("element popped: iframe\n"+node.xml);
            if (node.src && node.src.length > 0){
                $debug("getting content document for (i)frame from " + node.src);
    
                // any JS here is DOM-instigated, so the JS scope is the window, not the first script

              var $inner = node.ownerDocument._parentWindow["$inner"];

              var save = $master.first_script_window;
              $master.first_script_window = $inner;

              $env.loadFrame(node, $env.location(node.src));
    
              $master.first_script_window = save;

                var event = doc.createEvent();
                event.initEvent("load", false, false);
                node.dispatchEvent( event, false );
            }
        }
        else if (node.nodeName.toLowerCase() == 'link'){
            //$env.debug("element popped: link\n"+node.xml);
            if (node.href && node.href.length > 0){
                // don't actually load anything, so we're "done" immediately:
                var event = doc.createEvent();
                event.initEvent("load", false, false);
                node.dispatchEvent( event, false );
            }
        }
        else if (node.nodeName.toLowerCase() == 'img'){
            //$env.debug("element popped: img \n"+node.xml);
            if (node.src && node.src.length > 0){
                // don't actually load anything, so we're "done" immediately:
                var event = doc.createEvent();
                event.initEvent("load", false, false);
                node.dispatchEvent( event, false );
            }
        }
    }catch(e){
        $error('error loading html element', e);
        $error(e);
    }
} catch(e) {
  $error("arg",e);
}
};

//$w.HTMLDocument = HTMLDocument;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
