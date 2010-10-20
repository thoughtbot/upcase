/*
originally from http://www.senocular.com/index.php?id=1.289

SUPPORTED
- ID selectors
- Class selectors
- Multiple class definitions (i.e. LI.red.level)
- Tag selectors
- Selector groups
- Child selectors
- descendants
- Adjacent selectors
- Attribute selectors
LIMITED SUPPORT
- Psuedo classes/elements (Must specify in element get properties method), only first pseudo identifier recognized
NOT SUPPORTED
- @import
- Specificity / ! important (would need to check order of definition, determine doc location of LINK vs STYLE tags and parse in order)
- - current order assumption: STYLE, LINK, INLINE (last with most precedence, parsed last)
- Inherited properties (TODO? - if so, need to define those properties inherited)

-------------------

// TODO:
// NEED TO CHECK COMBINATOR

// TESTING

// CHECK FOR NULL/EMPTY STRING PARSING
		
*/
Object.prototype.toString = function(s, t){
	var looped = false;
	var str;
	if (t == undefined) t = "\t";
	else t += "\t";
	if (s == undefined) s = "Object: {";
	else s += "{";
	for (var p in this){
		if (!this.hasOwnProperty(p) || !this[p]) continue;
		s += "\n"+t;
		if (!looped) looped = true
		if (this[p] instanceof Array)  s += p+": ["+this[p]+"]";
		else if (typeof this[p] == "object") s += this[p].toString(p+": ", t);
		else if (typeof this[p] == "function") s += p+": (function)";
		else if (typeof this[p] == "string"){
			str = String(this[p]);
			str = str.replace(/\r/g,"\\r");
			str = str.replace(/\n/g,"\\n");
			str = str.replace(/\t/g,"\\t");
			s += p+": \""+str+"\"";
		}else s += p+": "+this[p];
	}
	return s+"\n"+t.slice(0,-1)+"}";
};

CSSParser.DELIM1 = "##DELIM1##";
CSSParser.DELIM2 = "##DELIM2##";
CSSParser.combine = function(target, copyFrom){
	for(var p in copyFrom) target[p] = copyFrom[p];
}
CSSParser.trim = function(str){
	return str.replace(/^\s*|\s*$/g,"");
}
CSSParser.whiteSpaceToSpaces = function(str){
	return str.replace(/\s+/g," ");
}
CSSParser.removeComments = function(str){
	str = str.replace(/<!--/g,"");
	str = str.replace(/-->/g,"");
	return str.replace(/\/\*(\r|\n|.)*\*\//g,"");
}
CSSParser.arrayContains = function(ary, value){
	var i, len = ary.length;
	for (i=0; i<len; i++){
		if (ary[i] == value) return true;
	}
	return false;
}
CSSParser.arrayContains = function(ary, value){
	var i, len = ary.length;
	for (i=0; i<len; i++){
		if (ary[i] == value) return true;
	}
	return false;
}
CSSParser.arrayContainsEach = function(haystack_ary, needles_ary){
	var n, nlen = needles_ary.length;
	var h, hlen = haystack_ary.length;
	var match = false;
	for (n=0; n<nlen; n++){
		match = false;
		for (h=0; h<hlen; h++){
			if (haystack_ary[h] == needles_ary[n]) match = true;
		}
		if (!match) return false;
	}
	return true;
}


function CSSParser(style_str, dom){
	this.data = "";
	this.styles = new Array();
	
	if (style_str && typeof style_str == "object"){
		dom = style_str;
		style_str = "all";
	}else if (!dom) dom = dw.getDocumentDOM();
	switch(style_str){
		case "*":
		case "all":
		case "document":
			style_str = CSSParser.getEmbeddedCSSStyle(dom);
			style_str += CSSParser.getLinkedCSSStyle(dom);
			break;
		case "styles":
			style_str = CSSParser.getEmbeddedCSSStyle(dom);
			break;
		case "links":
			style_str = CSSParser.getLinkedCSSStyle(dom);
			break;
	}
	
	this.parseData(style_str);
}
CSSParser.prototype.parseData = function(style_str){
	if (!style_str) style_str = "";
	this.data = style_str;
	style_str = CSSParser.trim(CSSParser.removeComments(style_str));
	// TODO: @import ?
	var blocks = style_str.split("}");
	blocks.pop();
	var i, len = blocks.length;
	var definition_block, properties;
	for (i=0; i<len; i++){
		definition_block = blocks[i].split("{");
		this.styles.push(new CSSStyleGroup(definition_block[0], definition_block[1]));
	}
}
function CSSStyleGroup(style_str, properties_str){
	this.data = style_str;
	this.selectors = new Array();
	
	this.parseData(style_str, properties_str);
}
CSSStyleGroup.prototype.parseData = function(style_str, properties_str){
	this.selectors = style_str.split(",");
	var i, len = this.selectors.length;
	for (i=0; i<len; i++){
		this.selectors[i] = new CSSSelectorDefinition(this.selectors[i], properties_str);
	}	
}
CSSStyleGroup.prototype.match = function(elem, pseudo){
	var i, len = this.selectors.length;
	for (i=0; i<len; i++){
		if (this.selectors[i].match(elem, pseudo)) return this.selectors[i].properties;
	}
	return false;
}

function CSSSelectorDefinition(selector_str, properties_str){
	this.data = "";
	this.singleSelectors = new Array();
	this.properties = new CSSProperties(properties_str);
	
	if (selector_str) this.parseData(selector_str);
}
CSSSelectorDefinition.prototype.parseData = function(selector_str){
	selector_str = CSSParser.trim(selector_str);
	selector_str = CSSParser.whiteSpaceToSpaces(selector_str);
	selector_str = selector_str.replace(/\s*\+\s*/g,"+");
	selector_str = selector_str.replace(/\s*>\s*/g,">");
	this.data = selector_str;
	selector_str = selector_str.replace(/ /g,CSSParser.DELIM1 + " " + CSSParser.DELIM1);
	selector_str = selector_str.replace(/\+/g,CSSParser.DELIM1 + "+" + CSSParser.DELIM1);
	selector_str = selector_str.replace(/>/g,CSSParser.DELIM1 + ">" + CSSParser.DELIM1);
	var sels = selector_str.split(CSSParser.DELIM1);
	var i, len = sels.length;
	var sel_comb = null;
	for (i=0; i<len; i+=2){
		if (i) sel_comb = sels[i-1];
		this.singleSelectors.push(new CSSSingleSelector(sels[i], sel_comb));
	}
}
CSSSelectorDefinition.prototype.match = function(element, pseudo){
	// go backwards, starting from right of selector definition
	var index = this.singleSelectors.length-1;
	var compare_elem = element;
	var selector = this.singleSelectors[index];
	
	if (!selector.match(compare_elem, pseudo)) return false;
	while (compare_elem && index >= 0){
		switch (selector.combinator){
			case " ":
				index--;
				selector = this.singleSelectors[index];
				do {
					compare_elem = compare_elem.parentNode;
				} while(compare_elem && !selector.match(compare_elem, pseudo));
				if (!compare_elem) return false;
				break;
			case ">":
				index--;
				selector = this.singleSelectors[index];
				compare_elem = compare_elem.parentNode;
				if (!selector.match(compare_elem, pseudo)) return false;
				break;
			case "+":
				index--;
				selector = this.singleSelectors[index];
				compare_elem = CSSParser.previousSibling(compare_elem);
				if (!selector.match(compare_elem, pseudo)) return false;
				break;
			default:
				// assume first selector in definition chain, therefore comparison complete
				if (!index) return this.properties;
				else return false;
		}
		if (pseudo) pseudo = null; // only used when compare_elem == element
	}
	return false;
}

/*
CSSSelectorDefinition.prototype.match = function(elem, pseudo){
	var i = this.singleSelectors.length;
	// go backwards, starting from right of selector definition
	var compare = elem;
	while (i--){
		// TODO:
		// NEED TO CHECK COMBINATOR MATCHES HERE?
		// ----------------------------------------------------------------------------------------------------------------------------------
//		CSSParser.previousSibling
		if (this.singleSelectors[i].match(elem, pseudo)) return this.properties;
	}
	return false;
}
*/

function CSSSingleSelector(selector_str, selector_comb){
	this.data = selector_str;
	this.combinator = selector_comb; //:String; either " ", ">", or "+"; can be null/undefined
	this.type = "*"; //:String; <E>
	this.classes = "*"; //:Array; E.name
	this.id =  "*"; //:String; E#name
	this.pseudoclass = "*"; //:String; E:link
	this.attributes = "*"; //:CSSAttributeSelector; E[attribute], E[attribute=value]
	
	this.parseData(selector_str);
}
CSSSingleSelector.prototype.parseData = function(selector_str){
	var pcs;
	if (selector_str.indexOf(":") != -1){
		pcs = selector_str.split(":");
		selector_str = pcs[0];
		this.pseudoclass = pcs[1];
	}
	if (selector_str.indexOf("[") != -1){
		pcs = [selector_str.indexOf("["), selector_str.lastIndexOf("]")];
		this.attributes = new CSSAttributeSelector(selector_str.substring(pcs[0], pcs[1]+1));
		selector_str = selector_str.substring(0, pcs[0]) + selector_str.substring(pcs[1]+1);
	}
	if (selector_str.indexOf("#") != -1){
		pcs = selector_str.split("#");
		selector_str = pcs[0];
		this.id = pcs[1];
	}
	if (selector_str.indexOf(".") != -1){
		pcs = selector_str.indexOf(".");
		this.classes = new CSSClassSelector(selector_str.substring(pcs+1));
		selector_str = selector_str.substring(0, pcs);
	}
	if (selector_str) this.type = selector_str.toLowerCase();
}

CSSSingleSelector.prototype.match = function(element, pseudo){
	if (element.nodeType == Node.TEXT_NODE) element = element.parentNode;
	if (!element || element.nodeType != Node.ELEMENT_NODE) return false;
	if (this.type != "*" && element.tagName.toLowerCase() != this.type) return false;
	if (this.id != "*" && element.getAttribute("id") != this.id) return false;
	if (pseudo && pseudo != this.pseudoclass) return false;
	if (this.classes != "*" && !CSSParser.arrayContainsEach(CSSParser.getElementAttributeList(element, "class"), this.classes)) return false;
	if (this.attributes != "*" && !this.attributes.match(element)) return false;
	return true;
}

function CSSAttributeSelector(attrib_str){
	this.attributeNames = new Array();
	this.attributeValues = new Array();
	this.attributeContains = new Array();
	this.attributeBegins = new Array();
	
	this.parseData(attrib_str);
}
CSSAttributeSelector.prototype.parseData = function(attrib_str){
	var attr_ary = attrib_str.match(/\[[^\]]*\]/g);
	var i, len = attr_ary.length;
	var attr;
	for (i=0; i<len; i++){
		attr = attr_ary[i].slice(1,-1).split("=");
		if (attr.length == 1){
			this.attributeNames.push(new CSSAttribute(attr[0], null));
		}else if (attr[0].charAt(attr[0].length-1) == "~"){
			this.attributeContains.push(new CSSAttribute(attr[0].slice(0,-1), attr[1].slice(1,-1)));
		}else if (attr[0].charAt(attr[0].length-1) == "|"){
			this.attributeBegins.push(new CSSAttribute(attr[0].slice(0,-1), attr[1].slice(1,-1)));
		}else{
			this.attributeValues.push(new CSSAttribute(attr[0], attr[1].slice(1,-1)));
		}
	}
}
CSSAttributeSelector.prototype.match = function(elem){
	if (this.attributeNames.length && !this.matchNames(elem)) return false;
	if (this.attributeValues.length && !this.matchValues(elem)) return false;
	if (this.attributeContains.length && !this.matchContains(elem)) return false;
	if (this.attributeBegins.length && !this.matchBegins(elem)) return false;
	return true;
}
CSSAttributeSelector.prototype.matchNames = function(elem){
	var i, len = this.attributeNames.length;
	for (i=0; i<len; i++){
		if (elem.getAttribute(this.attributeNames[i].name) == undefined) return false;
	}
	return true;
}
CSSAttributeSelector.prototype.matchValues = function(elem){
	var i, len = this.attributeValues.length;
	for (i=0; i<len; i++){
		alert([this.attributeValues[i].name, this.attributeValues[i].value])
		if (elem.getAttribute(this.attributeValues[i].name) != this.attributeValues[i].value) return false;
	}
	return true;
}
CSSAttributeSelector.prototype.matchContains = function(elem){
	var i, len = this.attributeContains.length;
	var attrib, re;
	for (i=0; i<len; i++){
		attrib = elem.getAttribute(this.attributeContains[i].name);
		if (attrib == undefined) return false;
		re = new RegExp("(^| )"+this.attributeContains[i].value+"( |$)", "g");
		if (!attrib.match(re)) return false;
	}
	return true;
}
CSSAttributeSelector.prototype.matchBegins = function(elem){
	var i, len = this.attributeBegins.length;
	var attrib;
	for (i=0; i<len; i++){
		attrib = elem.getAttribute(this.attributeBegins[i].name);
		if (attrib == undefined) return false;
		if (attrib == this.attributeBegins[i].value || attrib.indexOf(this.attributeBegins[i].value + "-") != 0){
			// allows for exact match or exact match upto first "-" in separated list
			return false;
		}
	}
	return true;
}

function CSSAttribute(name, value){
	this.name = name;
	this.value = value;
}
function CSSClassSelector(class_str){
	this.values = new Array();
	
	this.parseData(class_str);
}
CSSClassSelector.prototype.parseData = function(class_str){
	this.values = class_str.split(".");
}

function CSSProperties(properties_str){
	this.values = new Object();
	
	this.parseData(properties_str);
}
CSSProperties.prototype.parseData = function(properties_str){
	if (!properties_str) return;
	var property_block = properties_str.split(";");
	var i, len = property_block.length;
	var property, value_block;
	for (i=0; i<len; i++){
		property = CSSParser.trim(property_block[i]);
		if (property){
			value_block = property.split(":");
			this.values[CSSParser.trim(value_block[0].toLowerCase())] = CSSParser.trim(value_block[1]);
		}
	}
}


CSSParser.getLinkedCSSStyle = function(dom){
	var links = dom.getElementsByTagName("LINK");
	var style_str = "";
	if (links.length){
		var contents;
		var i, len = links.length;
		for (i=0; i<len; i++){
			if (links[i].rel == "stylesheet" && links[i].href){
				contents = DWfile.read(dom.URL.substr(0, dom.URL.lastIndexOf("/")+1) + links[i].getAttribute("href"));
				if (contents) style_str += contents;
			}
		}
	}
	return (style_str == "") ? "" : style_str;
}
CSSParser.getEmbeddedCSSStyle = function(dom){
	var styles = dom.getElementsByTagName("STYLE");
	var style_str = "";
	if (styles.length){
		var i, len = styles.length;
		for (i=0; i<len; i++) style_str += styles[i].innerHTML;
	}
	return (style_str == "") ? "" : style_str;
}
CSSParser.getInlineCSSStyle = function(element){
	return (element.style == undefined) ? "" : element.style;
}

CSSParser.previousSibling = function(element){
	var par = element.parentNode;
	if (!par || !par.hasChildNodes()) return false;
	var sib = false;
	var i, len = par.childNodes.length;
	for (i=0; i<len; i++){
		if (par.childNodes[i] == element) return sib;
		sib = par.childNodes[i];
	}
	return false;
}

CSSParser.getElementAttributeList = function(elem, attrib){
	var attrib_list = new Array();
	var attrib = elem.getAttribute(attrib);
	if (!attrib) return attrib_list;
	attrib = CSSParser.whiteSpaceToSpaces(attrib);
	attrib_list = attrib.split(" ");
	return attrib_list;
}


// -------------------------------------------
// PUBLIC INTERFACE
// -------------------------------------------
// new Parser(dom), new Parser("all" [, dom]), new Parser("style{prop:value;}" [, dom])
CSSParser.prototype.getElementProperties = function(elem, pseudo){
	var i, len = this.styles.length;
	var properties = new CSSProperties(elem.getAttribute("style"));
	var match_props;
	for (i=0; i<len; i++){
		match_props = this.styles[i].match(elem, pseudo);
		if (match_props){
			CSSParser.combine(properties.values, match_props.values);
		}
	}
	return properties.values;
}