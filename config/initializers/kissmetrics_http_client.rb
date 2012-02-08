if Rails.env.test?
  KISSMETRICS_CLIENT_CLASS = FakeKissmetrics::HttpClient
else
  KISSMETRICS_CLIENT_CLASS = Kissmetrics::HttpClient
end
