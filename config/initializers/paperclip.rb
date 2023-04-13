# `URI.escape` was obsoleted in Ruby 1.9 and removed in Ruby 2.7; this
# replaces (within the context of only this class) `URI` with
# `::URI::DEFAULT_PARSER` (which is defined as `::URI::RFC2396_Parser.new),
# which is what `URI.escape` used before it was removed.
#
# This would be a dangerous solution in most other cases, since it would
# affect all references to `URI` within a class/module, but it's safe here
# because Paperclip is deprecated and therefore we know that it will never
# be updated.
Paperclip::UrlGenerator.class_eval do
  const_set :URI, ::URI::DEFAULT_PARSER
  private_constant :URI
end
