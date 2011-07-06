When %r{^I follow ([^\"]+)$} do |named_element|
  selector = selector_for(named_element)
  find(selector).click
end

Then /^(.*) should be hidden$/ do |named_element|
  selector = selector_for(named_element)
  if Capybara.current_driver == :akephalos
    page.evaluate_script("$('#{selector}:visible').length").to_i.should == 0
  else
    find(selector).should_not be_visible
  end
end

Then /^(.*) should be visible/ do |named_element|
  selector = selector_for(named_element)
  if Capybara.current_driver == :akephalos
    page.evaluate_script("$('#{selector}:visible').length").to_i.should > 0
  else
    find(selector).should be_visible
  end
end

When %r{^I click ([^\"].*)$} do |named_element|
  selector = selector_for(named_element)
  find(selector).click
end

Then /^the page should (not )?contain ([^\"].*)$/ do |should_not_contain, named_element|
  selector = selector_for(named_element)

  if should_not_contain.present?
    page.should have_no_css(selector)
  else
    page.should have_css(selector)
  end
end

Then /^([\w\s]+) should have a value of "([^\"]+)"$/ do |named_element, value|
  selector = selector_for(named_element)
  find(selector).value.should == value
end

Then /^([^\"].*) should be empty$/ do |named_element|
  selector = selector_for(named_element)
  find(selector).text.strip.should == ""
end

Then /^I should not see ([\w\s]+) inside ([\w\s]+)$/ do |named_element, scope_named_element|
  scope = selector_for(scope_named_element)
  selector = selector_for(named_element)
  within(scope) do
    page.should have_no_css(selector)
  end
end

Then /^I should see ([\w\s]+) inside ([\w\s]+)$/ do |named_element, scope_named_element|
  scope = selector_for(scope_named_element)
  selector = selector_for(named_element)
  within(scope) do
    page.should have_css(selector)
  end
end
