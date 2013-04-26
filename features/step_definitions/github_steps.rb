Given /^github is stubbed$/ do
  auth = [GITHUB_USER, GITHUB_PASSWORD].join(':')
  auth = "#{auth}@" unless auth.blank?
  stub_request(:put, "https://#{auth}api.github.com/teams/members/cpytel").with(:body => '{"name":"cpytel"}', :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).to_return(:status => 200, :body => "", :headers => {})
end

Then /^I should see a github username error$/ do
  page.should have_css("li.error input#reader_1")
end
