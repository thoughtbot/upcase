Given /^github is stubbed$/ do
  stub_request(:put, 'https://cpytel:eqZUjxaaaqk33ob@api.github.com/teams/members/thoughtbot').with(:body => '{"name":"thoughtbot"}', :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).to_return(:status => 200, :body => "", :headers => {})
end
