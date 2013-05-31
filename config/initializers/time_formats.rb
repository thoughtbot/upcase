#
# Date and Time formats
#
{
  short_date: '%x',
  simple: '%B %d, %Y',
  rfc822: '%a, %d %b %Y %H:%M:%S %z',
  month: '%B',
  invoice: '%y%m%d'
}.each do |k, v|
  Date::DATE_FORMATS[k] = v
  Time::DATE_FORMATS[k] = v
end

#
# Time formats
#
Time::DATE_FORMATS.merge!({
  time: '%l:%M%p'
})
