Then /^I am redirected to (.+)$/ do |page_name|
  if current_url.respond_to? :should
    current_url.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_url
  end
end
