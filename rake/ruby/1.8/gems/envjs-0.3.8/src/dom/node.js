$debug("Defining Node");
/*
* Node - DOM Level 2
*/	
/**
 * @class  DOMNode - The Node interface is the primary datatype for the entire Document Object Model.
 *   It represents a single node in the document tree.
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
var DOMNode = function(ownerDocument) {
  if (ownerDocument) {
    this._id = ownerDocument._genId();           // generate unique internal id
  }
  
  this.namespaceURI = "";                        // The namespace URI of this node (Level 2)
  this.prefix       = "";                        // The namespace prefix of this node (Level 2)
  this.localName    = "";                        // The localName of this node (Level 2)

  this.nodeName = "";                            // The name of this node
  this.nodeValue = null;                           // The value of this node
  //this.className = "";                           // The CSS class name of this node.
  
  // The parent of this node. All nodes, except Document, DocumentFragment, and Attr may have a parent.
  // However, if a node has just been created and not yet added to the tree, or if it has been removed from the tree, this is null
  this.parentNode      = null;

  // A NodeList that contains all children of this node. If there are no children, this is a NodeList containing no nodes.
  // The content of the returned NodeList is "live" in the sense that, for instance, changes to the children of the node object
  // that it was created from are immediately reflected in the nodes returned by the NodeList accessors;
  // it is not a static snapshot of the content of the node. This is true for every NodeList, including the ones returned by the getElementsByTagName method.
  this.childNodes      = new DOMNodeList(ownerDocument, this);

  this.firstChild      = null;                   // The first child of this node. If there is no such node, this is null
  this.lastChild       = null;                   // The last child of this node. If there is no such node, this is null.
  this.previousSibling = null;                   // The node immediately preceding this node. If there is no such node, this is null.
  this.nextSibling     = null;                   // The node immediately following this node. If there is no such node, this is null.

  this.ownerDocument   = ownerDocument;          // The Document object associated with this node
  this.attributes = new DOMNamedNodeMap(this.ownerDocument, this);
  this._namespaces = new DOMNamespaceNodeMap(ownerDocument, this);  // The namespaces in scope for this node
  this._readonly = false;
};

// nodeType constants
DOMNode.ELEMENT_NODE                = 1;
DOMNode.ATTRIBUTE_NODE              = 2;
DOMNode.TEXT_NODE                   = 3;
DOMNode.CDATA_SECTION_NODE          = 4;
DOMNode.ENTITY_REFERENCE_NODE       = 5;
DOMNode.ENTITY_NODE                 = 6;
DOMNode.PROCESSING_INSTRUCTION_NODE = 7;
DOMNode.COMMENT_NODE                = 8;
DOMNode.DOCUMENT_NODE               = 9;
DOMNode.DOCUMENT_TYPE_NODE          = 10;
DOMNode.DOCUMENT_FRAGMENT_NODE      = 11;
DOMNode.NOTATION_NODE               = 12;
DOMNode.NAMESPACE_NODE              = 13;

__extend__(DOMNode.prototype, {
    hasAttributes : function() {
        if (this.attributes.length == 0) {
            return false;
        }else{
            return true;
        }
    },
    insertBefore : function(newChild, refChild) {
        var prevNode;
        
        if(newChild==null){
            return newChild;
        }
        if(refChild==null){
            this.appendChild(newChild);
            return this.newChild;
        }
        
        // test for exceptions
        if (__ownerDocument__(this).implementation.errorChecking) {
            // throw Exception if DOMNode is readonly
            if (this._readonly) {
                throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
            }
            
            // throw Exception if newChild was not created by this Document
            if (__ownerDocument__(this) != __ownerDocument__(newChild)) {
                throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
            }
            
            // throw Exception if the node is an ancestor
            if (__isAncestor__(this, newChild)) {
                throw(new DOMException(DOMException.HIERARCHY_REQUEST_ERR));
            }
        }
        
        if (refChild) {                                // if refChild is specified, insert before it
            // find index of refChild
            var itemIndex = __findItemIndex__(this.childNodes, refChild._id);
            // throw Exception if there is no child node with this id
            if (__ownerDocument__(this).implementation.errorChecking && (itemIndex < 0)) {
              throw(new DOMException(DOMException.NOT_FOUND_ERR));
            }
            
            // if the newChild is already in the tree,
            var newChildParent = newChild.parentNode;
            if (newChildParent) {
              // remove it
              newChildParent.removeChild(newChild);
            }
            
            // insert newChild into childNodes
            __insertBefore__(this.childNodes, newChild, itemIndex);
            
            // do node pointer surgery
            prevNode = refChild.previousSibling;
            
            // handle DocumentFragment
            if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
              if (newChild.childNodes.length > 0) {
                // set the parentNode of DocumentFragment's children
                for (var ind = 0; ind < newChild.childNodes.length; ind++) {
                  newChild.childNodes[ind].parentNode = this;
                }
            
                // link refChild to last child of DocumentFragment
                refChild.previousSibling = newChild.childNodes[newChild.childNodes.length-1];
              }
            }else {
                newChild.parentNode = this;                // set the parentNode of the newChild
                refChild.previousSibling = newChild;       // link refChild to newChild
            }
            
        }else {                                         // otherwise, append to end
            prevNode = this.lastChild;
            this.appendChild(newChild);
        }
        
        if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
            // do node pointer surgery for DocumentFragment
            if (newChild.childNodes.length > 0) {
                if (prevNode) {  
                    prevNode.nextSibling = newChild.childNodes[0];
                }else {                                         // this is the first child in the list
                    this.firstChild = newChild.childNodes[0];
                }
            
                newChild.childNodes[0].previousSibling = prevNode;
                newChild.childNodes[newChild.childNodes.length-1].nextSibling = refChild;
            }
        }else {
            // do node pointer surgery for newChild
            if (prevNode) {
              prevNode.nextSibling = newChild;
            }else {                                         // this is the first child in the list
              this.firstChild = newChild;
            }
            
            newChild.previousSibling = prevNode;
            newChild.nextSibling     = refChild;
        }
        
        return newChild;
    },
    replaceChild : function(newChild, oldChild) {
        var ret = null;
        
        if(newChild==null || oldChild==null){
            return oldChild;
        }
        
        // test for exceptions
        if (__ownerDocument__(this).implementation.errorChecking) {
            // throw Exception if DOMNode is readonly
            if (this._readonly) {
                throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
            }
        
            // throw Exception if newChild was not created by this Document
            if (__ownerDocument__(this) != __ownerDocument__(newChild)) {
                throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
            }
        
            // throw Exception if the node is an ancestor
            if (__isAncestor__(this, newChild)) {
                throw(new DOMException(DOMException.HIERARCHY_REQUEST_ERR));
            }
        }
        
        // get index of oldChild
        var index = __findItemIndex__(this.childNodes, oldChild._id);
        
        // throw Exception if there is no child node with this id
        if (__ownerDocument__(this).implementation.errorChecking && (index < 0)) {
            throw(new DOMException(DOMException.NOT_FOUND_ERR));
        }
        
        // if the newChild is already in the tree,
        var newChildParent = newChild.parentNode;
        if (newChildParent) {
            // remove it
            newChildParent.removeChild(newChild);
        }
        
        // add newChild to childNodes
        ret = __replaceChild__(this.childNodes,newChild, index);
        
        
        if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
            // do node pointer surgery for Document Fragment
            if (newChild.childNodes.length > 0) {
                for (var ind = 0; ind < newChild.childNodes.length; ind++) {
                    newChild.childNodes[ind].parentNode = this;
                }
                
                if (oldChild.previousSibling) {
                    oldChild.previousSibling.nextSibling = newChild.childNodes[0];
                } else {
                    this.firstChild = newChild.childNodes[0];
                }
                
                if (oldChild.nextSibling) {
                    oldChild.nextSibling.previousSibling = newChild;
                } else {
                    this.lastChild = newChild.childNodes[newChild.childNodes.length-1];
                }
                
                newChild.childNodes[0].previousSibling = oldChild.previousSibling;
                newChild.childNodes[newChild.childNodes.length-1].nextSibling = oldChild.nextSibling;
            }
        } else {
            // do node pointer surgery for newChild
            newChild.parentNode = this;
            
            if (oldChild.previousSibling) {
                oldChild.previousSibling.nextSibling = newChild;
            }else{
                this.firstChild = newChild;
            }
            if (oldChild.nextSibling) {
                oldChild.nextSibling.previousSibling = newChild;
            }else{
                this.lastChild = newChild;
            }
            newChild.previousSibling = oldChild.previousSibling;
            newChild.nextSibling = oldChild.nextSibling;
        }
        
        return ret;
    },
    removeChild : function(oldChild) {
        if(!oldChild){
            return null;
        }
        // throw Exception if DOMNamedNodeMap is readonly
        if (__ownerDocument__(this).implementation.errorChecking && (this._readonly || oldChild._readonly)) {
            throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
        }
        
        // get index of oldChild
        var itemIndex = __findItemIndex__(this.childNodes, oldChild._id);
        
        // throw Exception if there is no child node with this id
        if (__ownerDocument__(this).implementation.errorChecking && (itemIndex < 0)) {
            throw(new DOMException(DOMException.NOT_FOUND_ERR));
        }
        
        // remove oldChild from childNodes
        __removeChild__(this.childNodes, itemIndex);
        
        // do node pointer surgery
        oldChild.parentNode = null;
        
        if (oldChild.previousSibling) {
            oldChild.previousSibling.nextSibling = oldChild.nextSibling;
        }else {
            this.firstChild = oldChild.nextSibling;
        }
        if (oldChild.nextSibling) {
            oldChild.nextSibling.previousSibling = oldChild.previousSibling;
        }else {
            this.lastChild = oldChild.previousSibling;
        }
        
        oldChild.previousSibling = null;
        oldChild.nextSibling = null;
        
        return oldChild;
    },
    appendChild : function(newChild) {
        if(!newChild){
            return null;
        }
      // test for exceptions
      if (__ownerDocument__(this).implementation.errorChecking) {
        // throw Exception if Node is readonly
        if (this._readonly) {
          throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
        }
    
        // throw Exception if arg was not created by this Document
        if (__ownerDocument__(this) != __ownerDocument__(this)) {
          throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
        }
    
        // throw Exception if the node is an ancestor
        if (__isAncestor__(this, newChild)) {
          throw(new DOMException(DOMException.HIERARCHY_REQUEST_ERR));
        }
      }
    
      // if the newChild is already in the tree,
      var newChildParent = newChild.parentNode;
      if (newChildParent) {
        // remove it
        newChildParent.removeChild(newChild);
      }
    
      // add newChild to childNodes
      __appendChild__(this.childNodes, newChild);
    
      if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
        // do node pointer surgery for DocumentFragment
        if (newChild.childNodes.length > 0) {
          for (var ind = 0; ind < newChild.childNodes.length; ind++) {
            newChild.childNodes[ind].parentNode = this;
          }
    
          if (this.lastChild) {
            this.lastChild.nextSibling = newChild.childNodes[0];
            newChild.childNodes[0].previousSibling = this.lastChild;
            this.lastChild = newChild.childNodes[newChild.childNodes.length-1];
          }
          else {
            this.lastChild = newChild.childNodes[newChild.childNodes.length-1];
            this.firstChild = newChild.childNodes[0];
          }
        }
      }
      else {
        // do node pointer surgery for newChild
        newChild.parentNode = this;
        if (this.lastChild) {
          this.lastChild.nextSibling = newChild;
          newChild.previousSibling = this.lastChild;
          this.lastChild = newChild;
        }
        else {
          this.lastChild = newChild;
          this.firstChild = newChild;
        }
      }
      return newChild;
    },
    hasChildNodes : function() {
        return (this.childNodes.length > 0);
    },
    cloneNode: function(deep) {
        // use importNode to clone this Node
        //do not throw any exceptions
        try {
            return __ownerDocument__(this).importNode(this, deep);
        } catch (e) {
            //there shouldn't be any exceptions, but if there are, return null
            // may want to warn: $debug("could not clone node: "+e.code);
            return null;
        }
    },
    normalize : function() {
        var inode;
        var nodesToRemove = new DOMNodeList();
        
        if (this.nodeType == DOMNode.ELEMENT_NODE || this.nodeType == DOMNode.DOCUMENT_NODE) {
            var adjacentTextNode = null;
        
            // loop through all childNodes
            for(var i = 0; i < this.childNodes.length; i++) {
                inode = this.childNodes.item(i);
            
                if (inode.nodeType == DOMNode.TEXT_NODE) { // this node is a text node
                    if (inode.length < 1) {                  // this text node is empty
                        __appendChild__(nodesToRemove, inode);      // add this node to the list of nodes to be remove
                    }else {
                        if (adjacentTextNode) {                // if previous node was also text
                            adjacentTextNode.appendData(inode.data);     // merge the data in adjacent text nodes
                            __appendChild__(nodesToRemove, inode);    // add this node to the list of nodes to be removed
                        }else {
                            adjacentTextNode = inode;              // remember this node for next cycle
                        }
                    }
                } else {
                    adjacentTextNode = null;                 // (soon to be) previous node is not a text node
                    inode.normalize();                       // normalise non Text childNodes
                }
            }
                
            // remove redundant Text Nodes
            for(var i = 0; i < nodesToRemove.length; i++) {
                inode = nodesToRemove.item(i);
                inode.parentNode.removeChild(inode);
            }
        }
    },
    isSupported : function(feature, version) {
        // use Implementation.hasFeature to determin if this feature is supported
        return __ownerDocument__(this).implementation.hasFeature(feature, version);
    },
    getElementsByTagName : function(tagname) {
        // delegate to _getElementsByTagNameRecursive
        // recurse childNodes
        var nodelist = new DOMNodeList(__ownerDocument__(this));
        for(var i = 0; i < this.childNodes.length; i++) {
            nodeList = __getElementsByTagNameRecursive__(this.childNodes.item(i), tagname, nodelist);
        }
        return nodelist;
    },
    getElementsByTagNameNS : function(namespaceURI, localName) {
        // delegate to _getElementsByTagNameNSRecursive
        return __getElementsByTagNameNSRecursive__(this, namespaceURI, localName, 
            new DOMNodeList(__ownerDocument__(this)));
    },
    importNode : function(importedNode, deep) {
        
        var importNode;

        // debug("importing node " + importedNode.nodeName + "(" + importedNode.nodeType + ")" + "(?deep = "+deep+")");

        //there is no need to perform namespace checks since everything has already gone through them
        //in order to have gotten into the DOM in the first place. The following line
        //turns namespace checking off in ._isValidNamespace
        __ownerDocument__(this)._performingImportNodeOperation = true;
        
            if (importedNode.nodeType == DOMNode.ELEMENT_NODE) {
                if (!__ownerDocument__(this).implementation.namespaceAware) {
                    // create a local Element (with the name of the importedNode)
                    importNode = __ownerDocument__(this).createElement(importedNode.tagName);
                
                    // create attributes matching those of the importedNode
                    for(var i = 0; i < importedNode.attributes.length; i++) {
                        importNode.setAttribute(importedNode.attributes.item(i).name, importedNode.getAttribute(importedNode.attributes.item(i).name));
                    }
                }else {
                    // create a local Element (with the name & namespaceURI of the importedNode)
                    importNode = __ownerDocument__(this).createElementNS(importedNode.namespaceURI, importedNode.nodeName);
                
                    // create attributes matching those of the importedNode
                    for(var i = 0; i < importedNode.attributes.length; i++) {
                        importNode.setAttributeNS(importedNode.attributes.item(i).namespaceURI, 
                            importedNode.attributes.item(i).name, importedNode.getAttribute(importedNode.attributes.item(i).name));
                    }
                
                    // create namespace definitions matching those of the importedNode
                    for(var i = 0; i < importedNode._namespaces.length; i++) {
                        importNode._namespaces[i] = __ownerDocument__(this).createNamespace(importedNode._namespaces.item(i).name);
                        importNode._namespaces[i].value = importedNode._namespaces.item(i).value;
                    }
                    importNode._namespaces.length = importedNode._namespaces.length;
                }
            } else if (importedNode.nodeType == DOMNode.ATTRIBUTE_NODE) {
                if (!__ownerDocument__(this).implementation.namespaceAware) {
                    // create a local Attribute (with the name of the importedAttribute)
                    importNode = __ownerDocument__(this).createAttribute(importedNode.name);
                } else {
                    // create a local Attribute (with the name & namespaceURI of the importedAttribute)
                    importNode = __ownerDocument__(this).createAttributeNS(importedNode.namespaceURI, importedNode.nodeName);
                

/*
                    // create namespace definitions matching those of the importedAttribute
                    for(var i = 0; i < importedNode._namespaces.length; i++) {
                        importNode._namespaces[i] = __ownerDocument__(this).createNamespace(importedNode._namespaces.item(i).localName);
                        importNode._namespaces[i].value = importedNode._namespaces.item(i).value;
                    }
*/


                }
            
                // set the value of the local Attribute to match that of the importedAttribute
                importNode.value = importedNode.value;
                
            } else if (importedNode.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
                // create a local DocumentFragment
                importNode = __ownerDocument__(this).createDocumentFragment();
            } else if (importedNode.nodeType == DOMNode.NAMESPACE_NODE) {
                // create a local NamespaceNode (with the same name & value as the importedNode)
                importNode = __ownerDocument__(this).createNamespace(importedNode.name);
                importNode.value = importedNode.value;
            } else if (importedNode.nodeType == DOMNode.TEXT_NODE) {
                // create a local TextNode (with the same data as the importedNode)
                importNode = __ownerDocument__(this).createTextNode(importedNode.data);
            } else if (importedNode.nodeType == DOMNode.CDATA_SECTION_NODE) {
                // create a local CDATANode (with the same data as the importedNode)
                importNode = __ownerDocument__(this).createCDATASection(importedNode.data);
            } else if (importedNode.nodeType == DOMNode.PROCESSING_INSTRUCTION_NODE) {
                // create a local ProcessingInstruction (with the same target & data as the importedNode)
                importNode = __ownerDocument__(this).createProcessingInstruction(importedNode.target, importedNode.data);
            } else if (importedNode.nodeType == DOMNode.COMMENT_NODE) {
                // create a local Comment (with the same data as the importedNode)
                importNode = __ownerDocument__(this).createComment(importedNode.data);
            } else {  // throw Exception if nodeType is not supported
                throw(new DOMException(DOMException.NOT_SUPPORTED_ERR));
            }
            
            if (deep) {                                    // recurse childNodes
                for(var i = 0; i < importedNode.childNodes.length; i++) {
                    importNode.appendChild(__ownerDocument__(this).importNode(importedNode.childNodes.item(i), true));
                }
            }
            
            //reset _performingImportNodeOperation
            __ownerDocument__(this)._performingImportNodeOperation = false;
            return importNode;
        
    },
    contains : function(node){
            while(node && node != this ){
                node = node.parentNode;
            }
            return !!node;
    },
    compareDocumentPosition : function(b){
        var a = this;
        var number = (a != b && a.contains(b) && 16) + (a != b && b.contains(a) && 8);
        //find position of both
        var all = this.ownerDocument.getElementsByTagName("*");
        var my_location = 0, node_location = 0;
        for(var i=0; i < all.length; i++){
            if(all[i] == a) my_location = i;
            if(all[i] == b) node_location = i;
            if(my_location && node_location) break;
        }
        number += (my_location < node_location && 4);
        number += (my_location > node_location && 2);
        return number;
    } 

});



/**
 * @method DOMNode._getElementsByTagNameRecursive - implements getElementsByTagName()
 * @param  elem     : DOMElement  - The element which are checking and then recursing into
 * @param  tagname  : string      - The name of the tag to match on. The special value "*" matches all tags
 * @param  nodeList : DOMNodeList - The accumulating list of matching nodes
 *
 * @return : DOMNodeList
 */
var __getElementsByTagNameRecursive__ = function (elem, tagname, nodeList) {

    if (elem.nodeType == DOMNode.ELEMENT_NODE || elem.nodeType == DOMNode.DOCUMENT_NODE) {
    
        if(elem.nodeType !== DOMNode.DOCUMENT_NODE && 
            ((elem.nodeName.toUpperCase() == tagname.toUpperCase()) || 
                (tagname == "*")) ){
            __appendChild__(nodeList, elem);               // add matching node to nodeList
        }
    
        // recurse childNodes
        for(var i = 0; i < elem.childNodes.length; i++) {
            nodeList = __getElementsByTagNameRecursive__(elem.childNodes.item(i), tagname, nodeList);
        }
    }
    
    return nodeList;
};

/**
 * @method DOMNode._getElementsByTagNameNSRecursive - implements getElementsByTagName()
 *
 * @param  elem     : DOMElement  - The element which are checking and then recursing into
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 * @param  nodeList     : DOMNodeList - The accumulating list of matching nodes
 *
 * @return : DOMNodeList
 */
var __getElementsByTagNameNSRecursive__ = function(elem, namespaceURI, localName, nodeList) {
  if (elem.nodeType == DOMNode.ELEMENT_NODE || elem.nodeType == DOMNode.DOCUMENT_NODE) {

    if (((elem.namespaceURI == namespaceURI) || (namespaceURI == "*")) && ((elem.localName == localName) || (localName == "*"))) {
      __appendChild__(nodeList, elem);               // add matching node to nodeList
    }

    // recurse childNodes
    for(var i = 0; i < elem.childNodes.length; i++) {
      nodeList = __getElementsByTagNameNSRecursive__(elem.childNodes.item(i), namespaceURI, localName, nodeList);
    }
  }

  return nodeList;
};

/**
 * @method DOMNode._isAncestor - returns true if node is ancestor of target
 * @param  target         : DOMNode - The node we are using as context
 * @param  node         : DOMNode - The candidate ancestor node
 * @return : boolean
 */
var __isAncestor__ = function(target, node) {
  // if this node matches, return true,
  // otherwise recurse up (if there is a parentNode)
  return ((target == node) || ((target.parentNode) && (__isAncestor__(target.parentNode, node))));
};

var __ownerDocument__ = function(node){
    return (node.nodeType == DOMNode.DOCUMENT_NODE)?node:node.ownerDocument;
};

// $w.Node = DOMNode;

// Local Variables:
// espresso-indent-level:4
// c-basic-offset:4
// tab-width:4
// mode:auto-revert
// End:
