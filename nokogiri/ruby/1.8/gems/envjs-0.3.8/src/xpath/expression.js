/**
 * @author thatcher
 */
$debug("Defining XPathExpression");
/*
* XPathExpression 
*/
/*
$w.__defineGetter__("XPathExpression", function(){
    return XPathExpression;
});
*/

var XPathExpression =
  function(xpathText, contextNode, nsuriMapper, resultType, result) {
    if(nsuriMapper != null) {
      throw new Error("nsuriMapper not implemented");
    }
    if(result != null) {
      throw new Error("result not implemented");
    }
    /*
    if(resultType!=XPathResult.ANY_TYPE) {
      throw new Error("result type not implemented");
    }
    */

    // var now = Date.now();
    var context = new ExprContext(contextNode);
    // var doc = contextNode.ownerDocument || contextNode;
    // print(contextNode.xml);
    // print("text: "+xpathText);
    // print("context: "+(Date.now()-now));
    var p = xpathParse(xpathText);
    // print("parse: "+(Date.now()-now));
    var e = p.evaluate(context);
    // print("ev: "+(Date.now()-now));
    this.result = e;
    return;


    var context = new ExprContext(contextNode);
    this.result = xpathParse(xpathText).evaluate(context);
  };
__extend__(XPathExpression.prototype, {
    evaluate: function(){
      return new XPathResult(this.result);
    }
});