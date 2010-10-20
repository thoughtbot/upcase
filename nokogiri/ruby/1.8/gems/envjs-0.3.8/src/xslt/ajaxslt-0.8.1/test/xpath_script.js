// Copyright 2005 Google Inc.
// All Rights Reserved
//
// Tests for the XPath parser. To run the test, open the file from the
// file system. No server support is required.
//
//
// Author: Steffen Meschkat <mesch@google.com>

logging = true;
xpathdebug = true;

function load_expr() {
  var s = document.getElementById('s');
  for (var i = 0; i < expr.length; ++i) {
    var o = new Option(expr[i].replace(/&gt;/,'>').replace(/&lt;/,'<'));
    s.options[s.options.length] = o;
  }
  s.selectedIndex = 0;
}

function xpath_test(form) {
  Log.clear();
  try {
    var i = form.cases.selectedIndex;
    var options = form.cases.options;

    var text = options[i].value;
    Log.writeRaw('<tt><b>' + text + '</b></tt>');

    var expr = xpathParse(text);
    Log.writeRaw('<tt><b>' + text + '</b></tt>');
    Log.writeRaw('<pre>' + expr.parseTree('') + '</pre>');
    
    options[i].selected = false;
    if (i < options.length - 1) {
      options[i+1].selected = true;
    } else {
      options[0].selected = true;
    }
    
  } catch (e) {
    Log.write('EXCEPTION ' + e);
  }
}
