$debug("Defining HTMLInputElement");
/*
* HTMLInputElement - DOM Level 2
*/
var HTMLInputElement = function(ownerDocument) {
    this.HTMLInputAreaCommon = HTMLInputAreaCommon;
    this.HTMLInputAreaCommon(ownerDocument);
};
HTMLInputElement.prototype = new HTMLInputAreaCommon;
__extend__(HTMLInputElement.prototype, {
    get alt(){
        return this.getAttribute('alt');
    },
    set alt(value){
        this.setAttribute('alt', value);
    },
    get checked(){
        return (this.getAttribute('checked')=='checked');
    },
    set checked(value){
        this.setAttribute('checked', (value ? 'checked' :''));
    },
    get defaultChecked(){
        return this.getAttribute('defaultChecked');
    },
    get height(){
        return this.getAttribute('height');
    },
    set height(value){
        this.setAttribute('height',value);
    },
    get maxLength(){
        return Number(this.getAttribute('maxlength')||'0');
    },
    set maxLength(value){
        this.setAttribute('maxlength', value);
    },
    get src(){
        return this.getAttribute('src');
    },
    set src(value){
        this.setAttribute('src', value);
    },
    get useMap(){
        return this.getAttribute('map');
    },
    get width(){
        return this.getAttribute('width');
    },
    set width(value){
        this.setAttribute('width',value);
    },
    click:function(){
        __click__(this);
    }
});

// $w.HTMLInputElement = HTMLInputElement;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// mode:auto-revert
// End:
