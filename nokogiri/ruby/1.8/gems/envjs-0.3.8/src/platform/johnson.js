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
