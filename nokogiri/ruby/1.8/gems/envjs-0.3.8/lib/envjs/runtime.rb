require 'envjs'
require "open-uri"
require 'pathname'
require 'envjs/net/file'

$wake_info = []

module Envjs::Runtime

  def self.extended object
    object.instance_eval do

      outer = nil
      scripts = {}
      
      master = global["$master"] = evaluate("new Object", nil, nil, nil, global)
      
      ( class << self; self; end ).send :define_method, :master do
        master
      end

      ( class << self; self; end ).send :define_method, :evaluate do |*args|
        ( script, file, line, global, scope, fn ) = *args
        scope ||= outer["$inner"]
        raise "cannot evaluate nil script" if script.nil?
        raise "cannot evaluate without a scope" if scope.nil?
        raise "outer given when inner needed" if !scope == global and !scope["isInner"]
        # print "eval in " + script[0,50].inspect + scope.inspect + " " + ( scope ? scope.isInner.inspect : "none" ) + "\n"
        global = nil
        # scope ||= inner
        if fn
          compiled_script = scripts[fn]
        end
        compiled_script ||= compile(script, file, line, global)
        raise "hell" if !compiled_script
        if fn && !scripts[fn]
          scripts[fn] = compiled_script
        end
        save = master["first_script_window"]
        if false
          p scope
          if master["first_script_window"]
            print "ignored: " +  ( scope["location"] ? scope["location"]["href"] : "nil" ) + " using " + ( master["first_script_window"]["location"] ?  master["first_script_window"]["location"]["href"] : "nil" ) + "\n"
          else
            print "pushing into " + ( scope["location"] ? scope["location"]["href"] : "nil" ) + "\n"
          end
        end

        master["first_script_window"] ||= scope
        raise "hell" if !master["first_script_window"]["isInner"] && master["first_script_window"] != self.global
        v = nil
        begin
          v = evaluate_compiled_script(compiled_script,scope)
          # p "pe", v, compiled_script, scope
        rescue Exception => e
          # p "oopsrt", e
          raise e
        ensure
          master["first_script_window"] = save
        end
        # print "done\n"
        v
      end

      evaluate( <<'EOJS', nil, nil, nil, global )
print = function() {
  var l = arguments.length
  for( var i = 0; i < l; i++ ) {
    var s;
    if ( arguments[i] === null ) {
      s = "null";
    } else if ( arguments[i] === undefined  ) {
      s = "undefined"      
    } else {
      s = arguments[i].toString();
    }
    Ruby.print(s);
    if( i < l-1 ) {
      Ruby.print(" ");
    }
  }
  Ruby.print("\n");
  Ruby['$stdout'].flush();
};
EOJS

      evaluate <<'EOJS', nil, nil, nil, global
debug = function() {
  var l = arguments.length
  for( var i = 0; i < l; i++ ) {
    var s;
    if ( arguments[i] === null ) {
      s = "null";
    } else if ( arguments[i] === undefined  ) {
      s = "undefined"      
    } else {
      s = arguments[i].toString();
    }
    Ruby['$stderr'].print(s);
    if( i < l-1 ) {
      Ruby['$stderr'].print(" ");
    }
  }
  Ruby['$stderr'].print("\n");
  Ruby['$stderr'].flush();
};
EOJS

      evaluate <<'EOJS', nil, nil, nil, global
puts = function() {
  var l = arguments.length
  for( var i = 0; i < l; i++ ) {
    var s;
    if ( arguments[i] === null ) {
      s = "null";
    } else if ( arguments[i] === undefined  ) {
      s = "undefined"      
    } else {
      s = arguments[i].toString();
    }
    Ruby.print(s);
    Ruby.eval("$stdout.flush")
  }
};
EOJS

      master["runtime"] = self
      window_index = -1
      master["next_window_index"] = lambda { window_index += 1 }
      master.symbols = [ "Johnson", "Ruby", "print", "debug", "puts", "load", "reload", "whichInterpreter", "multiwindow", "seal" ]
      master.symbols.each { |symbol| master[symbol] = global[symbol] }
      master["seal"] = lambda do |*args|
        object, deep = *args
        seal object, deep
      end

      master.whichInterpreter = "Johnson"

      master.multiwindow = true

      # calling this from JS is hosed; the ruby side is confused, maybe because HTTPHeaders is mixed in?
      master.add_req_field = lambda { |r,k,v| r.add_field(k,v) }

      top_level_js = nil

      add_dep = nil
      
      add_dep = lambda do |w, f|
        if $envjsrb_wake
          $wake_info << "##file://#{f}"
        end
      end

      (class << self; self; end).send :define_method, :top_level_load do |path|
        if $envjsrb_wake
          $wake_info << "##{path}" if path
        end
      end

      master.load = lambda { |*files|
        if files.length == 2 && !(String === files[1])
          # now = Time.now
          f = files[0]
          w = files[1]
          # p "load", f, w

          # Hmmm ...
          uri = URI.parse f

          if uri.scheme == nil
            uri.scheme = "file"
            begin
              uri.path = Pathname.new(uri.path).realpath.to_s
            rescue Errno::ENOENT; end
            uri = URI.parse uri.to_s
          end

          uri_s = uri.to_s.sub %r(^file:/([^/])), 'file:///\1'

          if uri.scheme == "file"
            uri_s = uri.path
          elsif uri.scheme == "data"
            raise "implement 0"
          end

          v = open(uri_s).read.gsub(/\A#!.*$/, '')
          loc = nil
          add_dep.call w, f
          evaluate(v, f, 1, w, w, f)
        else
          load *files
        end
      }

      ( class << self; self; end ).send :define_method, :load do |*files|
        files.map { |f|
          # Hmmm ...

          uri = URI.parse f
          if uri.scheme == nil
            uri.scheme = "file"
            begin
              uri.path = Pathname.new(uri.path).realpath.to_s
            rescue Errno::ENOENT; end
            uri = URI.parse uri.to_s
          end
          uri_s = uri.to_s.sub %r(^file:/([^/])), 'file:///\1'
          
          if uri.scheme == "file"
            begin
              super uri.path
            rescue Exception => e
              if outer["$inner"]["onerror"]
                # outer["$inner"]["onerror"].call e
                evaluate("function(fn,scope,e){fn.call(scope,e)}").call(outer["$inner"]["onerror"], outer["$inner"], e)
              else
                raise e
              end
            end
          elsif uri.scheme == "data"
            raise "implement 1"
          elsif uri.scheme == "javascript"
            evaluate(URI.decode(uri.opaque),URI.decode(uri_s),1)
          else
            raise "hell 1: " + uri.inspect
          end

          # v = open(uri_s).read.gsub(/\A#!.*$/, '')
          # loc = nil
          # add_dep.call w, f
          # evaluate(v, f, 1, w, w, f)
          # evaluate(File.read(f).gsub(/\A#!.*$/, ''), f, 1)

        }.last
      end

      master.reload = lambda { |*files|
        if files.length == 2 && !(String === files[1])
          f = files[0]
          w = files[1]
          v = open(f).read.gsub(/\A#!.*$/, '')
          loc = nil
          add_dep.call w, f
          reevaluate(v, f, 1, w, w, f)
        else
          reload *files
        end
      }

      master.evaluate = lambda { |v,w|
        evaluate(v,"inline",1,w,w);
      }

      master.new_split_global_outer = lambda { new_split_global_outer }
      master.new_split_global_inner = lambda { |outer,_| new_split_global_inner outer }

      # create an proto window object and proxy

      outer = new_split_global_outer
      inner = new_split_global_inner( outer )

      master.symbols.each do |symbol|
        inner[symbol] = master[symbol]
      end

      inner["$inner"] = inner
      inner["$master"] = master
      inner["$options"] = evaluate("new Object", nil, nil, nil, inner);
      inner["$options"].proxy = outer

      inner.evaluate = lambda { |s|
        return master.evaluate.call(s,inner);
      }

      inner.load = lambda { |*files|
        files.each do |f|
          master['load'].call f, inner
        end
      }

      inner.reload = lambda { |*files|
        files.each do |f|
          master.reload.call f, inner
        end
      }

      ( class << self; self; end ).send :define_method, :wait do
        master["finalize"] && master.finalize.call
        master.eventLoop && master.eventLoop.wait
      end

      ( class << self; self; end ).send :define_method, :_become_first_script_window do
        # p "heh ++++++++++++++++++++++++++++", inner, master.first_script_window
        inner = master.first_script_window
      end

      ( class << self; self; end ).send :define_method, :reevaluate do |*args|
        ( script, file, line, global, scope, fn ) = *args
        raise "cannot evaluate nil script" if script.nil?
        # print "eval in " + script[0,50].inspect + (scope ? scope.toString() : "nil") + "\n"
        global = nil
        scope ||= inner
        compiled_script = compile(script, file, line, global)
        if fn
          scripts[fn] = compiled_script
        end
        begin
          evaluate_compiled_script(compiled_script,scope)
        rescue Exception => e
          p e
          raise e
        end
      end

      ( class << self; self; end ).send :define_method, :"[]" do |key|
        # key == "this" && evaluate("this", nil, nil, nil, inner) || @envjs[key]
        key == "this" && outer || outer[key]
      end

      ( class << self; self; end ).send :define_method, :"[]=" do |k,v|
        # inner[k] = v
        outer[k] = v
      end

      master['load'].call Envjs::EVENT_LOOP, global
      
      static = new_global
      
      master.symbols.each do |symbol|
        static[symbol] = master[symbol]
      end

      static["$master"] = master

      # fake it ...
      static["isInner"] = true
      master['load'].call Envjs::STATIC, static
      master["static"] = static

      master['load'].call Envjs::ENVJS, inner

      inner = nil
    end
  end

end
