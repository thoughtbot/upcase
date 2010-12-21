/*
*	env.rhino.js
*/
(function($env){
    
    $env.log = function(msg, level){
         print(' '+ (level?level:'LOG') + ':\t['+ new Date()+"] {ENVJS} "+msg);
    };
    
    $env.lineSource = function(e){
        return e&&e.rhinoException?e.rhinoException.lineSource():"(line ?)";
    };
    
    $env.sync = sync;
    $env.sleep = function(t){
      java.lang.Thread.currentThread().sleep(sleep);
    }
  
    //For Java the window.location object is a java.net.URL
    $env.location = function(path, base){
      var protocol = new RegExp('(^file\:|^http\:|^https\:)');
        var m = protocol.exec(path);
        if(m&&m.length>1){
            return new java.net.URL(path).toString()+'';
        }else if(base){
          return new java.net.URL(new java.net.URL(base), path).toString()+'';
        }else{
            //return an absolute url from a url relative to the window location
                base = window.location.href.substring(0, window.location.href.lastIndexOf('/'));
            if(window.location.href.length > 0){
                return base + '/' + path;
            }else{
                return new java.io.File(  path ).toURL().toString()+'';
            }
        }
    };
    
    //Since we're running in rhino I guess we can safely assume
    //java is 'enabled'.  I'm sure this requires more thought
    //than I've given it here
    $env.javaEnabled = true;	
    
    
    //Used in the XMLHttpRquest implementation to run a
    // request in a seperate thread
    $env.onInterrupt = function(){};
    $env.runAsync = function(fn){
        $env.debug("running async");
        var running = true;
        
        var run = sync(function(){ //while happening only thing in this timer    
    	    //$env.debug("running timed function");
            fn();
        });
        
        try{
            spawn(run);
        }catch(e){
            $env.error("error while running async", e);
            $env.onInterrupt();
        }
    };
    
    //Used to write to a local file
    $env.writeToFile = function(text, url){
        $env.debug("writing text to url : " + url);
        var out = new java.io.FileWriter( 
            new java.io.File( 
                new java.net.URI(url.toString())));	
        out.write( text, 0, text.length );
        out.flush();
        out.close();
    };
    
    //Used to write to a local file
    $env.writeToTempFile = function(text, suffix){
        $env.debug("writing text to temp url : " + suffix);
        // Create temp file.
        var temp = java.io.File.createTempFile("envjs-tmp", suffix);
    
        // Delete temp file when program exits.
        temp.deleteOnExit();
    
        // Write to temp file
        var out = new java.io.FileWriter(temp);
        out.write(text, 0, text.length);
        out.close();
        return temp.getAbsolutePath().toString()+'';
    };
    
    //Used to delete a local file
    $env.deleteFile = function(url){
        var file = new java.io.File( new java.net.URI( url ) );
        file["delete"]();
    };
    
    $env.connection = function(xhr, responseHandler, data){
        var url = java.net.URL(xhr.url);//, $w.location);
      var connection;
        if ( /^file\:/.test(url) ) {
            try{
                if ( xhr.method == "PUT" ) {
                    var text =  data || "" ;
                    $env.writeToFile(text, url);
                } else if ( xhr.method == "DELETE" ) {
                    $env.deleteFile(url);
                } else {
                    connection = url.openConnection();
                    connection.connect();
                    //try to add some canned headers that make sense
                    
                    try{
                        if(xhr.url.match(/html$/)){
                            xhr.responseHeaders["Content-Type"] = 'text/html';
                        }else if(xhr.url.match(/.xml$/)){
                            xhr.responseHeaders["Content-Type"] = 'text/xml';
                        }else if(xhr.url.match(/.js$/)){
                            xhr.responseHeaders["Content-Type"] = 'text/javascript';
                        }else if(xhr.url.match(/.json$/)){
                            xhr.responseHeaders["Content-Type"] = 'application/json';
                        }else{
                            xhr.responseHeaders["Content-Type"] = 'text/plain';
                        }
                    //xhr.responseHeaders['Last-Modified'] = connection.getLastModified();
                    //xhr.responseHeaders['Content-Length'] = headerValue+'';
                    //xhr.responseHeaders['Date'] = new Date()+'';*/
                    }catch(e){
                        $env.error('failed to load response headers',e);
                    }
                    	
                }
            }catch(e){
                $env.error('failed to open file '+ url, e);
                connection = null;
                xhr.readyState = 4;
                xhr.statusText = "Local File Protocol Error";
                xhr.responseText = "<html><head/><body><p>"+ e+ "</p></body></html>";
            }
        } else { 
            connection = url.openConnection();
            connection.setRequestMethod( xhr.method );
			
            // Add headers to Java connection
            for (var header in xhr.headers){
                connection.addRequestProperty(header+'', xhr.headers[header]+'');
            }
			
			//write data to output stream if required
            if(data&&data.length&&data.length>0){
				 if ( xhr.method == "PUT" || xhr.method == "POST" ) {
                	connection.setDoOutput(true);
					var outstream = connection.getOutputStream(),
						outbuffer = new java.lang.String(data).getBytes('UTF-8');
					
                    outstream.write(outbuffer, 0, outbuffer.length);
					outstream.close();
            	}
			}else{
		  		connection.connect();
			}
			
            
        }
        if(connection){
            try{
                var respheadlength = connection.getHeaderFields().size();
                // Stick the response headers into responseHeaders
                for (var i = 0; i < respheadlength; i++) { 
                    var headerName = connection.getHeaderFieldKey(i); 
                    var headerValue = connection.getHeaderField(i); 
                    if (headerName)
                        xhr.responseHeaders[headerName+''] = headerValue+'';
                }
            }catch(e){
                $env.error('failed to load response headers',e);
            }
            
            xhr.readyState = 4;
            xhr.status = parseInt(connection.responseCode,10) || undefined;
            xhr.statusText = connection.responseMessage || "";
            
            var contentEncoding = connection.getContentEncoding() || "utf-8",
                baos = new java.io.ByteArrayOutputStream(),
                buffer = java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024),
                length,
                stream = null,
                responseXML = null;

            try{
                stream = (contentEncoding.equalsIgnoreCase("gzip") || contentEncoding.equalsIgnoreCase("decompress") )?
                        new java.util.zip.GZIPInputStream(connection.getInputStream()) :
                        connection.getInputStream();
            }catch(e){
                if (connection.getResponseCode() == 404)
                    $env.info('failed to open connection stream \n' +
                              e.toString(), e);
                else
                    $env.error('failed to open connection stream \n' +
                               e.toString(), e);
                stream = connection.getErrorStream();
            }
            
            while ((length = stream.read(buffer)) != -1) {
                baos.write(buffer, 0, length);
            }

            baos.close();
            stream.close();

            xhr.responseText = java.nio.charset.Charset.forName("UTF-8").
                decode(java.nio.ByteBuffer.wrap(baos.toByteArray())).toString()+"";
                
        }
        if(responseHandler){
            $env.debug('calling ajax response handler');
            responseHandler();
        }
    };
    
    var htmlDocBuilder = Packages.javax.xml.parsers.DocumentBuilderFactory.newInstance();
    htmlDocBuilder.setNamespaceAware(false);
    htmlDocBuilder.setValidating(false);
    
    var tidy;
    $env.tidyHTML = false;
    $env.tidy = function(htmlString){
        $env.debug('Cleaning html :\n'+htmlString);
        var xmlString,
		    baos = new java.io.ByteArrayOutputStream(),
		    bais = new java.io.ByteArrayInputStream(
			           (new java.lang.String(htmlString)).
					        getBytes("UTF8"));
		try{
	        if(!tidy){
	            tidy = new org.w3c.tidy.Tidy();
	        }
            $env.debug('tidying');
	        tidy.parse(bais,baos);
			xmlString = java.nio.charset.Charset.forName("UTF-8").
                decode(java.nio.ByteBuffer.wrap(baos.toByteArray())).toString()+"";
            $env.debug('finished tidying');
		}catch(e){
            $env.error('error in html tidy', e);
        }finally{
            try{
                bais.close();
                baos.close();
            }catch(ee){
                //swallow
            }
        }
        $env.debug('Cleaned html :\n'+xmlString);
        return xmlString;
    };
    
    var xmlDocBuilder = Packages.javax.xml.parsers.DocumentBuilderFactory.newInstance();
    xmlDocBuilder.setNamespaceAware(true);
    xmlDocBuilder.setValidating(false);
    
    $env.parseXML = function(xmlstring){
        return xmlDocBuilder.newDocumentBuilder().parse(
                  new java.io.ByteArrayInputStream(
                        (new java.lang.String(xmlstring)).getBytes("UTF8")));
    };
    
    
    $env.xpath = function(expression, doc){
        return Packages.javax.xml.xpath.
          XPathFactory.newInstance().newXPath().
            evaluate(expression, doc, javax.xml.xpath.XPathConstants.NODESET);
    };
    
    var jsonmlxslt;
    $env.jsonml = function(xmlstring){
        jsonmlxslt = jsonmlxslt||$env.xslt($env.xml2jsonml.toXMLString());
        var jsonml = $env.transform(jsonmlxslt, xmlstring);
        //$env.debug('jsonml :\n'+jsonml);
        return eval(jsonml);
    };
    var transformerFactory;
    $env.xslt = function(xsltstring){
        transformerFactory = transformerFactory||
            Packages.javax.xml.transform.TransformerFactory.newInstance();
        return transformerFactory.newTransformer(
              new javax.xml.transform.dom.DOMSource(
                  $env.parseXML(xsltstring)
              )
          );
    };
    $env.transform = function(xslt, xmlstring){
        var baos = new java.io.ByteArrayOutputStream();
        xslt.transform(
            new javax.xml.transform.dom.DOMSource($env.parseHTML(xmlstring)),
            new javax.xml.transform.stream.StreamResult(baos)
        );
        return java.nio.charset.Charset.forName("UTF-8").
            decode(java.nio.ByteBuffer.wrap(baos.toByteArray())).toString()+"";
    };
    
    $env.tmpdir         = java.lang.System.getProperty("java.io.tmpdir"); 
    $env.os_name        = java.lang.System.getProperty("os.name"); 
    $env.os_arch        = java.lang.System.getProperty("os.arch"); 
    $env.os_version     = java.lang.System.getProperty("os.version"); 
    $env.lang           = java.lang.System.getProperty("user.lang"); 
    $env.platform       = "Rhino ";//how do we get the version

    $env.scriptTypes = {
        "text/javascript"   :false,
        "text/envjs"        :true
    };
    
    
    $env.loadInlineScript = function(script){
        var tmpFile = $env.writeToTempFile(script.text, 'js') ;
        $env.debug("loading " + tmpFile);
        $env.loadIntoFnsScope(tmpFile);
    };
    
    //injected by org.mozilla.javascript.tools.envjs.
    $env.getFreshScopeObj = getFreshScopeObj;
    $env.getProxyFor = getProxyFor;
    $env.getScope = getScope;
    $env.setScope = setScope;
    $env.configureScope = configureScope;
    $env.restoreScope = restoreScope;
    
})(Envjs);