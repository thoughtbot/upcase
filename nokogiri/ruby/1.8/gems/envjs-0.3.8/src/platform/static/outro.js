if(false){
(function(){

  var master = this.$master;
  var print = master["print"];
  
  delete this.$master;
  delete this.$debug;

  for(var v in master.symbols) {
    if(master.symbols[v] === "Ruby") continue;
    delete this[master.symbols[v]];
  }

  print("exported symbols");
  for(var v in this) {
    if(v !== "Ruby" &&v !== "Johnson" && v !== "__FILE__" ) {
        print(v);
        //master.seal(this[v],true);
    }
  }
}());
}

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// mode:auto-revert
// End:
