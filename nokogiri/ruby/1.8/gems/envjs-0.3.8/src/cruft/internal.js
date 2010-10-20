/**
 * @author thatcher
 */
//html passed to env external filter 1 (html to xml)
<html lang="en" xml:lang='en'>
    <head>
		<title>Hello World</title>
		<meta 	content="en-us" 
			    http-equiv="Content-Language"/>
		<meta 	content="text/html; charset=utf-8" 
				http-equiv="Content-Type"/>
        <script type='text/javascript'>
            document.write("<script>");                     
            document.write("var foo = \'hello world\'");    
            document.write("</script>");                    
        </script>
    </head>
    <body>
        <h1>hello world!</h1>
        <div><!-- note  div not closed properly -->
            <ul>
                <li>item 1</li>
                <li>item 2</li>
                <li>item 3 <a href='another/page.html'>link</a> to another page!</li>
            </ul>
        <div>
    </body>
</html>

//xml passed to env external filter 2 (xml to javascript)
<html lang="en" xml:lang='en'>
    <head>
		<title>Hello World</title>
		<meta 	content="en-us" 
			    http-equiv="Content-Language"/>
		<meta 	content="text/html; charset=utf-8" 
				http-equiv="Content-Type"/>
        <script type='text/javascript'>
            document.write("<script>");                     
            document.write("var foo = \'hello world\'");    
            document.write("</script>");                    
        </script>
    </head>
    <body>
        <h1>hello world!</h1>
        <div>
            <ul>
                <li>item 1</li>
                <li>item 2</li>
                <li>item 3 <a href='another/page.html'>link</a> to another page!</li>
            </ul>
        </div>
    </body>
</html>

//Result passed to env internal parser
_={html:{ lang:'en', xml$lang:'en', $:[
    {head:{$:[
        {title:{$:['Hello World']}},
        {meta:{ content:'en-us', 'http-equiv':'Content-Language'}},
        {meta:{ content:'text/html; charset=utf-8', 'http-equiv':'Content-Type'}},
        {script:{ type:'text/javascript', $:['\
            document.write("<script>");\
            document.write("var foo = \'hello world\'");\
            document.write("</script>");\
        ']}},
        {body:{$:[
            {h1:{$:['hello world!']}},
            {div:{ clazz:'abc def ghi', $:[
                {p:{$:['my name is chris thatcher']}},
                {ul:{$:[
                    {li:{$:['item 1']}},
                    {li:{$:['item 2']}},
                    {li:{$:[
                        'item 3 has ',{a:{href:'another/page.html', $:['link']}}, 'to another page!'
                    ]}}
                ]}}
            ]}}
        ]}}
    ]}}
]}};