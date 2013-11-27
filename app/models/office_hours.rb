class OfficeHours
  DEFAULT_URL = 'http://thoughtbot.com/contact'
  DEFAULT_TIME = '10:30am Eastern'

  def self.url
    ENV['CHAT_LINK'] || DEFAULT_URL
  end

  def self.time
    ENV['OFFICE_HOURS'] || DEFAULT_TIME
  end
end
