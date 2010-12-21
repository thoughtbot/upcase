/* 
* CSSStyleSheet - DOM Level 2
*/
var CSSStyleSheet = function(options){
    var $cssRules, 
        $disabled = options.disabled?options.disabled:false,
        $href = options.href?options.href:null,
        $parentStyleSheet = options.parentStyleSheet?options.parentStyleSheet:null,
        $title = options.title?options.title:"",
        $type = "text/css";
        
    function parseStyleSheet(text){
        $debug("parsing css");
        //this is pretty ugly, but text is the entire text of a stylesheet
        var cssRules = [];
    	if (!text) text = "";
    	text = trim(text.replace(/\/\*(\r|\n|.)*\*\//g,""));
    	// TODO: @import ?
    	var blocks = text.split("}");
    	blocks.pop();
    	var i, len = blocks.length;
    	var definition_block, properties, selectors;
    	for (i=0; i<len; i++){
    		definition_block = blocks[i].split("{");
    		if(definition_block.length === 2){
      		selectors = definition_block[0].split(",");
      		for(var j=0;j<selectors.length;j++){
      		  cssRules.push(new CSSRule({
      		    selectorText:selectors[j],
      		    cssText:definition_block[1]
      		  }));
      		}
      		__setArray__($cssRules, cssRules);
    		}
    	}
    };
    parseStyleSheet(options.text);
    return __extend__(this, {
      get cssRules(){return $cssRules;},
      get rule(){return $cssRules;},//IE - may be deprecated
      get href(){return $href;},
      get parentStyleSheet(){return $parentStyleSheet;},
      get title(){return $title;},
      get type(){return $type;},
      addRule: function(selector, style, index){/*TODO*/},
      deleteRule: function(index){/*TODO*/},
      insertRule: function(rule, index){/*TODO*/},
      removeRule: function(index){this.deleteRule(index);}//IE - may be deprecated
    });
};

// $w.CSSStyleSheet = CSSStyleSheet;
