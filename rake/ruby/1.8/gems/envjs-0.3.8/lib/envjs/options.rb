require 'optparse'

$envjsrb_wake = false

OptionParser.new do |o|

  o.on("--wake") do |path|
    $envjsrb_wake = true
  end

end.parse!
