Then 'I see the successful $flash_name notice' do |flash_name|
  page.should have_css('.flash.success'),
    "expected to see the success flash message"
  page.should have_content(flash_text_for(flash_name))
end

Then 'I see the failure $flash_name notice' do |flash_name|
  page.should have_css('.flash.failure'),
    "expected to see the failure flash message"
    page.should have_content(flash_text_for(flash_name))
end

Then 'I see the $flash_name error' do |flash_name|
  page.should have_css('.flash.error'),
    "expected to see the error flash message"
  page.should have_content(flash_text_for(flash_name)),
    "expected to see #{flash_text_for(flash_name).inspect}"
end
