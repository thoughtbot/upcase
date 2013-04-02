class KissmetricsClientFactory
  def self.client
    if Rails.env.test?
      FakeKissmetrics::HttpClient.new('fake-api-key')
    else
      Kissmetrics::HttpClient.new(KISSMETRICS_API_KEY)
    end
  end
end
