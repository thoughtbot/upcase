require 'spec_helper'

describe '.client' do
  it 'returns the fake client when running in the test environment' do
    fake_kissmetrics_client = FakeKissmetrics::HttpClient
    expect(KissmetricsClientFactory.client).to be_a fake_kissmetrics_client
  end

  it 'returns the real client when not in the test environment' do
    change_to_non_test_environment do
      real_kissmetrics_client = Kissmetrics::HttpClient
      expect(KissmetricsClientFactory.client).to be_a real_kissmetrics_client
    end
  end

  def change_to_non_test_environment
    Rails.env = 'not-test'
    yield
  ensure
    Rails.env = 'test'
  end
end
