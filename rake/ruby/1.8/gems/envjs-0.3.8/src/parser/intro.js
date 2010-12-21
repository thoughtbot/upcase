/**
 * @author thatcher
 */

(function(/*window,document*/){

var Html5Parser;

var psettimeout;

var sync = function(window,parser){
  parser.ptimeouts = [];
  parser.pschedule = function($schedule,timer,t) {
    var old = psettimeout; 
    psettimeout = function(fn){
      parser.ptimeouts.push(fn);
    };
    $schedule(window,timer,t);
    psettimeout = old;
  };
  parser.pwait = function() {
    var fn;
    while ((fn = parser.ptimeouts.pop())) {
      fn();
    };
  };
};

var async = function(window,parser) {
  delete parser.ptimeouts;
  parser.pschedule = function($schedule,timer,t) {
    var old = psettimeout; 
    psettimeout = window.setTimeout;
    $schedule(window,timer,t);
    psettimeout = old;
  };
  parser.pwait = function(){
    // $master.print("wait called");
    window.$envx.wait(-1);
    // $master.print("after wait");
  };
};
