require 'spec_helper'

describe OfficeHours do
  around(:each) do |example|
    old_env_url = ENV['CHAT_LINK']
    old_env_time = ENV['OFFICE_HOURS']

    example.run

    ENV['CHAT_LINK'] = old_env_url
    ENV['OFFICE_HOURS'] = old_env_time
  end

  describe '.url' do
    it 'returns the default url if environment not set' do
      ENV['CHAT_LINK'] = nil

      expect(OfficeHours.url).to eq OfficeHours::DEFAULT_URL
    end

    it 'returns the environment chat url when the url is set in the environment' do
      ENV['CHAT_LINK'] = 'http://test.com'

      expect(OfficeHours.url).to eq 'http://test.com'
    end
  end

  describe '.time' do
    it 'returns the default time if environment not set' do
      ENV['OFFICE_HOURS'] = nil

      expect(OfficeHours.time).to eq OfficeHours::DEFAULT_TIME
    end

    it 'returns the environment chat url when the time is set in the environment' do
      ENV['OFFICE_HOURS'] = '11am'

      expect(OfficeHours.time).to eq '11am'
    end
  end
end
