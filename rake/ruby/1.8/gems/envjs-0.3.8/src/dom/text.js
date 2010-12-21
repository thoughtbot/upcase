$debug("Defining Text");
/*
* Text - DOM Level 2
*/
/**
 * @class  DOMText - The Text interface represents the textual content (termed character data in XML) of an Element or Attr.
 *   If there is no markup inside an element's content, the text is contained in a single object implementing the Text interface
 *   that is the only child of the element. If there is markup, it is parsed into a list of elements and Text nodes that form the
 *   list of children of the element.
 * @extends DOMCharacterData
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
var DOMText = function(ownerDocument) {
  this.DOMCharacterData  = DOMCharacterData;
  this.DOMCharacterData(ownerDocument);

  this.nodeName  = "#text";
};
DOMText.prototype = new DOMCharacterData;
__extend__(DOMText.prototype,{
    //Breaks this Text node into two Text nodes at the specified offset,
    // keeping both in the tree as siblings. This node then only contains all the content up to the offset point.
    // And a new Text node, which is inserted as the next sibling of this node, contains all the content at and after the offset point.
    splitText : function(offset) {
        var data, inode;
        
        // test for exceptions
        if (__ownerDocument__(this).implementation.errorChecking) {
            // throw Exception if Node is readonly
            if (this._readonly) {
              throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
            }
            
            // throw Exception if offset is negative or greater than the data length,
            if ((offset < 0) || (offset > this.data.length)) {
              throw(new DOMException(DOMException.INDEX_SIZE_ERR));
            }
        }
        
        if (this.parentNode) {
            // get remaining string (after offset)
            data  = this.substringData(offset);
            
            // create new TextNode with remaining string
            inode = __ownerDocument__(this).createTextNode(data);
            
            // attach new TextNode
            if (this.nextSibling) {
              this.parentNode.insertBefore(inode, this.nextSibling);
            }
            else {
              this.parentNode.appendChild(inode);
            }
            
            // remove remaining string from original TextNode
            this.deleteData(offset);
        }
        
        return inode;
    },
    get nodeType(){
        return DOMNode.TEXT_NODE;
    },
    get xml(){
        return __escapeHTML5__(""+ this.nodeValue);
    },
    toString: function(){
        return "Text #" + this._id;    
    }
});

// $w.Text = DOMText;