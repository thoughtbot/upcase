def expect_page_to_have_meta_description(expected_description)
  meta_tag = page.find("meta[name=Description]", visible: false)
  expect(meta_tag['content']).to eq expected_description
end

def expect_page_to_have_title(expected_page_title)
  expect(page).to have_css("title", text: expected_page_title, visible: false)
end
