/*
 * Envjs @VERSION@ 
 * Pure JavaScript Browser Environment
 *   By John Resig <http://ejohn.org/>
 * Copyright 2008-2009 John Resig, under the MIT License
 */(function(){

try {

(function(){
  for(var symbol in $master["static"]) {
    if(symbol.match(/^(DOM|HTML|XPath)/)){
      // $master.print("import",symbol);
      if(typeof $master["static"][symbol] === "undefined") {
        throw new Error("Cannot import " + symbol + ": undefined");
      }
      this[symbol] = $master["static"][symbol];
    }
  }
  var symbols = [ "Event" ];
  for(var i in symbols) {
    symbol = symbols[i];
    // $master.print("import",symbol);
    if(typeof $master["static"][symbol] === "undefined") {
      throw new Error("Cannot import " + symbol + ": undefined");
    }
    this[symbol] = $master["static"][symbol];
  }
}());

  var $env = (function(){
    
    var $env = {};
    var $master;

    var $public = (function(){
      var $public = {};
      return $public;
    }());

    var $platform = function(master){

      var $platform = {};

      $platform.new_split_global_outer = function() {
        return $master.new_split_global_outer();
      };

      $platform.new_split_global_inner = function(proxy) {
        return $master.new_split_global_inner(proxy,undefined);
      };

      $platform.init_window = function(inner) {
        var index = master.next_window_index()+0;
        inner.toString = function(){
          return "[object Window "+index+"]";
          // return "[object Window]";
        };
      };

      return $platform;
    };

    $env.new_window = function(proxy){
      var swap_script_window; // = ( $master.first_script_window.window === proxy );
      if(!proxy){
        proxy = $platform.new_split_global_outer();
      }
      $master.proxy = proxy;
// try{throw new Error("huh?");}catch(e){print("here",e.stack);}
// var now = Date.now();
      var new_window = $platform.new_split_global_inner(proxy,undefined);
// print("nw "+(Date.now()-now));
      new_window.$inner = new_window;
      if(swap_script_window) {
        $master.first_script_window = new_window;
      }
      new_window.$master = $master;
      for(var index in $master.symbols) {
        var symbol = $master.symbols[index];
        new_window[symbol] = $master[symbol];
      }
      return [ proxy, new_window ];
    };

    $env.init = function(){
      $env.$master = $master = this.$master;
      $platform = $platform($master);
      var $inner = this.$inner; 
      var options = this.$options;
      // delete $inner.$master;
      delete $inner.$platform;
      delete $inner.$options;
      $inner.$envx = $env;
      $env.init_window.call($inner,$inner,options);
    };

    $env.init_window = function(inner,options){
      var $inner = inner;
      var $w = this;

      inner.load = function(){
        for(var i = 0; i < arguments.length; i++){
          var f = arguments[i];
          $master.load(f,inner);
        }
      };

      inner.evaluate = function(string){
        return $master.evaluate.call(string,inner);
      };

      options = options || {};

      var copy_opts = function copy_opts(options){
        var new_opts = {};
        var undef;
        for(var xxx in options){
          if (typeof options[xxx] === "undefined") {
            new_opts[xxx] = undef;
          } else if (options[xxx] === null) {
            new_opts[xxx] = null;
          } else if (typeof options[xxx] == "object" && options[xxx]+"" === "[object split_global]") {
            new_opts[xxx] = options[xxx];
          } else if (typeof options[xxx] == "object" && ((options[xxx]+"").match(/^\[object Window[ 0-9]*\]$/))) {
            new_opts[xxx] = options[xxx];
          } else if (typeof options[xxx] == "string") {
            new_opts[xxx] = options[xxx]+"";
          } else if (typeof options[xxx] == "object" && (options[xxx].constructor+"").match(/^function Object\(\)/) ) {
            new_opts[xxx] = copy_opts(options[xxx]);
          } else {
            throw new Error("copy "+xxx+ " "+typeof options[xxx] + " " +options[xxx] + " " + options[xxx].constructor);
          }
        }
        return new_opts;
      };

      options = copy_opts(options);

      $platform.init_window($w);

      var print = $master.print;

      if (!this.window) {
        this.window = this;
      }
$env.log = function(msg, level){
    print(' '+ (level?level:'LOG') + ':\t['+ new Date()+"] {ENVJS} "+msg);
};

$env.location = function(path, base){
    var debug = false;
    debug && print("loc",path,base);
    if ( path == "about:blank" ) {
        return path;
    }
    var protocol = new RegExp('(^file\:|^http\:|^https\:|data:)');
    var m = protocol.exec(path);
    if(m&&m.length>1){
        var url = Ruby.URI.parse(path);
        var s = url.toString();
        if ( s.substring(0,6) == "file:/" && s[6] != "/" ) {
            s = "file://" + s.substring(5,s.length);
        }
        debug && print("YY",s);
        return s;
    }else if(base){
        base = Ruby.URI.parse(base);
        path = Ruby.URI.parse(path);
        var b = Ruby.eval("lambda { |a,b| a+b; }");
        base = b(base,path);
        base = base + "";
        var result = base;
        // print("ZZ",result);
        // ? This path only used for files?
        if ( result.substring(0,6) == "file:/" && result[6] != "/" ) {
            result = "file://" + result.substring(5,result.length);
        }
        if ( result.substring(0,7) == "file://" ) {
            result = result.substring(7,result.length);
        }
        debug  && print("ZZ",result);
        return result;
    }else{
        //return an absolute url from a url relative to the window location
        // print("hi",  $master.first_script_window, $master.first_script_window && $master.first_script_window.location );
        // if( ( base = window.location ) &&
        if( ( base = ( ( $master.first_script_window && $master.first_script_window.location ) || window.location ) ) &&
            ( base != "about:blank" ) &&
            base.href &&
            (base.href.length > 0) ) {

            base_uri = Ruby.URI.parse(base.href);
            new_uri = Ruby.URI.parse(path);
            result = Ruby.eval("lambda { |a,b| a+b; }")(base_uri,new_uri)+"";
            debug && print("IIII",result);
            return result;

            base = base.href.substring(0, base.href.lastIndexOf('/'));
            var result;
            // print("XXXXX",base);
            if ( base[base.length-1] == "/" || path[0] == "/" ) {
                result = base + path;
            } else {
                result = base + '/' + path;
            }
            if ( result.substring(0,6) == "file:/" && result[6] != "/" ) {
                result = "file://" + result.substring(5,result.length);
            }
            debug &&  print("****",result);
            return result;
        } else {
            // print("RRR",result);
            return "file://"+Ruby.File.expand_path(path);
        }
    }
};

$env.connection = $master.connection || function(xhr, responseHandler, data){
    var url = Ruby.URI.parse(xhr.url);
    var connection;
    var resp;
    // print("xhr",xhr.url);
    // print("xhr",url);
    if ( /^file\:/.test(url) ) {
        // experimental hack
        try {
            Ruby.eval("require 'envjs/net/cgi'");
            resp = connection = new Ruby.Envjs.Net.CGI( xhr, data );
        } catch(e) {
        try{
            if ( xhr.method == "PUT" ) {
                var text =  data || "" ;
                $env.writeToFile(text, url);
            } else if ( xhr.method == "DELETE" ) {
                $env.deleteFile(url);
            } else {
                Ruby.eval("require 'envjs/net/file'");
                var request = new Ruby.Envjs.Net.File.Get( url.path );
                connection = Ruby.Envjs.Net.File.start( url.host, url.port );
                resp = connection.request( request );
                //try to add some canned headers that make sense
                
                try{
                    if(xhr.url.match(/html$/)){
                        xhr.responseHeaders["Content-Type"] = 'text/html';
                    }else if(xhr.url.match(/.xml$/)){
                        xhr.responseHeaders["Content-Type"] = 'text/xml';
                    }else if(xhr.url.match(/.js$/)){
                        xhr.responseHeaders["Content-Type"] = 'text/javascript';
                    }else if(xhr.url.match(/.json$/)){
                        xhr.responseHeaders["Content-Type"] = 'application/json';
                    }else{
                        xhr.responseHeaders["Content-Type"] = 'text/plain';
                    }
                    //xhr.responseHeaders['Last-Modified'] = connection.getLastModified();
                    //xhr.responseHeaders['Content-Length'] = headerValue+'';
                    //xhr.responseHeaders['Date'] = new Date()+'';*/
                }catch(e){
                    $env.warn('failed to load response headers',e);
                }
                
            }
        } catch (e) {
            connection = null;
            xhr.readyState = 4;
            if(e.toString().match(/Errno::ENOENT/)) {
                xhr.status = "404";
                xhr.statusText = "Not Found";
                xhr.responseText = undefined;
            } else {
                xhr.status = "500";
                xhr.statusText = "Local File Protocol Error";
                xhr.responseText = "<html><head/><body><p>"+ e+ "</p></body></html>";
            }
        }
        }
    } else { 
        Ruby.eval("require 'net/http'");

        var req;
        var path;
        try {
            path = url.request_uri();
        } catch(e) {
            path = url.path;
        }
        if ( xhr.method == "GET" ) {
            req = new Ruby.Net.HTTP.Get( path );
        } else if ( xhr.method == "POST" ) {
            req = new Ruby.Net.HTTP.Post( path );
        } else if ( xhr.method == "PUT" ) {
            req = new Ruby.Net.HTTP.Put( path );
        }

        for (var header in xhr.headers){
            $master.add_req_field( req, header, xhr.headers[header] );
        }
	
	//write data to output stream if required
        if(data&&data.length&&data.length>0){
	    if ( xhr.method == "PUT" || xhr.method == "POST" ) {
                Ruby.eval("lambda { |req,data| req.body = data}").call(req,data);
                // req.body = data;
            }
	}
	
        try {
            connection = Ruby.Net.HTTP.new( url.host, url.port );
            if (url.scheme === "https") {
                Ruby.eval("require 'net/https'");
                connection.use_ssl = true;
            }
            connection.start();
            resp = connection.request(req);
        } catch(e) {
            $env.warn("XHR net request failed: "+e);
            // FIX: do the on error stuff ...
            throw e;
        }

    }
    if(connection){
        try{
            if (false) {
            var respheadlength = connection.getHeaderFields().size();
            // Stick the response headers into responseHeaders
            for (var i = 0; i < respheadlength; i++) { 
                var headerName = connection.getHeaderFieldKey(i); 
                var headerValue = connection.getHeaderField(i); 
                if (headerName)
                    xhr.responseHeaders[headerName+''] = headerValue+'';
            }
            }
            resp.each(function(k,v){
                xhr.responseHeaders[k] = v;
            });
        }catch(e){
            $env.error('failed to load response headers: '+e);
            throw e;
        }
        
        xhr.readyState = 4;
        xhr.status = parseInt(resp.code,10) || 0;
        xhr.statusText = connection.responseMessage || "";
        
        var contentEncoding = resp["Content-Encoding"] || "utf-8",
        baos = new Ruby.StringIO,
        length,
        stream = null,
        responseXML = null;

        try{
            var lower = contentEncoding.toLowerCase();
            stream = ( lower == "gzip" || lower == "decompress" ) ?
                ( Ruby.raise("java") && new java.util.zip.GZIPInputStream(resp.getInputStream()) ) : resp;
        }catch(e){
            if (resp.code == "404")
                $env.info('failed to open connection stream \n' +
                          e.toString(), e);
            else
                $env.error('failed to open connection stream \n' +
                           e.toString(), e);
            stream = resp;
        }
        
        baos.write(resp.body);

        baos.close();
        connection.finish();

        xhr.responseText = baos.string();
    }
    if(responseHandler){
        $env.debug('calling ajax response handler');
        responseHandler();
    }
};

var extract_line =
    Ruby.eval(
"lambda { |e| \
  begin; \
    e.stack.to_s.split(%(\n))[1].match(/:([^:]*)$/)[1]; \
  rescue; %(unknown); end; \
}");

var get_exception = window.get_exception =
    Ruby.eval(" \
lambda { |e| \
  estr = e.to_s; \
  estr.gsub!(/(<br \\/>)+/, %( )); \
  ss = ''; \
  ss = ss + %(Exception: ) + estr + %(\n); \
  begin; \
  e.stack.to_s.split(%(\n)).each do |line| \
    m = line.match(/(.*)@([^@]*)$/); \
    m[2] == %(:0) && next; \
    s = m[1]; \
    s.gsub!(/(<br \\/>)+/, %( )); \
    limit = 100; \
    if ( s.length > limit ); \
      s = s[0,limit] + %(...); \
    end; \
    ss = ss + m[2] + %( ) + s + %(\n); \
  end; \
  rescue; end; \
  ss; \
} \
");

var get_exception_trace = window.get_exception_trace =
    Ruby.eval(" \
lambda { |e| \
  estr = e.to_s; \
  estr.gsub!(/(<br \\/>)+/, %( )); \
  begin; \
  ss = ''; \
  e.stack.to_s.split(%(\n)).each do |line| \
    m = line.match(/(.*)@([^@]*)$/); \
    m[2] == %(:0) && next; \
    s = m[1]; \
    s.gsub!(/(<br \\/>)+/, %( )); \
    limit = 100; \
    if ( s.length > limit ); \
      s = s[0,limit] + %(...); \
    end; \
    ss = ss + m[2] + %( ) + s +%(\n); \
  end; \
  rescue; end; \
  ss; \
} \
");

var print_exception = window.print_exception =
    Ruby.eval(" \
lambda { |e| \
  estr = e.to_s; \
  estr.gsub!(/(<br \\/>)+/, %( )); \
  $stderr.print(%(Exception: ),estr,%(\n)); \
  begin; \
  e.stack.to_s.split(%(\n)).each do |line| \
    m = line.match(/(.*)@([^@]*)$/); \
    m[2] == %(:0) && next; \
    s = m[1]; \
    s.gsub!(/(<br \\/>)+/, %( )); \
    limit = 100; \
    if ( s.length > limit ); \
      s = s[0,limit] + %(...); \
    end; \
    $stderr.print(m[2],%( ),s,%(\n)); \
  end; \
  rescue; end; \
} \
");

var print_exception_trace = window.print_exception_trace =
    Ruby.eval(" \
lambda { |e| \
  estr = e.to_s; \
  estr.gsub!(/(<br \\/>)+/, %( )); \
  begin; \
  e.stack.to_s.split(%(\n)).each do |line| \
    m = line.match(/(.*)@([^@]*)$/); \
    m[2] == %(:0) && next; \
    s = m[1]; \
    s.gsub!(/(<br \\/>)+/, %( )); \
    limit = 100; \
    if ( s.length > limit ); \
      s = s[0,limit] + %(...); \
    end; \
    $stderr.print(m[2],%( ),s,%(\n)); \
  end; \
  rescue; end; \
} \
");

$env.lineSource = function(e){
    if(e){
        print_exception.call(e);
        return extract_line.call(e);
    } else {
        return "";
    }
};
    
$env.loadInlineScript = function(script){
    var undef;
    if (script.text === undef ||
        script.text === null ||
        script.text.match(/^\s*$/)) {
        return;
    }
    var original_script_window = $master.first_script_window;
    // debug("lis",original_script_window,original_script_window.isInner);
    // debug("XX",window,window.isInner);
    if ( !$master.first_script_window ) {
        // $master.first_script_window = window;
    }
    // debug("lix",$master.first_script_window,$master.first_script_window.isInner,$w,$w.isInner);
    try {
        $master.evaluate(script.text,$inner);
    } catch(e) {
        $env.error("error evaluating script: "+script.text);
        $env.error(e);
        // try { throw new Error("here") } catch(b) { $env.error(b.stack); }
        // throw e;
    }
    // $master.first_script_window = original_script_window;
    // debug("lis",original_script_window,original_script_window.isInner);
};
    
$env.writeToTempFile = function(text, suffix){
    $env.debug("writing text to temp url : " + suffix);
    // print(text);
    // Create temp file.
    Ruby.eval("require 'envjs/tempfile'");
    var temp = new Ruby.Envjs.TempFile( "envjs-tmp", suffix );
    
    // Write to temp file
    temp.write(text);
    temp.close();
    return temp.getAbsolutePath().toString()+'';
};
    
$env.writeToFile = function(text, url){
    // print("writing text to url : " + url);
    $env.debug("writing text to url : " + url);
    if ( url.substring(0,7) == "file://" ) {
        url = url.substring(7,url.length);
    }
    var file = Ruby.open( url, "w" );
    // Write to temp file
    file.write(text);
    file.close();
};
    
$env.deleteFile = function(url){
    Ruby.File.unlink(url);
};

$env.__eval__ = function(script,scope){
    if (script == "")
        return undefined;
    try {
        var scope = node;
        var __scopes__ = [];
        var original = script;
        if(scope) {
            // script = "(function(){return eval(original)}).call(__scopes__[0])";
            script = "return (function(){"+original+"}).call(__scopes__[0])";
            while(scope) {
                __scopes__.push(scope);
                scope = scope.parentNode;
                script = "with(__scopes__["+(__scopes__.length-1)+"] ){"+script+"};";
            }
        }
        script = "function(original,__scopes__){"+script+"}";
        // print("scripta",script);
        // print("scriptb",original);
        var original_script_window = $master.first_script_window;
        if ( !$master.first_script_window ) {
            // $master.first_script_window = window;
        }
        // FIX!!!
        var $inner = node.ownerDocument._parentWindow["$inner"];
        var result = $master.evaluate(script,$inner)(original,__scopes__);
        // $master.first_script_window = original_script_window;
        return result;
    }catch(e){
        $warn("Exception during on* event eval: "+e);
        throw e;
    }
};

$env.newwindow = function(openingWindow, parentArg, url, outer,xhr_options){
// print(location);
// print("url",url,window.location,openingWindow);
// print("parent",parentArg);
    var options = {
        opener: openingWindow,
        parent: parentArg,
        url: $env.location(url),
        xhr: xhr_options
    };

    // print("$w",$w);
    // print("$ww",$w.window);
    // print("$ww",$w === $w.window);
    var pair = $env.new_window(outer);
    var proxy = pair[0];
    var new_window = pair[1];
    options.proxy = proxy;
    new_window.$options = options;
    // print("$w",$w);
    $master.load($master.Ruby.Envjs.ENVJS, new_window);
    return proxy;
};

$env.reload = function(oldWindowProxy, url,options){
    // print("reload",window,oldWindowProxy,url);
    $env.newwindow( oldWindowProxy.opener,
                    oldWindowProxy.parent,
                    url,
                    oldWindowProxy,
                    options );
};

$env.sleep = function(n){Ruby.sleep(n/1000.);};

$env.loadIntoFnsScope = function(file) {
    return load(file);
}

$env.runAsync = function(fn){
    $env.debug("running async");
        
    var run = $env.sync( function(){ fn(); } );
        
    try{
        $env.spawn(run);
    }catch(e){
        $env.error("error while running async", e);
    }
};
    
// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// End:

/**
 * @author thatcher
 */
var Envjs = function(){
    if(arguments.length === 2){
        for ( var i in arguments[1] ) {
            var g = arguments[1].__lookupGetter__(i), 
                s = arguments[1].__lookupSetter__(i);
            if ( g || s ) {
                if ( g ) { Envjs.__defineGetter__(i, g); }
                if ( s ) { Envjs.__defineSetter__(i, s); }
            } else {
                Envjs[i] = arguments[1][i];
            }
        }
    }

    if (arguments[0] !== null && arguments[0] !== "") {
        window.location = arguments[0];
    }
};

/*
*	core.js
*/
(function($env){
    
    //You can emulate different user agents by overriding these after loading env
    $env.appCodeName  = "Envjs";//eg "Mozilla"
    $env.appName      = "Resig/20070309 BirdDog/0.0.0.1";//eg "Gecko/20070309 Firefox/2.0.0.3"

    //set this to true and see profile/profile.js to select which methods
    //to profile
    $env.profile = false;
    
    $env.log = $env.log || function(msg, level){};
	
    $env.DEBUG  = 4;
    $env.INFO   = 3;
    $env.WARN   = 2;
    $env.ERROR  = 1;
	$env.NONE   = 0;
	
    //set this if you want to get some internal log statements
    $env.logLevel = $env.INFO;
    $env.logLevel = $env.ERROR;
    $env.logLevel = $env.DEBUG;
    $env.logLevel = $env.WARN;
    
    $env.debug  = function(msg){
		if($env.logLevel >= $env.DEBUG) {
            $env.log(msg,"DEBUG"); 
        }
    };
    $env.info = function(msg){
        if($env.logLevel >= $env.INFO) {
            $env.log(msg,"INFO"); 
        }
    };
    $env.warn   = function(msg){
        if($env.logLevel >= $env.WARN) {
            $env.log(msg,"WARNIING");    
        }
    };
    $env.error = function(msg, e){
        if ($env.logLevel >= $env.ERROR) {
          var line = $env.lineSource(e);
            if ( line !== "" ) { line = " Line: "+ line ;}
			$env.log(msg + line, 'ERROR');
                        if(e) {
                            $env.log(e || "", 'ERROR');
                        }
		}
    };
    
    $env.debug("Initializing Core Platform Env");


    // if we're running in an environment without env.js' custom extensions
    // for manipulating the JavaScript scope chain, put in trivial emulations
    $env.debug("performing check for custom Java methods in env-js.jar");
    var countOfMissing = 0, dontCare;
    try { dontCare = getFreshScopeObj; }
    catch (ex){      getFreshScopeObj  = function(){ return {}; };
                                                       countOfMissing++; }
    try { dontCare = getProxyFor; }
    catch (ex){      getProxyFor       = function(obj){ return obj; };
                                                       countOfMissing++; }
    try { dontCare = getScope; }
    catch (ex){      getScope          = function(){}; countOfMissing++; }
    try { dontCare = setScope; }
    catch (ex){      setScope          = function(){}; countOfMissing++; }
    try { dontCare = configureScope; }
    catch (ex){      configureScope    = function(){}; countOfMissing++; }
    try { dontCare = restoreScope; }
    catch (ex){      restoreScope      = function(){}; countOfMissing++; }
    try { $env.loadIntoFnsScope = loadIntoFnsScope; }
    catch (ex){      $env.loadIntoFnsScope = load;     countOfMissing++; }
    if (countOfMissing != 0 && countOfMissing != 7)
        $env.warn("Some but not all of scope-manipulation functions were " +
                  "not present in environment.  JavaScript execution may " +
                  "not occur correctly.");

    $env.lineSource = $env.lineSource || function(e){};
    
    //resolves location relative to base or window location
    $env.location = $env.location || function(path, base){};
    
    $env.sync = $env.sync || function(fn){
      return function(){ return fn.apply(this,arguments); };
    };

    $env.spawn = $env.spawn || function(fn) {
      setTimeout(fn,0);
    };

    $env.sleep = $env.sleep || function(){};

    $env.javaEnabled = false;  

    //Used in the XMLHttpRquest implementation to run a
    // request in a seperate thread
    $env.runAsync = $env.runAsync || function(fn){};
        
    //Used to write to a local file
    $env.writeToFile = $env.writeToFile || function(text, url){};
        
    //Used to write to a local file
    $env.writeToTempFile = $env.writeToTempFile || function(text, suffix){};
    
    //Used to delete a local file
    $env.deleteFile = $env.deleteFile || function(url){};
    
    $env.connection = $env.connection || function(xhr, responseHandler, data){};
    
    $env.parseHTML = function(htmlstring){};
    $env.parseXML = function(xmlstring){};
    $env.xpath = function(expression, doc){};
    
    $env.tmpdir         = ''; 
    $env.os_name        = ''; 
    $env.os_arch        = ''; 
    $env.os_version     = ''; 
    $env.lang           = ''; 
    $env.platform       = "";
    
    $env.scriptTypes = {
        "text/javascript"   :true,
        "text/envjs"        :true
    };
    
    $env.onScriptLoadError = $env.onScriptLoadError || function(){};
    $env.loadLocalScript = function(script, parser){
        $env.debug("loading script ");
// print("loadloacl");
// try{throw new Error}catch(e){print(e.stack);}
        var types, type, src, i, base, 
            docWrites = [],
            write = document.write,
            writeln = document.writeln,
            okay = true;
        // SMP: see also the note in html/document.js about script.type
        var script_type = script.type === null ? "text/javascript" : script.type;
        try{
            if(script_type){
                types = script_type?script_type.split(";"):[];
                for(i=0;i<types.length;i++){
                    if($env.scriptTypes[types[i]]){
						if(script.src){
                            $env.info("loading allowed external script: " + script.src);
                            //lets you register a function to execute 
                            //before the script is loaded
                            if($env.beforeScriptLoad){
                                for(src in $env.beforeScriptLoad){
                                    if(script.src.match(src)){
                                        $env.beforeScriptLoad[src]();
                                    }
                                }
                            }
                            base = "" + window.location;
                            var filename = $env.location(script.src, base );
                            try {                      
                              load(filename);
                            } catch(e) {
                              $env.warn("could not load script "+ filename +": "+e );
                              okay = false;
                            }
                            //lets you register a function to execute 
                            //after the script is loaded
                            if($env.afterScriptLoad){
                                for(src in $env.afterScriptLoad){
                                    if(script.src.match(src)){
                                        $env.afterScriptLoad[src]();
                                    }
                                }
                            }
                        }else{
                            $env.loadInlineScript(script);
                        }
                    }else{
                        if(!script.src && script_type == "text/javascript"){
                            $env.loadInlineScript(script);
                        } else {
                          // load prohbited ...
                          okay = false;
                        }
                    }
                }
            }else{
                // SMP this branch is probably dead ...
                //anonymous type and anonymous src means inline
                if(!script.src){
                    $env.loadInlineScript(script);
                }
            }
        }catch(e){
            okay = false;
            $env.error("Error loading script.", e);
            $env.onScriptLoadError(script);
        }finally{
            /*if(parser){
                parser.appendFragment(docWrites.join(''));
			}
			//return document.write to it's non-script loading form
            document.write = write;
            document.writeln = writeln;*/
        }
        return okay;
    };
    $env.loadInlineScript = $env.loadInlineScript || function(script){};
    
    $env.loadFrame = function(frameElement, url){
        try {
            if (frameElement._content){
                $env.unload(frameElement._content);
                $env.reload(frameElement._content, url);
            }
            else {
              var v = $env.newwindow($w,
                    frameElement.ownerDocument.parentWindow, url);
              frameElement._content = v;
            }
        } catch(e){
            $env.error("failed to load frame content: from " + url, e);
        }
    };
    
    $env.reload = $env.reload || function(oldWindowProxy, url){
        var newWindowProxy = $env.newwindow(
                                 oldWindowProxy.opener,
                                 oldWindowProxy.parent,
                                 url);
        var newWindow = newWindowProxy.__proto__;

        oldWindowProxy.__proto__ = newWindow;
        newWindow.$thisWindowsProxyObject = oldWindowProxy;
        newWindow.document._parentWindow = oldWindowProxy;
    };

    $env.newwindow = $env.newwindow || function(openingWindow, parentArg, url){
        var newWindow = $env.getFreshScopeObj();
        var newProxy  = $env.getProxyFor(newWindow);
        newWindow.$thisWindowsProxyObject = newProxy;

        var local__window__    = $env.window,
            local_env          = $env,
            local_opener       = openingWindow,
            local_parent       = parentArg ? parentArg : newWindow;

        var inNewContext = function(){
            local__window__(newWindow,        // object to "window-ify"
                            local_env,        // our scope for globals
                            local_parent,     // win's "parent"
                            local_opener,     // win's "opener"
                            local_parent.top, // win's "top"
                            false             // this win isn't the original
                           );
print("QQ");
            if (url)
                // newWindow.__loadAWindowsDocument__(url);
                $env.load(url);
        };

        var scopes = recordScopesOfKeyObjects(inNewContext);
        setScopesOfKeyObjects(inNewContext, newWindow);
print("ZZ");
        inNewContext(); // invoke local fn to window-ify new scope object
print("TT");
        restoreScopesOfKeyObjects(inNewContext, scopes);
        return newProxy;
    };

    function recordScopesOfKeyObjects(fnToExecInOtherContext){
        return {                //   getScope()/setScope() from Window.java
            frame :          getScope(fnToExecInOtherContext),
            window :         getScope($env.window),
            global_load :    getScope($env.loadIntoFnsScope),
            local_load :     getScope($env.loadLocalScript)
        };
    }

    function setScopesOfKeyObjects(fnToExecInOtherContext, windowObj){
        setScope(fnToExecInOtherContext,  windowObj);
        setScope($env.window,             windowObj);
        setScope($env.loadIntoFnsScope,   windowObj);
        setScope($env.loadLocalScript,    windowObj);
    }

    function restoreScopesOfKeyObjects(fnToExecInOtherContext, scopes){
        setScope(fnToExecInOtherContext,  scopes.frame);
        setScope($env.window,             scopes.window);
        setScope($env.loadIntoFnsScope,   scopes.global_load);
        setScope($env.loadLocalScript,    scopes.local_load);
    }

})($env);

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
/*
*	window.js
*   - this file will be wrapped in a closure providing the window object as $w
*/
// a logger or empty function available to all modules.
var $log = $env.log,
    $debug = $env.debug,
    $info = $env.info,
    $warn = $env.warn,
    $error = $env.error;
    
//The version of this application
var $version = "0.1";
//This should be hooked to git or svn or whatever
var $revision = "0.0.0.0";

//These descriptions of window properties are taken loosely David Flanagan's
//'JavaScript - The Definitive Guide' (O'Reilly)

/**> $cookies - see cookie.js <*/
// read only boolean specifies whether the window has been closed
var $closed = false;

// a read/write string that specifies the default message that appears in the status line 
var $defaultStatus = "Done";

// a read-only reference to the Document object belonging to this window
/**> $document - See document.js <*/

//IE only, refers to the most recent event object - this maybe be removed after review
var $event = null;

//A read-only array of window objects
//var $frames = [];    // TODO: since window.frames can be accessed like a
                       //   hash, will need an object to really implement

// a read-only reference to the History object
/**>  $history - see location.js <**/

// read-only properties that specify the height and width, in pixels
var $innerHeight = 600, $innerWidth = 800;

// a read-only reference to the Location object.  the location object does expose read/write properties
/**> $location - see location.js <**/

// The name of window/frame.  Set directly, when using open(), or in frameset.
// May be used when specifying the target attribute of links
var $name;

// a read-only reference to the Navigator object
/**> $navigator - see navigator.js <**/

// a read/write reference to the Window object that contained the script that called open() to 
//open this browser window.  This property is valid only for top-level window objects.

var $opener = $openingWindow = options.opener;

// Read-only properties that specify the total height and width, in pixels, of the browser window.
// These dimensions include the height and width of the menu bar, toolbars, scrollbars, window
// borders and so on.  These properties are not supported by IE and IE offers no alternative 
// properties;
var $outerHeight = $innerHeight, $outerWidth = $innerWidth;

// Read-only properties that specify the number of pixels that the current document has been scrolled
//to the right and down.  These are not supported by IE.
var $pageXOffset = 0, $pageYOffset = 0;


// A read-only reference to the Window object that contains this window
// or frame.  If the window is a top-level window, parent refers to
// the window itself.  If this window is a frame, this property refers
// to the window or frame that conatins it.
var $parent = options.parent || window;
try {
    if ($parentWindow.$thisWindowsProxyObject)
        $parent = $parentWindow.$thisWindowsProxyObject;
} catch(e){}



// a read-only refernce to the Screen object that specifies information about the screen: 
// the number of available pixels and the number of available colors.
/**> $screen - see screen.js <**/
// read only properties that specify the coordinates of the upper-left corner of the screen.
var $screenX = 0, $screenY = 0;
var $screenLeft = $screenX, $screenTop = $screenY;

// a read/write string that specifies the current contents of the status line.
var $status = '';

// a read-only reference to the top-level window that contains this window.  If this
// window is a top-level window it is simply a refernce to itself.  If this window 
// is a frame, the top property refers to the top-level window that contains the frame.
var $top = $parent && $parent.top || this;

// the window property is identical to the self property and to this obj
var $window = $w;
try {
    if ($w.$thisWindowsProxyObject)
        $window = $w.$thisWindowsProxyObject;
} catch(e){}
options.proxy && ( $window = options.proxy );

$debug("Initializing Window.");
__extend__($w,{
  get closed(){return $closed;},
  get defaultStatus(){return $defaultStatus;},
  set defaultStatus(_defaultStatus){$defaultStatus = _defaultStatus;},
  //get document(){return $document;}, - see document.js
  get event(){return $event;},

  get frames(){return undefined;}, // TODO: not yet any code to maintain list
  get length(){return undefined;}, //   should be frames.length, but.... TODO

  //get history(){return $history;}, - see history.js
  get innerHeight(){return $innerHeight;},
  get innerWidth(){return $innerWidth;},
  get clientHeight(){return $innerHeight;},
  get clientWidth(){return $innerWidth;},
  //get location(){return $location;}, see location.js
  get name(){return $name;},
  set name(newName){ $name = newName; },
  //get navigator(){return $navigator;}, see navigator.js
  get opener(){return $opener;},
  get outerHeight(){return $outerHeight;},
  get outerWidth(){return $outerWidth;},
  get pageXOffest(){return $pageXOffset;},
  get pageYOffset(){return $pageYOffset;},
  get parent(){return $parent;},
  //get screen(){return $screen;}, see screen.js
  get screenLeft(){return $screenLeft;},
  get screenTop(){return $screenTop;},
  get screenX(){return $screenX;},
  get screenY(){return $screenY;},
  get self(){return $window;},
  get status(){return $status;},
  set status(_status){$status = _status;},
  get top(){return $top || $window;},
  get window(){return $window;},

  // DOM0

  Image: function() {
    return document.createElement("img");
  }
  /*,
  toString : function(){
      return '[object Window]';
  } FIX SMP */
});

$w.open = function(url, name, features, replace){
  if (features)
    $env.warn("'features' argument for 'window.open()' not yet implemented");
  if (replace)
    $env.warn("'replace' argument for 'window.open()' not yet implemented");

  var undef;
  if(url === undef || url === "") {
    url = "about:blank";
  }

  var newWindow = $env.newwindow(this, null, url);
  newWindow.$name = name;
  return newWindow;
};

$w.close = function(){
  $env.unload($w);
  $closed = true;
};     

$env.unload = function(windowToUnload){
  try {
    var event = windowToUnload.document.createEvent();
    event.initEvent("unload");
    windowToUnload.document.getElementsByTagName('body')[0].
      dispatchEvent(event, false);
  }
  catch (e){}   // maybe no/bad document loaded, ignore

  var event = windowToUnload.document.createEvent();
  event.initEvent("unload");
  windowToUnload.dispatchEvent(event, false);
};
  
  
$env.load = function(url,xhr_options){
    $location = $env.location(url);
    __setHistory__($location);
try{
    $w.document.load($location,xhr_options);
}catch(e){
  $warn("Exception while loading window: "+e);
  throw e;
}
};


/* Time related functions - see timer.js
*   - clearTimeout
*   - clearInterval
*   - setTimeout
*   - setInterval
*/

/*
* Events related functions - see event.js
*   - addEventListener
*   - attachEvent
*   - detachEvent
*   - removeEventListener
*   
* These functions are identical to the Element equivalents.
*/

/*
* UIEvents related functions - see uievent.js
*   - blur
*   - focus
*
* These functions are identical to the Element equivalents.
*/

/* Dialog related functions - see dialog.js
*   - alert
*   - confirm
*   - prompt
*/

/* Screen related functions - see screen.js
*   - moveBy
*   - moveTo
*   - print
*   - resizeBy
*   - resizeTo
*   - scrollBy
*   - scrollTo
*/

/* CSS related functions - see css.js
*   - getComputedStyle
*/

/*
* Shared utility methods
*/
// Helper method for extending one object with another.  
function __extend__(a,b) {
	for ( var i in b ) {
		var g = b.__lookupGetter__(i), s = b.__lookupSetter__(i);
		if ( g || s ) {
			if ( g ) a.__defineGetter__(i, g);
			if ( s ) a.__defineSetter__(i, s);
		} else
			a[i] = b[i];
	} return a;
};
	

// from ariel flesler http://flesler.blogspot.com/2008/11/fast-trim-function-for-javascript.html
// this might be a good utility function to provide in the env.core
// as in might be useful to the parser and other areas as well
function trim( str ){
    return (str || "").replace( /^\s+|\s+$/g, "" );
    
};
/*function trim( str ){
    var start = -1,
    end = str.length;
    /*jsl:ignore*
    while( str.charCodeAt(--end) < 33 );
    while( str.charCodeAt(++start) < 33 );
    /*jsl:end*
    return str.slice( start, end + 1 );
};*/

//from jQuery
function __setArray__( target, array ) {
	// Resetting the length to 0, then using the native Array push
	// is a super-fast way to populate an object with array-like properties
	target.length = 0;
	Array.prototype.push.apply( target, array );
};
//DOMImplementation
$debug("Defining DOMImplementation");
/**
 * @class  DOMImplementation - provides a number of methods for performing operations
 *   that are independent of any particular instance of the document object model.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 */
var DOMImplementation = function() {
    this.preserveWhiteSpace = false;  // by default, ignore whitespace
    this.namespaceAware = true;       // by default, handle namespaces
    this.errorChecking  = true;       // by default, test for exceptions
};

__extend__(DOMImplementation.prototype,{
    // @param  feature : string - The package name of the feature to test.
    //      the legal only values are "XML" and "CORE" (case-insensitive).
    // @param  version : string - This is the version number of the package
    //       name to test. In Level 1, this is the string "1.0".*
    // @return : boolean
    hasFeature : function(feature, version) {
        var ret = false;
        if (feature.toLowerCase() == "xml") {
            ret = (!version || (version == "1.0") || (version == "2.0"));
        }
        else if (feature.toLowerCase() == "core") {
            ret = (!version || (version == "2.0"));
        }
        else if (feature == "http://www.w3.org/TR/SVG11/feature#BasicStructure") {
            ret = (version == "1.1");
        }
        return ret;
    },
    createDocumentType : function(qname, publicid, systemid){
        return new DOMDocumentType();
    },
    createDocument : function(nsuri, qname, doctype){
        //TODO - this currently returns an empty doc
        //but needs to handle the args
        return new DOMDocument(this, null);
    },
    createHTMLDocument : function(title){
        // N.B. explict window on purpose ...
        var doc = new HTMLDocument(this, window, "");
        var html = doc.createElement("html"); doc.appendChild(html);
        var head = doc.createElement("head"); html.appendChild(head);
        var body = doc.createElement("body"); html.appendChild(body);
        var t = doc.createElement("title"); head.appendChild(t);
        if( title) {
            t.appendChild(doc.createTextNode(title));
        }
        return doc;
    },
    translateErrCode : function(code) {
        //convert DOMException Code to human readable error message;
      var msg = "";

      switch (code) {
        case DOMException.INDEX_SIZE_ERR :                // 1
           msg = "INDEX_SIZE_ERR: Index out of bounds";
           break;

        case DOMException.DOMSTRING_SIZE_ERR :            // 2
           msg = "DOMSTRING_SIZE_ERR: The resulting string is too long to fit in a DOMString";
           break;

        case DOMException.HIERARCHY_REQUEST_ERR :         // 3
           msg = "HIERARCHY_REQUEST_ERR: The Node can not be inserted at this location";
           break;

        case DOMException.WRONG_DOCUMENT_ERR :            // 4
           msg = "WRONG_DOCUMENT_ERR: The source and the destination Documents are not the same";
           break;

        case DOMException.INVALID_CHARACTER_ERR :         // 5
           msg = "INVALID_CHARACTER_ERR: The string contains an invalid character";
           break;

        case DOMException.NO_DATA_ALLOWED_ERR :           // 6
           msg = "NO_DATA_ALLOWED_ERR: This Node / NodeList does not support data";
           break;

        case DOMException.NO_MODIFICATION_ALLOWED_ERR :   // 7
           msg = "NO_MODIFICATION_ALLOWED_ERR: This object cannot be modified";
           break;

        case DOMException.NOT_FOUND_ERR :                 // 8
           msg = "NOT_FOUND_ERR: The item cannot be found";
           break;

        case DOMException.NOT_SUPPORTED_ERR :             // 9
           msg = "NOT_SUPPORTED_ERR: This implementation does not support function";
           break;

        case DOMException.INUSE_ATTRIBUTE_ERR :           // 10
           msg = "INUSE_ATTRIBUTE_ERR: The Attribute has already been assigned to another Element";
           break;

        // Introduced in DOM Level 2:
        case DOMException.INVALID_STATE_ERR :             // 11
           msg = "INVALID_STATE_ERR: The object is no longer usable";
           break;

        case DOMException.SYNTAX_ERR :                    // 12
           msg = "SYNTAX_ERR: Syntax error";
           break;

        case DOMException.INVALID_MODIFICATION_ERR :      // 13
           msg = "INVALID_MODIFICATION_ERR: Cannot change the type of the object";
           break;

        case DOMException.NAMESPACE_ERR :                 // 14
           msg = "NAMESPACE_ERR: The namespace declaration is incorrect";
           break;

        case DOMException.INVALID_ACCESS_ERR :            // 15
           msg = "INVALID_ACCESS_ERR: The object does not support this function";
           break;

        default :
           msg = "UNKNOWN: Unknown Exception Code ("+ code +")";
      }

      return msg;
    }
});


if(false){
$debug("Initializing document.implementation");
var $implementation =  new DOMImplementation();
// $implementation.namespaceAware = false;
$implementation.errorChecking = false;
}
    
// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
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
/*
*	history.js
*/

	var $currentHistoryIndex = 0;
	var $history = [];
	
	// Browser History
	$w.__defineGetter__("history", function(){	
		return {
			get length(){ return $history.length; },
			back : function(count){
				if(count){
					go(-count);
				}else{go(-1);}
			},
			forward : function(count){
				if(count){
					go(count);
				}else{go(1);}
			},
			go : function(target){
				if(typeof target == "number"){
					target = $currentHistoryIndex+target;
					if(target > -1 && target < $history.length){
						if($history[target].location == "hash"){
							$w.location.hash = $history[target].value;
						}else{
							$w.location = $history[target].value;
						}
						$currentHistoryIndex = target;
						//remove the last item added to the history
						//since we are moving inside the history
						$history.pop();
					}
				}else{
					//TODO: walk throu the history and find the 'best match'
				}
			}
		};
	});

	//Here locationPart is the particutlar method/attribute 
	// of the location object that was modified.  This allows us
	// to modify the correct portion of the location object
	// when we navigate the history
	var __setHistory__ = function( value, locationPart){
            if ( value == "about:blank" ) {
                return;
            }
	    $debug("adding value to history: " +value);
		$currentHistoryIndex++;
		$history.push({
			location: locationPart||"href",
			value: value
		});
	};

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// End:
/*
*	navigator.js
*   - requires env
*/
$debug("Initializing Window Navigator.");

var $appCodeName  = $env.appCodeName;//eg "Mozilla"
var $appName      = $env.appName;//eg "Gecko/20070309 Firefox/2.0.0.3"

// Browser Navigator
$w.__defineGetter__("navigator", function(){	
	return {
		get appCodeName(){
			return $appCodeName;
		},
		get appName(){
			return $appName;
		},
		get appVersion(){
			return $version +" ("+ 
			    $w.navigator.platform +"; "+
			    "U; "+//?
			    $env.os_name+" "+$env.os_arch+" "+$env.os_version+"; "+
			    $env.lang+"; "+
			    "rv:"+$revision+
			  ")";
		},
		get cookieEnabled(){
			return true;
		},
		get mimeTypes(){
			return [];
		},
		get platform(){
			return $env.platform;
		},
		get plugins(){
			return [];
		},
		get userAgent(){
			return $w.navigator.appCodeName + "/" + $w.navigator.appVersion + " " + $w.navigator.appName;
		},
		javaEnabled : function(){
			return $env.javaEnabled;	
		}
	};
});

/*
*	eventLoop.js
*/

$debug("Initializing Window EventLoop.");

$w.setTimeout = function(fn, time){
  return $master.eventLoop.setTimeout($inner,fn,time);
};

$w.setInterval = function(fn, time){
  return $master.eventLoop.setInterval($inner,fn,time);
};

$w.clearInterval = $w.clearTimeout = function(num){
  return $master.eventLoop.clear(num);
};	

$w.$wait = $env.wait = $env.wait || function(wait) {
  return $master.eventLoop.wait(wait);
};/*
* event.js
*/
// Window Events
//$debug("Initializing Window Event.");
var $events = [{}],
    $onerror,
    $onload,
    $onunload;

function __addEventListener__(target, type, fn){

    //$debug("adding event listener \n\t" + type +" \n\tfor "+target+" with callback \n\t"+fn);
    if ( !target.uuid ) {
        target.uuid = $events.length;
        $events[target.uuid] = {};
    }
    if ( !$events[target.uuid][type] ){
        $events[target.uuid][type] = [];
    }
    if ( $events[target.uuid][type].indexOf( fn ) < 0 ){
        $events[target.uuid][type].push( fn );
    }
};


$w.addEventListener = function(type, fn){
    __addEventListener__(this, type, fn);
};


function __removeEventListener__(target, type, fn){
  if ( !target.uuid ) {
    target.uuid = $events.length;
    $events[target.uuid] = {};
  }
  if (!$events[target.uiid]) {
      return;
  }
  if ( !$events[target.uuid][type] ){
		$events[target.uuid][type] = [];
	}	
  $events[target.uuid][type] =
    $events[target.uuid][type].filter(function(f){
			return f != fn;
		});
};

$w.removeEventListener = function(type, fn){
    __removeEventListener__(this, type, fn)
};

function __dispatchEvent__(target, event, bubbles){
    try{
        $debug("dispatching event " + event.type);

        //the window scope defines the $event object, for IE(^^^) compatibility;
        $event = event;

        if (bubbles == undefined || bubbles == null)
            bubbles = true;

        if (!event.target) {
            //$debug("no event target : "+event.target);
            event.target = target;
        }
        //$debug("event target: " + event.target);
        var handled = false;
        if ( event.type && (target.nodeType             ||
                            target.window === window    || // compares outer objects under TM (inner == outer, but !== (currently)
                            target === window           ||
                            target.__proto__ === window ||
                            target.$thisWindowsProxyObject === window)) {
            //$debug("nodeType: " + target.nodeType);
            if ( target.uuid && $events[target.uuid][event.type] ) {
                var _this = target;
                $debug('calling event handlers '+$events[target.uuid][event.type].length);
                $events[target.uuid][event.type].forEach(function(fn){
                    $debug('calling event handler '+fn+' on target '+_this);
                    handled = (fn(event) == false) || handled;
                });
            }
            
            if (target["on" + event.type]) {
                $debug('calling event handler on'+event.type+' on target '+target);
                handled = (target["on" + event.type](event) == false) || handled;
            }

            // SMP FIX: cancel/stop prop
            if (!handled && event.$preventDefault) {
                handled = true;
            }
            
            // print(event.type,target,handled);

            if (!handled && event.type == "click" && target instanceof HTMLAnchorElement && target.href ) {
                // window.location = target.href;

                var url = target.href; 

                var skip = false;

                if (url[0] === "#") {
                    window.location.hash = url;
                    // print("return anchor only: "+window.location);
                    skip = true;
                }

                if (!skip) {
                    var now = window.location.href.replace(/^file:\/\//,"").replace(/#.*/,"");
                    var to = $master.first_script_window && $master.first_script_window.location.href;
                    // var to = $env.location(url,window.location.href != "about:blank" ? window.location.href: undefined);
                    // I'm not sure why this code is here ... looking at the FSW
                    // print("nu",now,url,to);
                    to = to || $env.location(url,window.location.href);
                    // print("nu",now,url,to);
                    if (to && to.indexOf(now)===0 && to[now.length]==="#") {
                        skip = true;
                    }
                }
                if (!skip) {
                    if (url && url.indexOf(now)===0 && url[now.length]==="#") {
                        // print("return diff anchor only");
                        skip = true;
                    }
                }
                if (!skip) {
                    // print($location, window.location.href === $location,  $location.indexOf("#")>0);
                    if (url === window.location.href && $location.indexOf("#")>0) {
                        // print('returning same with anchor');
                        skip = true;
                    }
                }

                if (!skip){
                    $env.reload(window, target.href, {referer: window.location.href});
                }
            }

            if (!handled && event.type == "click" &&
                target.form &&
                ( target instanceof HTMLInputElement || target instanceof HTMLTypeValueInputs ) &&
                ( ( target.tagName === "INPUT" &&
                    (target.type === "submit" ||
                     target.type === "image" ) ) ||
                  ( target.tagName === "BUTTON" &&
                    ( !target.type ||
                      target.type === "submit" ) ) ) ) {
                target.form.clk = target;
                try{
                    target.form.submit();
                    // __submit__(target.form);
                }catch(e){
                    print("oopse",e);
                    print(e.stack);
                    e.backtrace && print(e.backtrace().join("\n"));
                    throw e;
                };
                delete target.form.clk;
            }

            // print(event.type,target.type,target.constructor+"");
            // print("A",handled,event.type,target,target.type);
            if (!handled && event.type == "click" && target instanceof HTMLInputElement && ( target.type == "checkbox"  || target.type == "radio" ) ) {
                    target.checked = target.checked ? "" : "checked";
            }

            if (!handled && (event.type == "submit") && target instanceof HTMLFormElement) {
                $env.unload($w);
                var proxy = $w.window;
                var data;
                var boundary;
                if (target.enctype === "multipart/form-data") {
                    boundary = (new Date).getTime();
                }
                data = $master["static"].__formSerialize__(target,undefined,boundary);
                var options = {method: target.method || "get", referer: this.location.href};
                if (options.method.toLowerCase() === "post" || options.method.toLowerCase() === "put") {
                    options.data = data;
                    var undef;
                    data = undef;
                }
                if (boundary) {
                    options["Content-Type"] = "multipart/form-data; boundary="+boundary;
                } else {
                    options["Content-Type"] = 'application/x-www-form-urlencoded';
                }
                var action = target.action || window.location.href;
                if (data) {
                    if (action.indexOf("?") < 0) {
                        action = action + "?";
                    }
                    if (action[action.length-1] != "?") {
                        action = action + "&";
                    }
                    var params = unescape(data).split("&");
                    var new_params = [];
                    for(var pi=0; pi < params.length; pi++) {
                        var pair = params[pi].split("=");
                        new_params.push(escape(pair[0])+"="+escape(pair[1]));
                    }
                    action = action + new_params.join("&");
                }
                $env.reload(proxy, action, options );
            }

        }else{
            //$debug("non target: " + event.target + " \n this->"+target);
        }
        if (!handled && bubbles && target.parentNode){
            //$debug('bubbling to parentNode '+target.parentNode);
            __dispatchEvent__(target.parentNode, event, bubbles);
        }
    }catch(e){
        $warn("Exception while dispatching events: "+e);
        // print("oops e",e.stack);
        // print("oops e",e.backtrace && e.backtrace().join("\n"));
        // try { throw new Error("here"); } catch(x) { print("oops e",x.stack); }
        throw e;
    }
};
	
$env.__removeEventListener__ = __removeEventListener__;
$env.__addEventListener__ = __addEventListener__;
$env.__dispatchEvent__ = __dispatchEvent__;

$w.dispatchEvent = function(event, bubbles){
    __dispatchEvent__(this, event, bubbles);
};

$w.__defineGetter__('onerror', function(){
    return $onerror;
});

$w.__defineSetter__('onerror', function(fn){
    return $onerror = fn;
});

/*$w.__defineGetter__('onload', function(){
  return function(){
		//var event = document.createEvent();
		//event.initEvent("load");
   //$w.dispatchEvent(event);
  };
});

$w.__defineSetter__('onload', function(fn){
  //$w.addEventListener('load', fn);
});

$w.__defineGetter__('onunload', function(){
  return function(){
   //$w.dispatchEvent('unload');
  };
});

$w.__defineSetter__('onunload', function(fn){
  //$w.addEventListener('unload', fn);
});*/

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
/*
*	xhr.js
*/
$debug("Initializing Window XMLHttpRequest.");
// XMLHttpRequest
// Originally implemented by Yehuda Katz
$w.XMLHttpRequest = function(){
	this.headers = {};
	this.responseHeaders = {};
    this.$continueProcessing = true;
	$debug("creating xhr");
};

XMLHttpRequest.prototype = {
	open: function(method, url, async, user, password){ 
		this.readyState = 1;
		if (async === false ){
			this.async = false;
		}else{ this.async = true; }
		this.method = method || "GET";
		this.url = $env.location(url);
		this.onreadystatechange();
	},
	setRequestHeader: function(header, value){
		this.headers[header] = value;
	},
	send: function(data){
		var _this = this;
		
		function makeRequest(){
// print("MR",$env.connection);            
            $env.connection(_this, function(){
// print("MC");            
                if (_this.$continueProcessing){
                    var responseXML = null;
                    _this.__defineGetter__("responseXML", function(){
                        if ( _this.responseText.match(/^\s*</) ) {
                          if(responseXML){
                              return responseXML;

                          }else{
                                try {
                                    $debug("parsing response text into xml document");
                                    /* responseXML = $domparser.parseFromString(_this.responseText+""); */
                                    responseXML =
                                        document.implementation.createDocument().
                                          loadXML(_this.responseText+"");
                                    return responseXML;
                                } catch(e) {
                                    $error('response XML does not apear to be well formed xml', e);
                                    /*
                                    responseXML = $domparser.parseFromString("<html>"+
                                        "<head/><body><p> parse error </p></body></html>");
                                    */
                                    responseXML =
                                        document.implementation.createDocument().
                                          loadXML("<html><head/><body><p> parse error </p></body></html>");
                                    return responseXML;
                                }
                            }
                        }else{
                            $env.warn('response XML does not apear to be xml');
                            return null;
                        }
                    });
                    _this.__defineSetter__("responseXML",function(xml){
                        responseXML = xml;
                    });
                }
			}, data);

            if (_this.$continueProcessing)
                _this.onreadystatechange();
		}

try{
		if (this.async){
		    $debug("XHR sending asynch;");
			$env.runAsync(makeRequest);
		}else{
		    $debug("XHR sending synch;");
			makeRequest();
		}
}catch(e){
    $warn("Exception while processing XHR: " + e);
    throw e;
}

	},
	abort: function(){
        this.$continueProcessing = false;
	},
	onreadystatechange: function(){
		//TODO
	},
	getResponseHeader: function(header){
        $debug('GETTING RESPONSE HEADER '+header);
	  var rHeader, returnedHeaders;
		if (this.readyState < 3){
			throw new Error("INVALID_STATE_ERR");
		} else {
			returnedHeaders = [];
			for (rHeader in this.responseHeaders) {
				if (rHeader.match(new RegExp(header, "i")))
					returnedHeaders.push(this.responseHeaders[rHeader]);
			}
            
			if (returnedHeaders.length){ 
                $debug('GOT RESPONSE HEADER '+returnedHeaders.join(", "));
                return returnedHeaders.join(", "); 
            }
		}
        return null;
	},
	getAllResponseHeaders: function(){
	  var header, returnedHeaders = [];
		if (this.readyState < 3){
			throw new Error("INVALID_STATE_ERR");
		} else {
			for (header in this.responseHeaders){
				returnedHeaders.push( header + ": " + this.responseHeaders[header] );
			}
		}return returnedHeaders.join("\r\n");
	},
	async: true,
	readyState: 0,
	responseText: "",
	status: 0
};

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// End:
/*
*	css.js
*/
$debug("Initializing Window CSS");
// returns a CSS2Properties object that represents the style
// attributes and values used to render the specified element in this
// window.  Any length values are always expressed in pixel, or
// absolute values.

$w.getComputedStyle = function(elt, pseudo_elt){
  //TODO
  //this is a naive implementation
  $debug("Getting computed style");
  return elt?elt.style:new CSS2Properties({cssText:""});
};/*
*	screen.js
*/
$debug("Initializing Window Screen.");

var $availHeight  = 600,
    $availWidth   = 800,
    $colorDepth    = 16,
    $height       = 600,
    $width        = 800;
    
$w.__defineGetter__("screen", function(){
  return {
    get availHeight(){return $availHeight;},
    get availWidth(){return $availWidth;},
    get colorDepth(){return $colorDepth;},
    get height(){return $height;},
    get width(){return $width;}
  };
});


$w.moveBy = function(dx,dy){
  //TODO
};

$w.moveTo = function(x,y) {
  //TODO
};

/*$w.print = function(){
  //TODO
};*/

$w.resizeBy = function(dw, dh){
  $w.resizeTo($width+dw,$height+dh);
};

$w.resizeTo = function(width, height){
  $width = (width <= $availWidth) ? width : $availWidth;
  $height = (height <= $availHeight) ? height : $availHeight;
};


$w.scroll = function(x,y){
  //TODO
};
$w.scrollBy = function(dx, dy){
  //TODO
};
$w.scrollTo = function(x,y){
  //TODO
};/*
*	dialog.js
*/
$debug("Initializing Window Dialogs.");
$w.alert = function(message){
     $env.warn(message);
};

$w.confirm = function(question){
  //FIX (?)
  return true;
};

$w.prompt = function(message, defaultMsg){
  //TODO
};/*
*	document.js
*
*	DOM Level 2 /DOM level 3 (partial)
*	
*	This file adds the document object to the window and allows you
*	you to set the window.document using an html string or dom object.
*
*/

$debug("Initializing document.implementation");
var $implementation =  new DOMImplementation();
// $implementation.namespaceAware = false;
$implementation.errorChecking = false;

// read only reference to the Document object
var $document;
{    // a temporary scope, nothing more
  var referrer = "";
  try {
    referrer = $openingWindow.location.href;
  } catch (e){ /* or not */ }
  $document = new HTMLDocument($implementation, $w, referrer);
}

$w.__defineGetter__("document", function(){
	return $document;
});
// faux-intro ...
// (function(){
//   (function(){
//     function(){

      // User accesible interface ...
      var Envjs = $w.Envjs = $env.Envjs = function(){
        if(arguments.length === 2){
          for ( var i in arguments[1] ) {
    	    var g = arguments[1].__lookupGetter__(i), 
            s = arguments[1].__lookupSetter__(i);
    	    if ( g || s ) {
    	      if ( g ) $env.__defineGetter__(i, g);
    	      if ( s ) $env.__defineSetter__(i, s);
    	    } else
    	      $env[i] = arguments[1][i];
          }
        }
        if (arguments[0] != null && arguments[0] != "")
          window.location = arguments[0];
      };
      Envjs.$env = $env;
      Envjs.wait = $env.wait;
      Envjs.interpreter = window.whichInterpreter;
      Envjs.evaluate = $env.$master.evaluate;
  
      // $w.__loadAWindowsDocument__(options.url || "about:blank");

      (function(){
          var fns = [];
          for(var key in $master["static"]) {
              if(key.match(/^envjs_init_\d+$/)){
                  fns.push(key);
              }
          }
          fns.sort();
          var nu = this.__nu__ = {};
          nu.base = '';
          nu.metaProps = {};
          for(var i in fns) {
              // print(fns[i]);
              // print($master["static"][fns[i]]);
              $master["static"][fns[i]](this,this.document);
          }
      }());

      $env.load(options.url || "about:blank", options.xhr);
    };

    return $env;

  })(); // close function definition begun in 'intro.js'

  // Initial window setup
  var init = $env.init;
  init();

} catch(e) {
    // $warn("Exception during load: "+e);
    throw e;
}

})();

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// mode:auto-revert
// End:
