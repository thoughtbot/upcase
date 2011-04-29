require 'redcloth'
require 'open-uri'

Dir[File.join(Rails.root, 'lib', 'extensions', '*.rb')].each do |f|
  require f
end

Dir[File.join(Rails.root, 'lib', '*.rb')].each do |f|
  require f
end
