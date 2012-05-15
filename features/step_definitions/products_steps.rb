When /^I add a download with file name "([^"]*)" and description "([^"]*)"$/ do |file_name, description|

  click_link "Add a download"

  path = File.join("tmp/",file_name)
  File.open(path, 'w+') do |f|
    f.puts "Ths is a test file"
  end
  attach_file "Upload File", path

  fill_in "description", with: description
end

When /^I remove a download with file name "([^"]*)"$/ do |file_name|
  page.driver.browser.execute_script %Q{
    $('input[value="#{file_name}"]').parent().parent().next('.remove_nested_fields').click();
  }
end

Then /^I should see "([^"]*)" in input field$/ do |text|
  page.should have_css('input', :value => "#{text}")
end

Then /^I should not see "([^"]*)" in input field$/ do |text|
  page.should_not have_css('input', :value => "#{text}")
end

