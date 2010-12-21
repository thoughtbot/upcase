/**
 * @author thatcher
 */
$debug("Defining XMLSerializer");
/*
* XMLSerializer 
*/
/*
$w.__defineGetter__("XMLSerializer", function(){
    return new XMLSerializer(arguments);
});
*/

var XMLSerializer = function() {

};
__extend__(XMLSerializer.prototype, {
    serializeToString: function(node){
        return node.xml;
    }
});