/**
 * @author thatcher
 */

$w.__defineGetter__("XSLTProcessor", function(){
    return new XSLTProcessor(arguments);
});

var XSLTProcessor = function() {
    this.__stylesheet__ = null;
};
__extend__(XSLTProcessor.prototype, {
    clearParameters: function(){
        //TODO
    },
    getParameter: function(nsuri, name){
        //TODO
    },
    importStyleSheet: function(stylesheet){
        this.__stylesheet__ = stylesheet;
    },
    removeParameter: function(nsuri, name){
        //TODO
    },
    reset: function(){
        //TODO
    },
    setParameter: function(nsuri, name, value){
        //TODO
    },
    transformToDocument: function(sourceNode){
        return xsltProcess(sourceNode, this.__stylesheet__);
    },
    transformToFragment: function(sourceNode, ownerDocument){
        return xsltProcess(sourceNode, this.__stylesheet__).childNodes;
    }
});