Given /^github is stubbed$/ do
  auth = [GITHUB_USER, GITHUB_PASSWORD].join(':')
  auth = "#{auth}@" unless auth.blank?
  stub_request(:put, "https://#{auth}api.github.com/teams/members/thoughtbot").with(:body => '{"name":"thoughtbot"}', :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).to_return(:status => 200, :body => "", :headers => {})
end
