require 'erb'
require 'cgi'
require 'stackdeck'

module Rack
  # Rack::ShowStackDeck catches all exceptions raised from the app it
  # wraps.  It shows a useful backtrace with the sourcefile and
  # clickable context, the whole Rack environment and the request
  # data.
  #
  # Be careful when you use this on public-facing sites as it could
  # reveal information helpful to attackers.
  #
  # Rack::ShowStackDeck is based on, and functionally very similar to,
  # Rack::ShowExceptions -- the key difference is that it uses the
  # StackDeck library to show the full cross-language backtrace, where
  # relevant.

  class ShowStackDeck
    FILTER_ENV = [/^rack\./]
    HIDE_FIELD = []

    def initialize(app, options={})
      @app = app
      @template = ERB.new(TEMPLATE)
      @exception_status = Hash.new(500)
      @exception_status.update(options[:exception_status]) if options[:exception_status]
    end

    def call(env)
      @app.call(env)
    rescue StandardError, ScriptError, Timeout::Error => e
      data, status = pretty_data(env, e)

      [status, {"Content-Type" => "text/html"}, [@template.result(data)]]
    end

    private

    def filter_environment(env)
      filtered_env = {}
      env.each do |k, v|
        next if FILTER_ENV.any? {|hide| hide === k }
        filtered_env[k] = v
      end

      filtered_env
    end

    def hide_request_field?(name)
      HIDE_FIELD.any? {|hide| hide === name }
    end

    def pretty_data(env, exception)
      req = Rack::Request.new(env)
      path = ('/' + req.script_name + req.path_info).squeeze("/")

      frames = exception.stack_deck

      exception_name = exception.respond_to?(:name) ? exception.name : exception.class.name
      html_message = exception.respond_to?(:html_message) ? exception.html_message : h( exception.to_s )
      status = exception.respond_to?(:http_status) ? exception.http_status : @exception_status[exception.class.name]


      hidden = Object.new

      info_groups = [
        ['GET', (req.GET rescue nil)],
        ['POST', (req.POST rescue nil)],
        ['Cookies', (req.cookies rescue nil)],
        ['Session', env["rack.session"]],
        ['Rack ENV', filter_environment(env)],
      ].map {|(name, data)|
        [name,
          case data
          when nil
            nil
          when Hash
            [%w(Variable Value)] + data.to_a.sort.map {|(k,v)| [k.to_s, hide_request_field?(k) ? hidden : v] } unless data.empty?
          when Array
            [%w(Value)] + data.map {|a| [a] }
          else
            [%w(Value)] + [data]
          end
        ]
      }

      first_frames = []
      seen_languages = []
      frames.each do |frame|
        next if seen_languages.include?( frame.language )
        first_frames << frame
        seen_languages << frame.language
      end

      [binding, status]
    end

    def h(obj)                  # :nodoc:
      obj = obj.inspect unless String === obj
      Utils.escape_html(obj).gsub(/\n/, "<br />\n")
    end

    def ident(s)                # :nodoc:
      s.downcase.gsub(/[^a-z]+/, '-')
    end

    def html_frame(frame, with_context=false)
      html = if frame.filename && frame.function == ''
               "<code>#{h frame.filename}</code>: in function"
             elsif frame.filename && frame.function
               "<code>#{h frame.filename}</code>: in <code>#{h frame.function}</code>"
             elsif frame.filename
               "<code>#{h frame.filename}</code>"
             elsif frame.function == ''
               "in function"
             elsif frame.function
               "in <code>#{h frame.function}</code>"
             elsif frame.language
               "in #{h frame.language}"
             else
               "unknown"
             end

      clues = []
      clues << "on line #{frame.lineno}" if frame.lineno && !(with_context && frame.context?)
      clues << frame.clue if frame.clue
      unless clues.empty?
        html << " (#{h clues.join(', ')})"
      end

      html
    end

    # :stopdoc:

# adapted from Django <djangoproject.com>
# Copyright (c) 2005, the Lawrence Journal-World
# Used under the modified BSD license:
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
TEMPLATE = <<'HTML'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta name="robots" content="NONE,NOARCHIVE" />
  <title><%=h exception_name %> at <%=h path %></title>
  <style type="text/css">
    html * { padding:0; margin:0; }
    body * { padding:10px 20px; }
    body * * { padding:0; }
    body { font:small sans-serif; }
    body>div { border-bottom:1px solid #ddd; }
    h1 { font-weight:normal; }
    h2 { margin-bottom:.8em; }
    h2 span { font-size:80%; color:#666; font-weight:normal; }
    h2 code { font-family:monospace; color:black; font-weight:normal; font-size: 80%; }
    h3 { margin:1em 0 .5em 0; }
    table {
        border:1px solid #ccc; border-collapse: collapse; background:white; }
    tbody td, tbody th { vertical-align:top; padding:2px 3px; }
    thead th {
        padding:1px 6px 1px 3px; background:#fefefe; text-align:left;
        font-weight:normal; font-size:11px; border:1px solid #ddd; }
    tbody th { text-align:right; color:#666; padding-right:.5em; }
    table.req td { border-top: 1px solid #eee; }
    table.req td.code { border-left: 1px solid #eee; }
    table td.code { font-family: monospace; width: 100%; }
    table td.code div { overflow:hidden; }
    ul.traceback { list-style-type:none; }
    ul.traceback li.frame { margin-bottom:1em; }
    div.context { margin: 10px 0; }
    div.context.solid { padding-left: 30px; margin: 10px 10px; }
    div.context.solid div.context-line { padding-left: 18px; font-family:monospace; white-space: pre-wrap; background-color:#ccc; }
    div.context ol {
        padding-left:30px; margin:0 10px; list-style-position: inside; }
    div.context ol li {
        padding-left: 28px; text-indent: -28px; font-family:monospace; white-space:pre-wrap; color:#666; cursor:pointer; }
    div.context ol.context-line li { position: relative; padding-right: 4em; color:black; background-color:#ccc; }
    div.context ol.context-line li span { position: absolute; right: 0.5em; content: "..."; }
    #summary { background: #ffc; }
    #summary h2 { font-weight: normal; color: #666; }
    #summary ul#quicklinks { list-style-type: none; margin-bottom: 2em; }
    #summary ul#quicklinks>li { float: left; padding: 0 1em; }
    #summary ul#quicklinks>li+li { border-left: 1px #666 solid; }
    #explanation { background:#eee; }
    #traceback { background:#eee; }
    #requestinfo { background:#f6f6f6; padding-left:120px; }
    #summary table { border:none; background:transparent; }
    #requestinfo h2, #requestinfo h3 { position:relative; margin-left:-100px; }
    #requestinfo h3 { margin-bottom:-1em; }
  </style>
  <script type="text/javascript">
  //<!--
    function getElementsByClassName(oElm, strTagName, strClassName){
        // Written by Jonathan Snook, http://www.snook.ca/jon;
        // Add-ons by Robert Nyman, http://www.robertnyman.com
        var arrElements = (strTagName == "*" && document.all)? document.all :
        oElm.getElementsByTagName(strTagName);
        var arrReturnElements = new Array();
        strClassName = strClassName.replace(/\-/g, "\\-");
        var oRegExp = new RegExp("(^|\\s)" + strClassName + "(\\s|$$)");
        var oElement;
        for(var i=0; i<arrElements.length; i++){
            oElement = arrElements[i];
            if(oRegExp.test(oElement.className)){
                arrReturnElements.push(oElement);
            }
        }
        return (arrReturnElements)
    }
    function hideAll(elems) {
      for (var e = 0; e < elems.length; e++) {
        elems[e].style.display = 'none';
      }
    }
    window.onload = function() {
      hideAll(getElementsByClassName(document, 'ol', 'pre-context'));
      hideAll(getElementsByClassName(document, 'ol', 'post-context'));
    }
    function toggle() {
      for (var i = 0; i < arguments.length; i++) {
        var e = document.getElementById(arguments[i]);
        if (e) {
          e.style.display = e.style.display == 'none' ? 'block' : 'none';
        }
      }
      return false;
    }
    //-->
  </script>
</head>
<body>

<div id="summary">
  <h1><%=h exception_name %> at <%=h path %></h1>
  <h2><%= html_message %></h2>
  <table>
  <% first_frames.each do |frame| %>
  <tr>
    <th><%=h frame.language %></th>
    <td><%= html_frame(frame) %></td>
  </tr>
  <% end %>
  <tr>
    <th>Web</th>
    <td><code><%=h req.request_method %> <%=h(req.host + (req.port == 80 ? '' : ":#{req.port}") + path)%></code></td>
  </tr>
  </table>

  <h3>Jump to:</h3>
  <ul id="quicklinks">
<% info_groups.each do |(label, data)| %>
  <% unless data.nil? || data.empty? %>
    <li><a href="#<%=h ident(label) %>-info"><%=h label %></a></li>
  <% else %>
    <li><%=h label %></li>
  <% end %>
<% end %>
  </ul>
</div>

<div id="traceback">
  <h2>Traceback <span>(innermost first)</span></h2>
  <ul class="traceback">
<% frames.each { |frame| %>
      <li class="frame <%=h ident(frame.language) %>"><%= html_frame(frame, true) %>

<% if frame.context? && (frame.context.before || frame.context.after) %>
          <div class="context" id="c<%=h frame.object_id %>" onclick="toggle('pre<%=h frame.object_id %>', 'post<%=h frame.object_id %>')">
            <% if frame.context.before %>
            <ol start="<%=h frame.context.before_lineno+1 %>" class="pre-context" id="pre<%=h frame.object_id %>">
            <% frame.context.before.each { |line| %>
              <li><%=h line %></li>
            <% } %>
            </ol>
            <% end %>

            <ol start="<%=h frame.lineno %>" class="context-line">
              <li><%=h frame.context.line %><span></span></li>
            </ol>

            <% if frame.context.after %>
            <ol start='<%=h frame.lineno+1 %>' class="post-context" id="post<%=h frame.object_id %>">
            <% frame.context.after.each { |line| %>
              <li><%=h line %></li>
            <% } %>
            </ol>
            <% end %>
          </div>

<% elsif frame.context? %>
          <div class="context solid">
            <div class="context-line"><%=h frame.context.line %></div>
          </div>

<% end %>
      </li>
<% } %>
  </ul>
</div>

<div id="requestinfo">
  <h2>Request information</h2>

<% info_groups.each do |(label, data)| %>
  <h3 id="<%=h ident(label) %>-info"><%=h label %></h3>
  <% unless data.nil? || data.empty?
    header = data.shift %>
  <table class="req">
    <thead>
      <tr>
        <% header.each do |hd| %>
        <th><%=h hd %></th>
        <% end %>
      </tr>
    </thead>
    <tbody>
      <% data.each do |(key, val)| %>
      <tr>
        <td><%=h key %></td>
        <td class="code"><div><%= val == hidden ? "<em>(hidden)</em>" : h(val) %></div></td>
      </tr>
      <% end %>
    </tbody>
  </table>
  <% else %>
  <p>No data.</p>
  <% end %>
<% end %>

</div>

<div id="explanation">
  <p>
    You're seeing this error because you use <code>Rack::ShowStackDeck</code>.
  </p>
</div>

</body>
</html>
HTML

    # :startdoc:
  end
end

