(function(){
  if ($master.eventLoop) {
    throw new Error("event loop multiply defined");
  }
  var el = $master.eventLoop = {};

  var $env = {};
  $env.sync = function(f){return f;};
  $env.error = function(s){
    debug("timer error: "+s);
    if (s.stack) {
      debug("timer error: "+s.stack);
    }
  };
  $env.sleep = function(t){ Ruby.sleep(t/1000.); };
  
  var $timers = [];
  var $event_loop_running = false;
  $timers.lock = $env.sync(function(fn){fn();});

  var $timer = function(w, fn, interval){
    this.w = w;
    this.fn = fn;
    this.interval = interval;
    this.at = Date.now() + interval;
    this.running = false; // allows for calling wait() from callbacks
  };
  
  var convert_time = function(time) {
    time = time*1;
    if ( isNaN(time) || time < 0 ) {
      time = 0;
    }
    // html5 says this should be at least 4, but the parser is using a setTimeout for the SAX stuff
    // which messes up the world
    var min = /* 4 */ 0;
    if ( $event_loop_running && time < min ) {
      time = min;
    }
    return time;
  };

  var enter_and_exec = function(w,fn) {

  };

  el.setTimeout = function(w, fn, time){
    var num;
    time = convert_time(time);
    $timers.lock(function(){
      num = $timers.length+1;
      var tfn;
      if (typeof fn == 'string') {
        tfn = function() {
          try {
            // FIX ME: has to evaluate in inner ... probably in caller?
            eval(fn);
          } catch (e) {
            $env.error(e);
          } finally {
            el.clearInterval(num);
          }
        };
      } else {
        tfn = function() {
          try {
            fn();
          } catch (e) {
            $env.error(e);
          } finally {
            el.clearInterval(num);
          }
        };
      }
      $timers[num] = new $timer(w, tfn, time);
    });
    return num;
  };

  el.setInterval = function(w, fn, time){
    time = convert_time(time);
    if ( time < 10 ) {
      time = 10;
    }
    if (typeof fn == 'string') {
      var fnstr = fn; 
      fn = function() { 
        // FIX ME: has to evaluate in inner ... probably in caller(?)
        eval(fnstr);
      }; 
    }
    var num;
    $timers.lock(function(){
      num = $timers.length+1;
      $timers[num] = new $timer(w, fn, time);
    });
    return num;
  };

  el.clear = el.clearInterval = el.clearTimeout = function(num){
    //$log("clearing interval "+num);
    $timers.lock(function(){
      if ( $timers[num] ) {
        delete $timers[num];
      }
    });
  };	

  // wait === null/undefined: execute any timers as they fire, waiting until there are none left
  // wait(n) (n > 0): execute any timers as they fire until there are none left waiting at least n ms
  // but no more, even if there are future events/current threads
  // wait(0): execute any immediately runnable timers and return
      // wait(-n): keep sleeping until the next event is more than n ms in the future

  // FIX: make a priority queue ...

  el.wait = function(wait) {
    // print("wait",wait,$event_loop_running);
    var fired = false;
    var delta_wait;
    if (wait < 0) {
      delta_wait = -wait;
      wait = 0;
    }
    var start = Date.now();
    var old_loop_running = $event_loop_running;
    $event_loop_running = true; 
    if (wait !== 0 && wait !== null && wait !== undefined){
      wait += Date.now();
    }
    for (;;) {
      var earliest;
      $timers.lock(function(){
        earliest = undefined;
        for(var i in $timers){
          if( isNaN(i*0) ) {
            continue;
          }
          var timer = $timers[i];
          if( !timer.running && ( !earliest || timer.at < earliest.at) ) {
            earliest = timer;
          }
        }
      });
      var sleep = earliest && earliest.at - Date.now();
      if ( earliest && sleep <= 0 ) {
        var f = earliest.fn;
        var previous = $master.first_script_window;
        fired = true;
        try {
          earliest.running = true;
          $master.first_script_window = earliest.w;
          f();
        } catch (e) {
          $env.error(e);
        } finally {
          earliest.running = false;
          $master.first_script_window = previous;
        }
        var goal = earliest.at + earliest.interval;
        var now = Date.now();
        if ( goal < now ) {
          earliest.at = now;
        } else {
          earliest.at = goal;
        }
        continue;
      }

      // bunch of subtle cases here ...
      if ( !earliest ) {
        // no events in the queue (but maybe XHR will bring in events, so ...
        if ( !wait || wait < Date.now() ) {
          // Loop ends if there are no events and a wait hasn't been requested or has expired
          break;
        }
        // no events, but a wait requested: fall through to sleep
      } else {
        // there are events in the queue, but they aren't firable now
        // print(delta_wait,sleep);
        if ( delta_wait && sleep <= delta_wait ) {
          // if they will happen within the next delta, fall through to sleep
        } else if ( wait === 0 || ( wait > 0 && wait < Date.now () ) ) {
          // loop ends even if there are events but the user specifcally asked not to wait too long
          break;
        }
        // there are events and the user wants to wait: fall through to sleep
      }

      // Related to ajax threads ... hopefully can go away ..
      var interval =  el.wait.interval || 100;
      if ( !sleep || sleep > interval ) {
        sleep = interval;
      }
      // the parser sets the timeout at 1 ... the chances of us getting back through this loop in that amount of time
      // are small, no need to both the driver for something so small; just spin
      if (sleep>1) {
        $env.sleep(sleep);
      }
    }
    $event_loop_running = old_loop_running;
    // print("unwait",earliest,sleep);
    return [ fired, earliest && sleep ];
  };

}());