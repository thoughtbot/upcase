Then 'I see the successful $flash_name notice' do |flash_name|
  page.should have_css('div#flash_success')
  page.should have_content(flash_text_for(flash_name))
end
