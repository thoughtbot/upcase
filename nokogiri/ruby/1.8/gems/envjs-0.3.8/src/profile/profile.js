

var $profile = window.$profile = {};


var __profile__ = function(id, invocation){
    var start = new Date().getTime();
    var retval = invocation.proceed(); 
    var finish = new Date().getTime();
    $profile[id] = $profile[id] ? $profile[id] : {};
    $profile[id].callCount = $profile[id].callCount !== undefined ? 
        $profile[id].callCount+1 : 0;
    $profile[id].times = $profile[id].times ? $profile[id].times : [];
    $profile[id].times[$profile[id].callCount++] = (finish-start);
    return retval;
};


window.$profiler.stats = function(raw){
    var max     = 0,
        avg     = -1,
        min     = 10000000,
        own     = 0;
    for(var i = 0;i<raw.length;i++){
        if(raw[i] > 0){
            own += raw[i];
        };
        if(raw[i] > max){
            max = raw[i];
        }
        if(raw[i] < min){
            min = raw[i];
        }
    }
    avg = Math.floor(own/raw.length);
    return {
        min: min,
        max: max,
        avg: avg,
        own: own
    };
};

if($env.profile){
    /**
    *   CSS2Properties
    */
    window.$profiler.around({ target: CSS2Properties,  method:"getPropertyCSSValue"}, function(invocation) {
        return __profile__("CSS2Properties.getPropertyCSSValue", invocation);
    });  
    window.$profiler.around({ target: CSS2Properties,  method:"getPropertyPriority"}, function(invocation) {
        return __profile__("CSS2Properties.getPropertyPriority", invocation);
    });  
    window.$profiler.around({ target: CSS2Properties,  method:"getPropertyValue"}, function(invocation) {
        return __profile__("CSS2Properties.getPropertyValue", invocation);
    });  
    window.$profiler.around({ target: CSS2Properties,  method:"item"}, function(invocation) {
        return __profile__("CSS2Properties.item", invocation);
    });  
    window.$profiler.around({ target: CSS2Properties,  method:"removeProperty"}, function(invocation) {
        return __profile__("CSS2Properties.removeProperty", invocation);
    });  
    window.$profiler.around({ target: CSS2Properties,  method:"setProperty"}, function(invocation) {
        return __profile__("CSS2Properties.setProperty", invocation);
    });  
    window.$profiler.around({ target: CSS2Properties,  method:"toString"}, function(invocation) {
        return __profile__("CSS2Properties.toString", invocation);
    });  
               
    
    /**
    *   DOMNode
    */
                    
    window.$profiler.around({ target: DOMNode,  method:"hasAttributes"}, function(invocation) {
        return __profile__("DOMNode.hasAttributes", invocation);
    });          
    window.$profiler.around({ target: DOMNode,  method:"insertBefore"}, function(invocation) {
        return __profile__("DOMNode.insertBefore", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"replaceChild"}, function(invocation) {
        return __profile__("DOMNode.replaceChild", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"removeChild"}, function(invocation) {
        return __profile__("DOMNode.removeChild", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"replaceChild"}, function(invocation) {
        return __profile__("DOMNode.replaceChild", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"appendChild"}, function(invocation) {
        return __profile__("DOMNode.appendChild", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"hasChildNodes"}, function(invocation) {
        return __profile__("DOMNode.hasChildNodes", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"cloneNode"}, function(invocation) {
        return __profile__("DOMNode.cloneNode", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"normalize"}, function(invocation) {
        return __profile__("DOMNode.normalize", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"isSupported"}, function(invocation) {
        return __profile__("DOMNode.isSupported", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"getElementsByTagName"}, function(invocation) {
        return __profile__("DOMNode.getElementsByTagName", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"getElementsByTagNameNS"}, function(invocation) {
        return __profile__("DOMNode.getElementsByTagNameNS", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"importNode"}, function(invocation) {
        return __profile__("DOMNode.importNode", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"contains"}, function(invocation) {
        return __profile__("DOMNode.contains", invocation);
    }); 
    window.$profiler.around({ target: DOMNode,  method:"compareDocumentPosition"}, function(invocation) {
        return __profile__("DOMNode.compareDocumentPosition", invocation);
    }); 
    
    
    /**
    *   DOMDocument
    */
    window.$profiler.around({ target: DOMDocument,  method:"addEventListener"}, function(invocation) {
        return __profile__("DOMDocument.addEventListener", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"removeEventListener"}, function(invocation) {
        return __profile__("DOMDocument.removeEventListener", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"attachEvent"}, function(invocation) {
        return __profile__("DOMDocument.attachEvent", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"detachEvent"}, function(invocation) {
        return __profile__("DOMDocument.detachEvent", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"dispatchEvent"}, function(invocation) {
        return __profile__("DOMDocument.dispatchEvent", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"loadXML"}, function(invocation) {
        return __profile__("DOMDocument.loadXML", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"load"}, function(invocation) {
        return __profile__("DOMDocument.load", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createEvent"}, function(invocation) {
        return __profile__("DOMDocument.createEvent", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createExpression"}, function(invocation) {
        return __profile__("DOMDocument.createExpression", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createElement"}, function(invocation) {
        return __profile__("DOMDocument.createElement", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createDocumentFragment"}, function(invocation) {
        return __profile__("DOMDocument.createDocumentFragment", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createTextNode"}, function(invocation) {
        return __profile__("DOMDocument.createTextNode", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createComment"}, function(invocation) {
        return __profile__("DOMDocument.createComment", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createCDATASection"}, function(invocation) {
        return __profile__("DOMDocument.createCDATASection", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createProcessingInstruction"}, function(invocation) {
        return __profile__("DOMDocument.createProcessingInstruction", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createAttribute"}, function(invocation) {
        return __profile__("DOMDocument.createAttribute", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createElementNS"}, function(invocation) {
        return __profile__("DOMDocument.createElementNS", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createAttributeNS"}, function(invocation) {
        return __profile__("DOMDocument.createAttributeNS", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"createNamespace"}, function(invocation) {
        return __profile__("DOMDocument.createNamespace", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"getElementById"}, function(invocation) {
        return __profile__("DOMDocument.getElementById", invocation);
    });
    window.$profiler.around({ target: DOMDocument,  method:"normalizeDocument"}, function(invocation) {
        return __profile__("DOMDocument.normalizeDocument", invocation);
    });
    
    
    /**
    *   HTMLDocument
    */      
    window.$profiler.around({ target: HTMLDocument,  method:"createElement"}, function(invocation) {
        return __profile__("HTMLDocument.createElement", invocation);
    }); 
    
    /**
    *   DOMParser
    */      
    window.$profiler.around({ target: DOMParser,  method:"parseFromString"}, function(invocation) {
        return __profile__("DOMParser.parseFromString", invocation);
    }); 
    
    /**
    *   DOMNodeList
    */      
    window.$profiler.around({ target: DOMNodeList,  method:"item"}, function(invocation) {
        return __profile__("DOMNode.item", invocation);
    }); 
    window.$profiler.around({ target: DOMNodeList,  method:"toString"}, function(invocation) {
        return __profile__("DOMNode.toString", invocation);
    }); 
    
    /**
    *   XMLP
    */      
    window.$profiler.around({ target: XMLP,  method:"_addAttribute"}, function(invocation) {
        return __profile__("XMLP._addAttribute", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_checkStructure"}, function(invocation) {
        return __profile__("XMLP._checkStructure", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_clearAttributes"}, function(invocation) {
        return __profile__("XMLP._clearAttributes", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_findAttributeIndex"}, function(invocation) {
        return __profile__("XMLP._findAttributeIndex", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"getAttributeCount"}, function(invocation) {
        return __profile__("XMLP.getAttributeCount", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"getAttributeName"}, function(invocation) {
        return __profile__("XMLP.getAttributeName", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"getAttributeValue"}, function(invocation) {
        return __profile__("XMLP.getAttributeValue", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"getAttributeValueByName"}, function(invocation) {
        return __profile__("XMLP.getAttributeValueByName", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"getColumnNumber"}, function(invocation) {
        return __profile__("XMLP.getColumnNumber", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"getContentBegin"}, function(invocation) {
        return __profile__("XMLP.getContentBegin", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"getContentEnd"}, function(invocation) {
        return __profile__("XMLP.getContentEnd", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"getLineNumber"}, function(invocation) {
        return __profile__("XMLP.getLineNumber", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"getName"}, function(invocation) {
        return __profile__("XMLP.getName", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"next"}, function(invocation) {
        return __profile__("XMLP.next", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parse"}, function(invocation) {
        return __profile__("XMLP._parse", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parse"}, function(invocation) {
        return __profile__("XMLP._parse", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parseAttribute"}, function(invocation) {
        return __profile__("XMLP._parseAttribute", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parseCDATA"}, function(invocation) {
        return __profile__("XMLP._parseCDATA", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parseComment"}, function(invocation) {
        return __profile__("XMLP._parseComment", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parseDTD"}, function(invocation) {
        return __profile__("XMLP._parseDTD", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parseElement"}, function(invocation) {
        return __profile__("XMLP._parseElement", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parseEntity"}, function(invocation) {
        return __profile__("XMLP._parseEntity", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parsePI"}, function(invocation) {
        return __profile__("XMLP._parsePI", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_parseText"}, function(invocation) {
        return __profile__("XMLP._parseText", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_replaceEntities"}, function(invocation) {
        return __profile__("XMLP._replaceEntities", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_replaceEntity"}, function(invocation) {
        return __profile__("XMLP._replaceEntity", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_setContent"}, function(invocation) {
        return __profile__("XMLP._setContent", invocation);
    }); 
    window.$profiler.around({ target: XMLP,  method:"_setErr"}, function(invocation) {
        return __profile__("XMLP._setErr", invocation);
    }); 
    
    
    /**
    *   SAXDriver
    */      
    window.$profiler.around({ target: SAXDriver,  method:"parse"}, function(invocation) {
        return __profile__("SAXDriver.parse", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"setDocumentHandler"}, function(invocation) {
        return __profile__("SAXDriver.setDocumentHandler", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"setErrorHandler"}, function(invocation) {
        return __profile__("SAXDriver.setErrorHandler", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"setLexicalHandler"}, function(invocation) {
        return __profile__("SAXDriver.setLexicalHandler", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"getColumnNumber"}, function(invocation) {
        return __profile__("SAXDriver.getColumnNumber", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"getLineNumber"}, function(invocation) {
        return __profile__("SAXDriver.getLineNumber", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"getMessage"}, function(invocation) {
        return __profile__("SAXDriver.getMessage", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"getPublicId"}, function(invocation) {
        return __profile__("SAXDriver.getPublicId", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"getSystemId"}, function(invocation) {
        return __profile__("SAXDriver.getSystemId", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"getLength"}, function(invocation) {
        return __profile__("SAXDriver.getLength", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"getName"}, function(invocation) {
        return __profile__("SAXDriver.getName", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"getValue"}, function(invocation) {
        return __profile__("SAXDriver.getValue", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"getValueByName"}, function(invocation) {
        return __profile__("SAXDriver.getValueByName", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"_fireError"}, function(invocation) {
        return __profile__("SAXDriver._fireError", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"_fireEvent"}, function(invocation) {
        return __profile__("SAXDriver._fireEvent", invocation);
    }); 
    window.$profiler.around({ target: SAXDriver,  method:"_parseLoop"}, function(invocation) {
        return __profile__("SAXDriver._parseLoop", invocation);
    }); 
    
    /**
    *   SAXStrings    
    */
    window.$profiler.around({ target: SAXStrings,  method:"getColumnNumber"}, function(invocation) {
        return __profile__("SAXStrings.getColumnNumber", invocation);
    }); 
    window.$profiler.around({ target: SAXStrings,  method:"getLineNumber"}, function(invocation) {
        return __profile__("SAXStrings.getLineNumber", invocation);
    }); 
    window.$profiler.around({ target: SAXStrings,  method:"indexOfNonWhitespace"}, function(invocation) {
        return __profile__("SAXStrings.indexOfNonWhitespace", invocation);
    }); 
    window.$profiler.around({ target: SAXStrings,  method:"indexOfWhitespace"}, function(invocation) {
        return __profile__("SAXStrings.indexOfWhitespace", invocation);
    }); 
    window.$profiler.around({ target: SAXStrings,  method:"isEmpty"}, function(invocation) {
        return __profile__("SAXStrings.isEmpty", invocation);
    }); 
    window.$profiler.around({ target: SAXStrings,  method:"lastIndexOfNonWhitespace"}, function(invocation) {
        return __profile__("SAXStrings.lastIndexOfNonWhitespace", invocation);
    }); 
    window.$profiler.around({ target: SAXStrings,  method:"replace"}, function(invocation) {
        return __profile__("SAXStrings.replace", invocation);
    }); 
    
    /**
    *   Stack - SAX Utility
    window.$profiler.around({ target: Stack,  method:"clear"}, function(invocation) {
        return __profile__("Stack.clear", invocation);
    }); 
    window.$profiler.around({ target: Stack,  method:"count"}, function(invocation) {
        return __profile__("Stack.count", invocation);
    }); 
    window.$profiler.around({ target: Stack,  method:"destroy"}, function(invocation) {
        return __profile__("Stack.destroy", invocation);
    }); 
    window.$profiler.around({ target: Stack,  method:"peek"}, function(invocation) {
        return __profile__("Stack.peek", invocation);
    }); 
    window.$profiler.around({ target: Stack,  method:"pop"}, function(invocation) {
        return __profile__("Stack.pop", invocation);
    }); 
    window.$profiler.around({ target: Stack,  method:"push"}, function(invocation) {
        return __profile__("Stack.push", invocation);
    }); 
    */
}
      
