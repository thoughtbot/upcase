When 'I save and open the page' do
  save_and_open_page
end

Then /^show me the sent emails?$/ do
  pretty_emails = ActionMailer::Base.deliveries.map do |mail|
    <<-OUT
To: #{mail.to.inspect}
From: #{mail.from.inspect}
Subject: #{mail.subject}
Body:
#{mail.body}
.
    OUT
  end
  puts pretty_emails.join("\n")
end

Then 'I pause for 60 seconds' do
  sleep 60
end

When 'I enter the debugger' do
  require 'ruby-debug'
  debugger
  true
end
