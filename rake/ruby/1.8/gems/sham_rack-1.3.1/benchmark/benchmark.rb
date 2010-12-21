require "rubygems"

require "pathname"
dir = Pathname(__FILE__).parent
$LOAD_PATH.unshift(dir.parent + "lib")

require dir + "hello_app"
require "sham_rack"
require "restclient"

# mount an instance of the app using ShamRack
ShamRack.mount(HelloApp.new, "hello.sham")

# run another instance in a separate process
server_pid = fork do
  puts "Starting HTTP server on port 3333"
  $stdout = File.new('/dev/null', 'w')
  HelloApp.run!(:port => 3333)
end

at_exit do
  puts "Killing HTTP server"
  Process.kill("TERM", server_pid)
  Process.wait(server_pid)
end

puts "Waiting for server to come up"
begin
  puts RestClient.get("http://localhost:3333/hello/stranger")
rescue SystemCallError => e
  retry
end

iterations = (ARGV.shift || 1000).to_i

%w(hello.sham localhost:3333).each do |site|

  start = Time.now

  iterations.times do
    x = RestClient.get("http://#{site}/hello/stranger").to_s
  end

  elapsed_time = (Time.now - start)
  requests_per_second = iterations / elapsed_time.to_f

  printf "%-20s     #{iterations} requests in %f; %f per second\n", site, elapsed_time, requests_per_second
  
end
