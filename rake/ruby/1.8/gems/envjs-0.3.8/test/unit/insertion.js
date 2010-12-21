module("insertion");

test("inserting SELECT elements with multiple='multiple' should not raise an error", function() {
  expect(3);
  var div = document.createElement('div');
  var html = "<select multiple='multiple'><option value='wheels'>Wheels within Wheels</option></select>";
  ok(div.innerHTML = html, html);  
  var select = document.createElement('select');
  var x;
  try {
    select.type = "foo";
  }catch(e){
    x = e;
  }
  ok(x !== void(0), "should not allow setting type");
  x = void(0);
  try {
    select.setAttribute("type","foo");
  }catch(e){
    x = e;
  }
  ok(x !== void(0), "should not allow setting type via setAttribute");
});
