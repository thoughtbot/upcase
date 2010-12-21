$debug("Defining Comment");
/* 
* Comment - DOM Level 2
*/
/**
 * @class  DOMComment - This represents the content of a comment, i.e., all the characters between the starting '<!--' and ending '-->'
 * @extends DOMCharacterData
 * @author Jon van Noort (jon@webarcana.com.au)
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
var DOMComment = function(ownerDocument) {
  this.DOMCharacterData  = DOMCharacterData;
  this.DOMCharacterData(ownerDocument);

  this.nodeName  = "#comment";
};
DOMComment.prototype = new DOMCharacterData;
__extend__(DOMComment.prototype, {
    get nodeType(){
        return DOMNode.COMMENT_NODE;
    },
    get xml(){
        return "<!--" + this.nodeValue + "-->";
    },
    toString : function(){
        return "Comment #"+this._id;
    }
});

// $w.Comment = DOMComment;
