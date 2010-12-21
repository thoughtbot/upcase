/*
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
