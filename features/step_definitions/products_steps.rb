When /^I add a download with file name "([^"]*)" and description "([^"]*)"$/ do |file_name, description|

  click_link "Add a download"

  path = File.join(Rails.root,"tmp/",file_name)
  File.open(path, 'w+') do |f|
    f.puts "Ths is a test file"
  end
  attach_file "Download", path
  sleep 10
  fill_in "Download Description", with: description
  sleep 10
end

When /^I remove a download with file name "([^"]*)"$/ do |file_name|
  click_link 'remove'
end

Then /^I should see "([^"]*)" in input field$/ do |text|
  page.should have_css('input', :value => "#{text}")
end

Then /^I should not see "([^"]*)" in input field$/ do |text|
  page.should_not have_css('input', :value => "#{text}")
end

