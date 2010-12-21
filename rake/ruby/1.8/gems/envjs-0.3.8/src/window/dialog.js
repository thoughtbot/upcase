/*
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
};