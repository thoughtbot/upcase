{ short_date: "%x",              # 04/13/10
  long_date: "%a, %b %d, %Y",   # Tue, Apr 13, 2010
  simple: "%B %d, %Y",       # April 13, 2010
  time: "%l:%M%p",         # 08:52PM
  month: "%B",               # April
  blog_date: "%b %d, %Y"
}.each do |k, v|
  Time::DATE_FORMATS[k] = v
end
