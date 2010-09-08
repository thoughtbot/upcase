Then 'I see the successful $flash_name notice' do |flash_name|
  page.should have_css('div#flash_success')
  page.should have_content(flash_text_for(flash_name))
end

Then 'I see the $flash_name error' do |flash_name|
  page.should have_css('div#flash_error')
  page.should have_content(flash_text_for(flash_name))
end
