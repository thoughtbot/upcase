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
};