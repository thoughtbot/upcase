#!/bin/sh

svn co https://whattf.svn.cvsdude.com/htmlparser/trunk/ html5

cp BrowserTreeBuilder.java html5/gwt-src/nu/validator/htmlparser/gwt/BrowserTreeBuilder.java

cp gwt-1.5.1/gwt-dev-*.jar gwt-1.5.1/gwt-dev.jar

APPDIR=`dirname $0`/html5/;

echo $APPDIR

echo "Generating Minified HTMLParser"
java -XstartOnFirstThread -Xmx256M -cp "$APPDIR/src:$APPDIR/gwt-src:$APPDIR/super:./gwt-1.5.1/gwt-user.jar:./gwt-1.5.1/gwt-dev.jar" com.google.gwt.dev.GWTCompiler -out "build/min" "$@" nu.validator.htmlparser.HtmlParser;
cp ./build/min/nu.*.HtmlParser/nu.*.HtmlParser.nocache.js ./build/html5.min.js
perl -pi~ -e "s/if\(j\.addEventListener\)(.*)50\)/\/\*envjsedit\*\//" ./build/html5.min.js 
perl -pi~ -e "s/if\(j\.removeEventListener\)/if\(false\/\*envjsedit\*\/\)/" ./build/html5.min.js
perl -pi~ -e "s/function kb\(\)/\/\*envjsedit\*\/var kb = Html5Parser = function\(\)/" ./build/html5.min.js

echo "Generating Pretty HTMLParser"
java -XstartOnFirstThread -Xmx256M -cp "$APPDIR/src:$APPDIR/gwt-src:$APPDIR/super:./gwt-1.5.1/gwt-user.jar:./gwt-1.5.1/gwt-dev.jar" com.google.gwt.dev.GWTCompiler -style PRETTY -out "build/pretty" "$@" nu.validator.htmlparser.HtmlParser;
cp ./build/pretty/nu.*.HtmlParser/nu.*.HtmlParser.nocache.js ./build/html5.pretty.js
perl -pi~ -e "s/if(.*)\((.*)doc_0\.addEventListener\)/\/\*envjsedit/s" ./build/html5.pretty.js 
perl -pi~ -e "s/,\s50\);/envjsedit\*\//s" ./build/html5.pretty.js 
perl -pi~ -e "s/if(.*)\((.*)doc_0\.removeEventListener\)/if\(false\/\*envjsedit\*\/\)/" ./build/html5.pretty.js
perl -pi~ -e "s/function onBodyDone\(\)/\/\*envjsedit\*\/var onBodyDone = Html5Parser = function\(\)/" ./build/html5.pretty.js

echo "Generating Detailed HTMLParser"
java -XstartOnFirstThread -Xmx256M -cp "$APPDIR/src:$APPDIR/gwt-src:$APPDIR/super:./gwt-1.5.1/gwt-user.jar:./gwt-1.5.1/gwt-dev.jar" com.google.gwt.dev.GWTCompiler -style DETAILED -out "build/detailed" "$@" nu.validator.htmlparser.HtmlParser;
cp ./build/detailed/nu.*.HtmlParser/nu.*.HtmlParser.nocache.js ./build/html5.detailed.js
perl -pi~ -e "s/if(.*)\((.*)doc\.addEventListener\)/\/\*envjsedit/s" ./build/html5.detailed.js 
perl -pi~ -e "s/,\s50\);/envjsedit\*\//s" ./build/html5.detailed.js 
perl -pi~ -e "s/if(.*)\((.*)doc\.removeEventListener\)/if\(false\/\*envjsedit\*\/\)/" ./build/html5.detailed.js
perl -pi~ -e "s/function onBodyDone\(\)/\/\*envjsedit\*\/var onBodyDone = Html5Parser = function\(\)/" ./build/html5.detailed.js

rm ./build/*.js~

cp ./build/html5.*.js ../src/parser/
