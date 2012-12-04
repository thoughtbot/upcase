#if Rails.env.test?
#  puts "KISSMETRICS_CLIENT_CLASS"
#  KISSMETRICS_CLIENT_CLASS = FakeKissmetrics::HttpClient
#else
#  KISSMETRICS_CLIENT_CLASS = Kissmetrics::HttpClient
#end

ApplicationController.km_http_client = Kissmetrics::HttpClient
