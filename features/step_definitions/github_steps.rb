Given /^github is stubbed$/ do
  stub_request(:put, 'https://api.github.com/teams/9999/members/cpytel').
    to_return(:status => 200, :body => '', :headers => {})
  stub_request(:get, 'https://api.github.com/teams/3675/members/thoughtbot').
    to_return(:status => 404, :body => '', :headers => {})
end

Then /^I should see a github username error$/ do
  page.should have_css("li.error input#github_username_1")
end
