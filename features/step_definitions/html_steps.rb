When 'I follow the link to $link_description' do |link_description|
  text_title_or_id = link_to(link_description)
  click_link(text_title_or_id)
end

Then 'I should see the admin header' do
  page.should have_css('h2', :text => 'Admin')
end

Then /^I see the link to the admin interface$/ do
  text_title = link_to('admin interface')
  page.should have_xpath("//a[contains(.,'#{text_title}')]")
end

Then /^I do not see the link to the admin interface$/ do
  text_title = link_to('admin interface')
  page.should have_no_xpath("//a[contains(.,'#{text_title}')]")
end
