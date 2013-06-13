Given 'I create the following workshop:' do |workshop_fields|
  steps %{
    Given I go to the admin page
    And I follow "New Workshop"
  }
  And "I fill in the following:", workshop_fields
  steps %{
    And I press "Create Workshop"
    Then I see the successful workshop creation notice
  }
end

Then /^I should see the json for the active workshops$/ do
  workshops = Workshop.only_active
  JSON.parse(page.source).should == JSON.parse(workshops_json(workshops))
end

Then /^I should see the json for the active workshops with the callback "([^"]*)"$/ do |callback|
  workshops = Workshop.only_active
  matcher = /#{callback}\(([^\)]+)\)/
  matches = matcher.match(page.source)
  JSON.parse(matches[1]).should == JSON.parse(workshops_json(workshops))
end

Given /^a non-active workshop "([^"]*)"$/ do |workshop_name|
  workshop = Workshop.find_by_name!(workshop_name)
  workshop.active = false
  workshop.save!
end

When /^I attach an image name "([^"]*)" to the workshop$/ do |image_name|
  path = File.join(Rails.root, "tmp/", image_name)
  test_image_path = File.join(Rails.root,"features/support/files/test.jpg")
  FileUtils.mkdir_p(Rails.root.join("tmp"))
  FileUtils.cp(test_image_path, path)
  attach_file "Workshop image", path
end

When /^I view the in-person workshop "([^"]+)"$/ do |workshop_name|
  workshop = Workshop.where(name: workshop_name, online: false).first
  visit workshop_path(workshop)
end

When /^I view the online workshop "([^"]+)"$/ do |workshop_name|
  workshop = Workshop.where(name: workshop_name, online: true).first
  visit workshop_path(workshop)
end

Then /^I should see that "([^"]*)" is an online workshop$/ do |workshop_name|
  find('[data-role=online-workshop]').should have_content workshop_name
end

Then /^I should see that "([^"]*)" is an in-person workshop$/ do |workshop_name|
  find('[data-role=in-person-workshop]').should have_content workshop_name
end

Then /^I should see the date range$/ do
  page.should have_selector('[data-role=date-range]')
end

Then /^I should not see the date range$/ do
  page.should have_no_selector('[data-role=date-range]')
end

Then /^I should see a product title of "([^"]*)"$/ do |title|
  find('.product-title h2').should have_content title
end

Then /^I should see a link to the in-person workshop$/ do
  workshop_name = find('.subject').text
  in_person_workshop = Workshop.in_person.find_by_name!(workshop_name)
  find('.workshop-alert a')[:href].should == workshop_path(in_person_workshop)
end

Then /^I should see a link to the online workshop$/ do
  workshop_name = find('.subject').text
  online_workshop = Workshop.online.find_by_name!(workshop_name)
  find('.workshop-alert a')[:href].should == workshop_path(online_workshop)
end

Then /^I should see that the related workshop "([^"]+)" is in-person$/ do |workshop_name|
  type_of_related_workshop_named(workshop_name).should == 'In-person workshop'
end

Then /^I should see that the related workshop "([^"]+)" is online$/ do |workshop_name|
  type_of_related_workshop_named(workshop_name).should == 'Online workshop'
end

Then /^I should see a workshop alert for the in-person workshop$/ do
  find('.workshop-alert').text.should =~ /In-Person Workshop/
end

Then /^I should see a workshop alert for the online workshop$/ do
  find('.workshop-alert').text.should =~ /Online Workshop/
end

Then /^I should not see a workshop alert$/ do
  page.should_not have_css('.workshop-alert')
end

World(WorkshopsHelper)
