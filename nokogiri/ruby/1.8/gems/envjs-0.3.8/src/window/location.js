/*
*	location.js
*   - requires env
*/
$debug("Initializing Window Location.");
//the current location
var $location = '';
$env.__url = function(url){
    $location = url;
};

$w.__defineSetter__("location", function(url){
  if (url[0] === "#") {
      window.location.hash = url;
      // print("return anchor only: "+window.location.href);
      return;
  }
  if (false) {
    var now = window.location.href.replace(/^file:\/\//,"").replace(/#.*/,"");
    var to = $master.first_script_window && $master.first_script_window.location.href;
    // var to = $env.location(url,window.location.href != "about:blank" ? window.location.href: undefined);
    // I'm not sure why this code is here ... looking at the FSW
    // print("nu",now,url,to);
    to = to || $env.location(url,window.location.href);
    // print("nu",now,url,to);
    if (to && to.indexOf(now)===0 && to[now.length]==="#") {
      // print("return diff anchor only");
      return;
    }
    if (url && url.indexOf(now)===0 && url[now.length]==="#") {
      // print("return diff anchor only");
      return;
    }
    // print($location, window.location.href === $location,  $location.indexOf("#")>0);
    if (url === window.location.href && $location.indexOf("#")>0) {
      // print('returning same with anchor');
      return;
    }
    // print("ft",window.location.href,$location,url);
  }
  // debug("l",url,$w.location);
  if( !$location || ( $location == "about:blank" && url !== "about:blank" ) ) {
    // $w.__loadAWindowsDocument__(url);
    $env.load(url);
  } else {
    $env.unload($w);
    var proxy = $w.window;
    // print("re",url);
    $env.reload(proxy, url);
  }
});

$w.__defineGetter__("location", function(url){
	var hash 	 = new RegExp('(\\#.*)'),
		hostname = new RegExp('\/\/([^\:\/]+)'),
		pathname = new RegExp('(\/[^\\?\\#]*)'),
		port 	 = new RegExp('\:(\\d+)\/'),
		protocol = new RegExp('(^\\w*\:)'),
		search 	 = new RegExp('(\\?[^\\#]*)');
	return {
		get hash(){
			var m = hash.exec(this.href);
			return m&&m.length>1?m[1]:"";
		},
		set hash(_hash){
			//setting the hash is the only property of the location object
			//that doesn't cause the window to reload
            var prot = this.protocol;
            // FIXME this is a hack until the new url stuff is integrated
            if (prot === "file:") {
                prot = "file:///";
            }
			_hash = _hash.indexOf('#')===0?_hash:"#"+_hash;	
			$location = prot + this.host + this.pathname + 
				this.search + _hash;
			__setHistory__(_hash, "hash");
		},
		get host(){
			return this.hostname + ((this.port !== "")?":"+this.port:"");
		},
		set host(_host){
			$w.location = this.protocol + _host + this.pathname + 
				this.search + this.hash;
		},
		get hostname(){
			var m = hostname.exec(this.href);
			return m&&m.length>1?m[1]:"";
		},
		set hostname(_hostname){
			$w.location = this.protocol + _hostname + ((this.port==="")?"":(":"+this.port)) +
			 	 this.pathname + this.search + this.hash;
		},
		get href(){
			//This is the only env specific function
			return $location;
		},
		set href(url){
			$w.location = url;	
		},
		get pathname(){
			var m = this.href;
			m = pathname.exec(m.substring(m.indexOf(this.hostname)));
			return m&&m.length>1?m[1]:"/";
		},
		set pathname(_pathname){
			$w.location = this.protocol + this.host + _pathname + 
				this.search + this.hash;
		},
		get port(){
			var m = port.exec(this.href);
			return m&&m.length>1?m[1]:"";
		},
		set port(_port){
			$w.location = this.protocol + this.hostname + ":"+_port + this.pathname + 
				this.search + this.hash;
		},
		get protocol(){
			return this.href && protocol.exec(this.href)[0];
		},
		set protocol(_protocol){
			$w.location = _protocol + this.host + this.pathname + 
				this.search + this.hash;
		},
		get search(){
			var m = search.exec(this.href);
			return m&&m.length>1?m[1]:"";
		},
		set search(_search){
			$w.location = this.protocol + this.host + this.pathname + 
				_search + this.hash;
		},
		toString: function(){
			return this.href;
		},
        reload: function(force){
            // ignore 'force': we don't implement a cache
            var thisWindow = $w;
            $env.unload(thisWindow);
            try { thisWindow = thisWindow.$thisWindowsProxyObject || thisWindow; }catch (e){}
            $env.reload($window, thisWindow.location.href);
        },
        replace: function(url){
            $location = url;
            $w.location.reload();
        }
    };
});

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
