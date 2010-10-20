$debug("Defining HTMLScriptElement");
/* 
* HTMLScriptElement - DOM Level 2
*/
var HTMLScriptElement = function(ownerDocument) {
    this.HTMLElement = HTMLElement;
    this.HTMLElement(ownerDocument);
};
HTMLScriptElement.prototype = new HTMLElement;
__extend__(HTMLScriptElement.prototype, {
    setAttribute: function(name,value) {
      var result = HTMLElement.prototype.setAttribute.apply(this,arguments);
      // print("set src",this,this.executed);
      if (name === "src" && !this.executed && value && !value.match(/^\s*$/)) {
        var pn = this;
        while(pn.parentNode) {
          pn = pn.parentNode;
        }
        if(pn === this.ownerDocument) { 
          this.executed = true;
          var $env = this.ownerDocument._parentWindow.$envx;
          // print("on src change");
          $env.loadLocalScript(this);
        }
      }
      return result;
    },

    appendChild: function(node,ref) {
      var result = HTMLElement.prototype.appendChild.apply(this,arguments);
      // print("check",this,this.ownerDocument.in_inner_html);
      if (!this.executed) {
          var pn = this;
          while(pn.parentNode) {
            pn = pn.parentNode;
          }
          if(pn === this.ownerDocument) { 
            var text = this.text;
            // print("T:", text);
            if (text && !text.match(/^\s*$/)) {
              this.executed = true;
              var $env = this.ownerDocument._parentWindow.$envx;
              // print("on text change");
              $env.loadInlineScript(this);
            }
          }
      }
      return result;
    },

    get text(){
        // text of script is in a child node of the element
        // scripts with < operator must be in a CDATA node
        for (var i=0; i<this.childNodes.length; i++) {
            if (this.childNodes[i].nodeType == DOMNode.CDATA_SECTION_NODE) {
                return this.childNodes[i].nodeValue;
            }
        } 
        // otherwise there will be a text node containing the script
        if (this.childNodes[0] && this.childNodes[0].nodeType == DOMNode.TEXT_NODE) {
            return this.childNodes[0].nodeValue;
 		}
        return this.nodeValue;

    },
    set text(value){
      while (this.firstChild) {
        this.removeChild(this.firstChild);
      }
      this.appendChild(this.ownerDocument.createTextNode(value));
    },
    get htmlFor(){
        return this.getAttribute('for');
    },
    set htmlFor(value){
        this.setAttribute('for',value);
    },
    get event(){
        return this.getAttribute('event');
    },
    set event(value){
        this.setAttribute('event',value);
    },
    get charset(){
        return this.getAttribute('charset');
    },
    set charset(value){
        this.setAttribute('charset',value);
    },
    get defer(){
        return this.getAttribute('defer');
    },
    set defer(value){
        this.setAttribute('defer',value);
    },
    get src(){
        return this.getAttribute('src');
    },
    set src(value){
        this.setAttribute('src',value);
    },
    get type(){
        return this.getAttribute('type');
    },
    set type(value){
        this.setAttribute('type',value);
    },
    onload: function(event){
        return __eval__(this.getAttribute('onload')||'', this);
    },
    onerror: function(event){
        return __eval__(this.getAttribute('onerror')||'', this);
    }
});

// $w.HTMLScriptElement = HTMLScriptElement;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
