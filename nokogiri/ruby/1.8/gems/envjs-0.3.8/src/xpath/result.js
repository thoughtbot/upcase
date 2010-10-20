/**
 * @author thatcher
 */
$debug("Defining XPathResult");
/*
* XPathResult 
*/
/*
$w.__defineGetter__("XPathResult", function(){
    return XPathResult;
});
*/

var XPathResult = function(impl) {
    this.current = 0;
    this.impl = impl;
};

__extend__( XPathResult, {
    ANY_TYPE:                     0,
    NUMBER_TYPE:                  1,
    STRING_TYPE:                  2,
    BOOLEAN_TYPE:                 3,
    UNORDERED_NODE_ITERATOR_TYPE: 4,
    ORDERED_NODEITERATOR_TYPE:    5,
    UNORDERED_NODE_SNAPSHOT_TYPE: 6,
    ORDERED_NODE_SNAPSHOT_TYPE:   7,
    ANY_ORDERED_NODE_TYPE:        8,
    FIRST_ORDERED_NODE_TYPE:      9
});

__extend__(XPathResult.prototype, {
    get booleanValue(){
      this.impl.booleanValue();
    },
    get stringValue(){
      this.impl.stringValue();
    },
/*
    get invalidIteration(){
      throw new Error("implement invalidIteration");
        //TODO
    },
*/
    get numberValue(){
      this.impl.numberValue();
    },
/*
    get resultType(){
      throw new Error("implement resultType");
        //TODO
    },
*/
    get singleNodeValue(){
      return this.impl.nodeSetValue()[0];
    },
    get snapshotLength(){
      return this.impl.nodeSetValue().length;
    },
    snapshotItem: function(index){
      return this.impl.nodeSetValue()[index];
    },
    iterateNext: function(){
      return this.impl.nodeSetValue()[this.current++];
    }
});

