if ENV['CHAT_LINK']
  CHAT_LINK = ENV['CHAT_LINK']
else
  CHAT_LINK = "http://thoughtbot.com/contact"
  Airbrake.notify(NoMethodError)
end
