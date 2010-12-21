$debug("Defining HTMLFrameElement");
/* 
* HTMLFrameElement - DOM Level 2
*/
var HTMLFrameElement = function(ownerDocument) {
    this.HTMLElement = HTMLElement;
    this.HTMLElement(ownerDocument);
};
HTMLFrameElement.prototype = new HTMLElement;
__extend__(HTMLFrameElement.prototype, {
    get frameBorder(){
        return this.getAttribute('border')||"";
    },
    set frameBorder(value){
        this.setAttribute('border', value);
    },
    get longDesc(){
        return this.getAttribute('longdesc')||"";
    },
    set longDesc(value){
        this.setAttribute('longdesc', value);
    },
    get marginHeight(){
        return this.getAttribute('marginheight')||"";
    },
    set marginHeight(value){
        this.setAttribute('marginheight', value);
    },
    get marginWidth(){
        return this.getAttribute('marginwidth')||"";
    },
    set marginWidth(value){
        this.setAttribute('marginwidth', value);
    },
    get name(){
        return this.getAttribute('name')||"";
    },
    set name(value){
        this.setAttribute('name', value);
    },
    get noResize(){
        return this.getAttribute('noresize')||"";
    },
    set noResize(value){
        this.setAttribute('noresize', value);
    },
    get scrolling(){
        return this.getAttribute('scrolling')||"";
    },
    set scrolling(value){
        this.setAttribute('scrolling', value);
    },
    get src(){
        return this.getAttribute('src')||"";
    },
    set src(value){
        this.setAttribute('src', value);

        if (value && value.length > 0){
            var save = $master.first_script_window;
            try {
              var $env = this.ownerDocument._parentWindow.$envx;
              var $inner = this.ownerDocument._parentWindow["$inner"];
              $master.first_script_window = $inner;
              $env.loadFrame(this, $env.location(value));
            } finally {
              $master.first_script_window = save;
            }

            
            var event = this.ownerDocument.createEvent();
            event.initEvent("load");
            this.dispatchEvent( event, false );
        }
    },
    get contentDocument(){
        if (!this._content)
            return null;
        return this._content.document;
    },
    get contentWindow(){
        return this._content;
    },
    onload: function(event){
        return __eval__(this.getAttribute('onload')||'', this)
    }
});

// $w.HTMLFrameElement = HTMLFrameElement;
