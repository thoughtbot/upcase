
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
