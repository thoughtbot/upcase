def expect_page_to_have_meta_description(expected_description)
  meta_tag = page.find('meta[name=Description]')
  expect(meta_tag['content']).to eq expected_description
end

def expect_page_to_have_meta_keywords(expected_keywords)
  meta_tag = page.find('meta[name=Keywords]')
  expect(meta_tag['content']).to eq expected_keywords
end

def expect_page_to_have_title(expected_page_title)
  expect(page).to have_css('title', text: expected_page_title)
end
