module Envjs

  VERSION = "0.3.8"

  def self.js_exception_stack e
    result = %(Exception: )+e.to_s
    e.stack.to_s.split(%(\n)).each do |line|
      next if line == "@:0"
      m = line.match(/(.*)@([^@]*)$/)
      s = m[1]
      limit = 50
      if ( s.length > limit )
        s = s[0,limit] + %(...)
      end
      result += "\n" + m[2]+%( )+s
    end
    result
  end
  
  ENVJS = 
    File.expand_path( File.join( File.dirname(__FILE__),
                                  "envjs",
                                  "env.js" ) )

  EVENT_LOOP = 
    File.expand_path( File.join( File.dirname(__FILE__),
                                  "envjs",
                                  "event_loop.js" ) )

  STATIC = 
    File.expand_path( File.join( File.dirname(__FILE__),
                                  "envjs",
                                  "static.js" ) )

end
