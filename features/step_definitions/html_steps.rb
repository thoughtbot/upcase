When 'I follow the link to $link_description' do |link_description|
  text_title_or_id = link_to(link_description)
  click_link(text_title_or_id)
end

Then 'I should see the admin header' do
  page.should have_css('h2', :text => 'Admin')
end
