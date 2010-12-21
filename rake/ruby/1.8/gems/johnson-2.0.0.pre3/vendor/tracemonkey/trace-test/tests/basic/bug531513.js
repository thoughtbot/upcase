try {
  (eval("\
    (function() {\
      for (var y = 0; y < 4; y++) {\
        w = y\
      }\
    })")
  )()
} catch(e) {}
(function() {
  for (v in (x = {})) {}
})();
(function() {
  for (var z = 0; z < 8; z++) {
    if (z == 5) {
      x /= x
    } else {
      for each(w in [1]) {}
    }
  }
})()

/* Don't crash or assert. */
