When 'I follow the link to $link_description' do |link_description|
  text_title_or_id = link_to(link_description)
  click_link(text_title_or_id)
end
