Then /^I am redirected to (.+)$/ do |page_name|
  url = URI.parse(path_to(page_name))
  page.should have_content("Current location: #{url.path} on #{url.host}")
end
