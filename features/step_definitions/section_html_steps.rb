Then 'I see the empty section description' do
  page.should have_content('No courses are running at this time')
end

When 'I follow the external registration link' do
  url = find("*[@id='registration-link']")[:href]
  url.should_not be_nil, "cannot find the external registration link"

  Misc.rails_app = Capybara.app
  Capybara.app = Sinatra::Application
  visit url
end
