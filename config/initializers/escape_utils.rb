# Fix issue where rack complains about UTF-8 encoding.
#
# See http://crimpycode.brennonbortz.com/?p=42
module Rack
  module Utils
    def escape(s)
      EscapeUtils.escape_url(s)
    end
  end
end
