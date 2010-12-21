$debug("Defining Anchor");
/* 
* Anchor - DOM Level 2
*/
var Anchor = function(ownerDocument) {
    this.HTMLAnchorElement = HTMLAnchorElement;
    this.HTMLAnchorElement(ownerDocument);
};

(function(){
    //static regular expressions
	var hash 	 = new RegExp('(\\#.*)'),
        hostname = new RegExp('\/\/([^\:\/]+)'),
        pathname = new RegExp('(\/[^\\?\\#]*)'),
        port 	 = new RegExp('\:(\\d+)\/'),
        protocol = new RegExp('(^\\w*\:)'),
        search 	 = new RegExp('(\\?[^\\#]*)');
			
    __extend__(Anchor.prototype, {
		get hash(){
			var m = hash.exec(this.href);
			return m&&m.length>1?m[1]:"";
		},
		set hash(_hash){
			//setting the hash is the only property of the location object
			//that doesn't cause the window to reload
			_hash = _hash.indexOf('#')===0?_hash:"#"+_hash;	
			this.href = this.protocol + this.host + this.pathname + this.search + _hash;
		},
		get host(){
			return this.hostname + (this.port !== "")?":"+this.port:"";
		},
		set host(_host){
			this.href = this.protocol + _host + this.pathname + this.search + this.hash;
		},
		get hostname(){
			var m = hostname.exec(this.href);
			return m&&m.length>1?m[1]:"";
		},
		set hostname(_hostname){
			this.href = this.protocol + _hostname + ((this.port=="")?"":(":"+this.port)) +
			 	 this.pathname + this.search + this.hash;
		},
		get pathname(){
			var m = this.href;
			m = pathname.exec(m.substring(m.indexOf(this.hostname)));
			return m&&m.length>1?m[1]:"/";
		},
		set pathname(_pathname){
			this.href = this.protocol + this.host + _pathname + 
				this.search + this.hash;
		},
		get port(){
			var m = port.exec(this.href);
			return m&&m.length>1?m[1]:"";
		},
		set port(_port){
			this.href = this.protocol + this.hostname + ":"+_port + this.pathname + 
				this.search + this.hash;
		},
		get protocol(){
			return protocol.exec(this.href)[0];
		},
		set protocol(_protocol){
			this.href = _protocol + this.host + this.pathname + 
				this.search + this.hash;
		},
		get search(){
			var m = search.exec(this.href);
			return m&&m.length>1?m[1]:"";
		},
		set search(_search){
			this.href = this.protocol + this.host + this.pathname + 
				_search + this.hash;
		}
  });

})();

// $w.Anchor = Anchor;
