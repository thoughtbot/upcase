#
# Date and Time formats
#
{
  short_date: '%x',
  simple: '%B %d, %Y'
}.each do |k, v|
  Date::DATE_FORMATS[k] = v
  Time::DATE_FORMATS[k] = v
end

#
# Time formats
#
Time::DATE_FORMATS.merge!({
  month: '%B',
  time: '%l:%M%p'
})
